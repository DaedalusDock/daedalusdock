import os
import re

def normalize_line_endings(text):
    # Replace CRLF and CR with LF
    return text.replace('\r\n', '\n').replace('\r', '\n')

def process_dm_file(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        content = normalize_line_endings(f.read())

    lines = content.split('\n')
    output = []
    i = 0
    n = len(lines)

    # Track all TYPEINFO_DEF blocks and path blocks
    typeinfo_blocks = {}  # path -> (block_start_idx, block_end_idx)
    armor_found = {}      # path -> armor_value (string)
    path_blocks = []      # (path, first_line_idx, last_line_idx)

    # Find all TYPEINFO_DEF and path blocks, and armor to remove
    while i < n:
        line = lines[i]
        typeinfo_match = re.match(r'^\s*TYPEINFO_DEF\s*\(\s*([^\)]+)\s*\)', line)
        path_match = re.match(r'^\s*/([a-zA-Z0-9_/]+)', line)

        # Detect TYPEINFO_DEF block
        if typeinfo_match:
            path = typeinfo_match.group(1).strip()
            block_start = i
            block_end = i
            # Find the end of TYPEINFO_DEF block (next non-indented or empty line)
            while block_end + 1 < n and (lines[block_end+1].startswith(' ') or lines[block_end+1].startswith('\t')) and lines[block_end+1].strip() != '':
                block_end += 1
            typeinfo_blocks[path] = (block_start, block_end)
            i = block_end + 1
            continue

        # Detect path block
        elif path_match:
            path = '/' + path_match.group(1)
            block_start = i
            block_end = i
            # Find the end of the path block (next line that is not more indented or is blank)
            while block_end + 1 < n and (lines[block_end+1].startswith(' ') or lines[block_end+1].startswith('\t')) and lines[block_end+1].strip() != '':
                block_end += 1
            # Look for armor in block
            armor_idx = None
            armor_val = None
            for j in range(block_start+1, block_end+1):
                armor_match = re.match(r'^\s*armor\s*=\s*list\((.*)\)\s*$', lines[j])
                if armor_match:
                    armor_idx = j
                    armor_val = armor_match.group(1)
                    break
            if armor_idx is not None:
                armor_found[path] = armor_val
            path_blocks.append((path, block_start, block_end, armor_idx))
            i = block_end + 1
            continue

        i += 1

    # Remove armor lines from path blocks
    lines_mod = lines[:]
    for path, start, end, armor_idx in path_blocks:
        if armor_idx is not None:
            lines_mod[armor_idx] = None  # Remove the line

    # For each path with armor, ensure it is in TYPEINFO_DEF, insert/appends if needed
    # We'll do this by creating a new output list line by line, inserting as we go
    i = 0
    n = len(lines_mod)
    already_inserted = set()
    while i < n:
        line = lines_mod[i]
        if line is None:
            i += 1
            continue

        # If this is a TYPEINFO_DEF for a path with armor, append default_armor to it
        typeinfo_match = re.match(r'^\s*TYPEINFO_DEF\s*\(\s*([^\)]+)\s*\)', line)
        if typeinfo_match:
            path = typeinfo_match.group(1).strip()
            output.append(line)
            block_start = i
            block_end = i
            while block_end + 1 < n and lines_mod[block_end+1] and (lines_mod[block_end+1].startswith(' ') or lines_mod[block_end+1].startswith('\t')):
                block_end += 1
                output.append(lines_mod[block_end])
            if path in armor_found and path not in already_inserted:
                # Insert default_armor after TYPEINFO_DEF and before any existing lines in block
                output.insert(len(output)-(block_end-block_start), f'	default_armor = list({armor_found[path]})')
                already_inserted.add(path)
            i = block_end + 1
            continue

        # If this is a path block and needs TYPEINFO_DEF above it
        path_match = re.match(r'^\s*/([a-zA-Z0-9_/]+)', line)
        if path_match:
            path = '/' + path_match.group(1)
            if path in armor_found and path not in already_inserted:
                # Insert TYPEINFO_DEF block before this line
                output.append(f'TYPEINFO_DEF({path})')
                output.append(f'	default_armor = list({armor_found[path]})')
                output.append('')  # Trailing new line as required
                already_inserted.add(path)
        output.append(line)
        i += 1

    # Remove any None lines (armor removed)
    output = [l for l in output if l is not None]

    # --- Do NOT trim blank lines from the end! ---
    # Instead, preserve the original count of trailing blank lines
    trailing_blanks = 0
    for l in reversed(lines):
        if l.strip() == '':
            trailing_blanks += 1
        else:
            break
    # Remove all trailing blanks from output
    while output and output[-1] == '':
        output.pop()
    # Add back the original number of trailing blank lines
    output.extend([''] * trailing_blanks)

    # Write file with LF newlines only
    with open(filepath, "w", encoding="utf-8", newline='\n') as f:
        f.write('\n'.join(output))

def process_all_dm_files():
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.dm'):
                process_dm_file(os.path.join(root, file))

if __name__ == "__main__":
    process_all_dm_files()
