# DISCLAIMER: ChatGPT wrote 95% of this.
# It interacts weirdly with multi-line strings.
# USAGE: Create a text file containing VAR_TO_CAPTURE : VAR_TO_INSERT.
# The script will capture and remove the variable from typedefs and insert them into associated TYPEINFO_DEF(), creating one if it does not exist.

import os
import re
import sys

def normalize_line_endings(text):
    return text.replace('\r\n', '\n').replace('\r', '\n')

def is_comment_line(line, in_multiline_comment):
    if line.strip().startswith('//'):
        return True, in_multiline_comment
    if not in_multiline_comment and '/*' in line:
        if '*/' in line:
            return True, in_multiline_comment
        else:
            return True, True
    if in_multiline_comment:
        if '*/' in line:
            return True, False
        else:
            return True, True
    return False, in_multiline_comment

def parse_config(config_path):
    with open(config_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            if ':' in line:
                old, new = line.split(':', 1)
                return old.strip(), new.strip()
    raise ValueError("Config file must contain a line formatted as: old_var : new_var")

def find_dme_directory(start_dir):
    # Search up to 2 ancestors for a .dme file
    cur = os.path.abspath(start_dir)
    for _ in range(3):
        for f in os.listdir(cur):
            if f.lower().endswith('.dme'):
                return cur
        parent = os.path.dirname(cur)
        if parent == cur:
            break
        cur = parent
    return None

def process_dm_file(filepath, old_var, new_var):
    with open(filepath, "r", encoding="utf-8") as f:
        content = normalize_line_endings(f.read())
    lines = content.split('\n')
    output = []
    n = len(lines)

    var_found = {}      # path -> var_value (string)
    path_blocks = []    # (path, block_start, block_end, [var_start_idx, var_end_idx])

    path_line_regex = re.compile(r'^\s*/([^\s{]+)')

    i = 0
    in_multiline_comment = False
    while i < n:
        line = lines[i]
        is_comment, in_multiline_comment = is_comment_line(line, in_multiline_comment)
        if not is_comment:
            path_match = path_line_regex.match(line)
            if path_match:
                path = '/' + path_match.group(1)
                block_start = i
                block_end = i
                j = i + 1
                in_block_multiline_comment = in_multiline_comment
                while j < n:
                    next_line = lines[j]
                    is_block_comment, in_block_multiline_comment = is_comment_line(next_line, in_block_multiline_comment)
                    if is_block_comment:
                        j += 1
                        continue
                    if (next_line.startswith(' ') or next_line.startswith('\t')) or next_line.strip() == '':
                        j += 1
                    else:
                        break
                block_end = j - 1

                # Search for variable in block, skipping comment lines
                var_start_idx = None
                var_end_idx = None
                var_val = None
                j = block_start + 1
                in_block_multiline_comment = in_multiline_comment
                while j <= block_end:
                    l = lines[j]
                    is_block_comment, in_block_multiline_comment = is_comment_line(l, in_block_multiline_comment)
                    if not is_block_comment:
                        # Multi-line assignment
                        var_start = re.match(r'^\s*' + re.escape(old_var) + r'\s*=\s*list\s*\($', l)
                        if var_start:
                            var_start_idx = j
                            var_lines = []
                            k = j + 1
                            in_var_multiline_comment = False
                            while k <= block_end:
                                l2 = lines[k]
                                is_var_comment, in_var_multiline_comment = is_comment_line(l2, in_var_multiline_comment)
                                if not is_var_comment:
                                    if ')' in l2:
                                        var_lines.append(l2.split(')', 1)[0])
                                        var_end_idx = k
                                        break
                                    var_lines.append(l2)
                                k += 1
                            var_items = [a.strip().rstrip(',') for a in var_lines if a.strip() != '']
                            var_val = ', '.join(var_items)
                            break
                        # Single-line assignment
                        var_single = re.match(r'^\s*' + re.escape(old_var) + r'\s*=\s*list\s*\((.*)\)\s*$', l)
                        if var_single:
                            var_start_idx = j
                            var_end_idx = j
                            var_val = var_single.group(1).strip()
                            break
                    j += 1
                if var_start_idx is not None and var_val is not None:
                    var_found[path] = var_val
                    path_blocks.append((path, block_start, block_end, var_start_idx, var_end_idx))
                else:
                    path_blocks.append((path, block_start, block_end, None, None))
                i = block_end + 1
                continue
        i += 1

    # Remove old variable lines from path blocks (but not comments)
    lines_mod = lines[:]
    for path, start, end, var_start_idx, var_end_idx in path_blocks:
        if var_start_idx is not None and var_end_idx is not None:
            for idx in range(var_start_idx, var_end_idx + 1):
                l = lines[idx]
                in_multiline_comment = False
                is_comment, in_multiline_comment = is_comment_line(l, in_multiline_comment)
                if not is_comment:
                    lines_mod[idx] = None

    i = 0
    n = len(lines_mod)
    already_inserted = set()
    typeinfo_def_regex = re.compile(r'^\s*TYPEINFO_DEF\s*\(\s*([^\)]+)\s*\)')
    while i < n:
        line = lines_mod[i]
        if line is None:
            i += 1
            continue

        typeinfo_match = typeinfo_def_regex.match(line)
        if typeinfo_match:
            path = typeinfo_match.group(1).strip()
            output.append(line)
            block_start = i
            block_end = i
            while (
                block_end + 1 < n and
                lines_mod[block_end + 1] is not None and
                (lines_mod[block_end + 1].startswith(' ') or lines_mod[block_end + 1].startswith('\t'))
            ):
                block_end += 1
                output.append(lines_mod[block_end])
            if path in var_found and path not in already_inserted:
                output.insert(len(output) - (block_end - block_start), f'    {new_var} = list({var_found[path]})')
                already_inserted.add(path)
            i = block_end + 1
            continue

        path_match = path_line_regex.match(line)
        if path_match:
            path = '/' + path_match.group(1)
            if path in var_found and path not in already_inserted:
                output.append(f'TYPEINFO_DEF({path})')
                output.append(f'    {new_var} = list({var_found[path]})')
                output.append('')
                already_inserted.add(path)
        output.append(line)
        i += 1

    output = [l for l in output if l is not None]

    trailing_blanks = 0
    for l in reversed(lines):
        if l.strip() == '':
            trailing_blanks += 1
        else:
            break
    while output and output[-1] == '':
        output.pop()
    output.extend([''] * trailing_blanks)

    with open(filepath, "w", encoding="utf-8", newline='\n') as f:
        f.write('\n'.join(output))

def process_all_dm_files(root_dir, old_var, new_var):
    for dirpath, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.dm'):
                print(f"Processing {file}")
                process_dm_file(os.path.join(dirpath, file), old_var, new_var)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python dm_var_typeinfo_fix.py <config.txt>")
        sys.exit(1)

    config_path = sys.argv[1]
    old_var, new_var = parse_config(config_path)
    project_dir = find_dme_directory(os.getcwd())

    if not project_dir:
        print("Could not find a .dme file in this or parent directories (up to 2).")
        sys.exit(2)

    process_all_dm_files(project_dir, old_var, new_var)
    print("Done!")
