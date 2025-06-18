import os
import re

def process_dm_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        # Normalize all line endings to LF while reading
        lines = f.read().replace('\r\n', '\n').replace('\r', '\n').split('\n')
        # Add back the newlines for all but the last line (which might be empty due to split)
        lines = [line + '\n' for line in lines[:-1]] + ([lines[-1]] if lines[-1] else [])

    output_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        # Detect path definitions (e.g., /obj/foo)
        path_match = re.match(r'^([ \t]*)/([^\n]+)', line)
        if path_match:
            path_indent = path_match.group(1)
            path_line = line.rstrip('\n')
            block_lines = []
            block_start = i
            block_lines.append(line)
            i += 1

            # Gather the block under this path
            while i < len(lines):
                next_line = lines[i]
                if re.match(r'^([ \t]*)/([^\n]+)', next_line):
                    break
                block_lines.append(next_line)
                i += 1

            # Search for custom_materials in the block
            custom_materials_found = False
            default_materials_line = ""
            new_block = []
            for blk_line in block_lines[1:]:  # skip the path definition
                custom_match = re.match(r'^([ \t]*)custom_materials\s*=\s*(list\(.*\))', blk_line)
                if custom_match:
                    custom_materials_found = True
                    indent = custom_match.group(1)
                    value = custom_match.group(2)
                    # Add a trailing line after default_materials and ensure LF
                    default_materials_line = f"{indent}default_materials = {value}\n\n"
                    # Do not add this line to new_block (removes it)
                else:
                    new_block.append(blk_line)

            if custom_materials_found:
                # Insert TYPEINFO_DEF and default_materials above the path definition
                output_lines.append(f'TYPEINFO_DEF({path_line.strip()})\n')
                output_lines.append(default_materials_line)
                output_lines.append(path_line + '\n')
                output_lines.extend(new_block)
            else:
                output_lines.extend(block_lines)
        else:
            output_lines.append(line)
            i += 1

    # Write back with LF line endings only
    with open(filepath, 'w', encoding='utf-8', newline='\n') as f:
        # Remove any accidental CR or CRLF, force LF
        f.write(''.join(output_lines).replace('\r\n', '\n').replace('\r', '\n'))

def main():
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.dm'):
                path = os.path.join(root, file)
                process_dm_file(path)

if __name__ == "__main__":
    main()
