import os
import re

def normalize_line_endings(text):
    return text.replace('\r\n', '\n').replace('\r', '\n')

def is_comment_line(line, in_multiline_comment):
    # Single-line comment
    if line.strip().startswith('//'):
        return True, in_multiline_comment
    # Start of multiline comment
    if not in_multiline_comment and '/*' in line:
        if '*/' in line:
            return True, in_multiline_comment
        else:
            return True, True
    # Inside multiline comment
    if in_multiline_comment:
        if '*/' in line:
            return True, False
        else:
            return True, True
    return False, in_multiline_comment

def process_dm_file(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = normalize_line_endings(f.read())
    lines = content.split('\n')
    output = []
    n = len(lines)

    armor_found = {}      # path -> armor_value (string)
    path_blocks = []      # (path, first_line_idx, last_line_idx, [armor_start_idx, armor_end_idx])

    # Match DM path lines, allowing for special characters, spaces, and indent
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
                # Find the end of the block: next line that's NOT indented and not blank, or EOF
                j = i + 1
                in_block_multiline_comment = in_multiline_comment
                while j < n:
                    next_line = lines[j]
                    is_block_comment, in_block_multiline_comment = is_comment_line(next_line, in_block_multiline_comment)
                    if is_block_comment:
                        j += 1
                        continue
                    # A block member line is indented (space or tab) or blank
                    if (next_line.startswith(' ') or next_line.startswith('\t')) or next_line.strip() == '':
                        j += 1
                    else:
                        break
                block_end = j - 1

                # Now search for armor inside this block, skipping comment lines
                armor_start_idx = None
                armor_end_idx = None
                armor_val = None
                j = block_start + 1
                in_block_multiline_comment = in_multiline_comment
                while j <= block_end:
                    l = lines[j]
                    is_block_comment, in_block_multiline_comment = is_comment_line(l, in_block_multiline_comment)
                    if not is_block_comment:
                        # Match the armor assignment
                        armor_start_match = re.match(r'^\s*armor\s*=\s*list\s*\((.*)', l)
                        if armor_start_match:
                            armor_start_idx = j
                            armor_lines = [armor_start_match.group(1)]
                            if ')' in armor_lines[0]:
                                armor_val = armor_lines[0].split(')',1)[0].strip()
                                armor_end_idx = j
                            else:
                                paren_count = armor_lines[0].count('(') - armor_lines[0].count(')')
                                k = j
                                while paren_count > 0 and k + 1 <= block_end:
                                    k += 1
                                    nextl = lines[k]
                                    armor_lines.append(nextl)
                                    paren_count += nextl.count('(') - nextl.count(')')
                                armor_val_joined = '\n'.join(armor_lines)
                                armor_val = armor_val_joined.split(')',1)[0].strip()
                                armor_end_idx = k
                            break
                    j += 1
                if armor_start_idx is not None and armor_val is not None:
                    armor_found[path] = armor_val
                    path_blocks.append((path, block_start, block_end, armor_start_idx, armor_end_idx))
                else:
                    path_blocks.append((path, block_start, block_end, None, None))
                i = block_end + 1
                continue
        i += 1

    # Remove armor lines from path blocks (but not comments)
    lines_mod = lines[:]
    for path, start, end, armor_start_idx, armor_end_idx in path_blocks:
        if armor_start_idx is not None and armor_end_idx is not None:
            for idx in range(armor_start_idx, armor_end_idx + 1):
                l = lines[idx]
                in_multiline_comment = False
                is_comment, in_multiline_comment = is_comment_line(l, in_multiline_comment)
                if not is_comment:
                    lines_mod[idx] = None  # Remove the line

    # For each path with armor, ensure it is in TYPEINFO_DEF, insert/appends if needed
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
            if path in armor_found and path not in already_inserted:
                output.insert(len(output) - (block_end - block_start), f'	default_armor = list({armor_found[path]})')
                already_inserted.add(path)
            i = block_end + 1
            continue

        path_match = path_line_regex.match(line)
        if path_match:
            path = '/' + path_match.group(1)
            if path in armor_found and path not in already_inserted:
                output.append(f'TYPEINFO_DEF({path})')
                output.append(f'	default_armor = list({armor_found[path]})')
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

def process_all_dm_files():
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.dm'):
                print(f"Processing {file}")
                process_dm_file(os.path.join(root, file))

if __name__ == "__main__":
    process_all_dm_files()
    print("Done!")
