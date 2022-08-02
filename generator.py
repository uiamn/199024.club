import glob
from io import TextIOWrapper
from typing import List
from collections import deque

def get_all_content_path() -> List[str]:
    return glob.glob('content/**/????????', recursive=True)


def calc_n_top_spaces(line: str) -> int:
    i = 0
    while line[i] == ' ':
        i += 1

    return i

def append_dom(filepath: str, outfile: TextIOWrapper) -> str:
    date = filepath.split('/')[-1]

    dom = f'<div class="entry"><h2>■ {date[0:4]} 年 {int(date[4:6])} 月 {int(date[6:8])} 日</h2>'

    with open(filepath) as f:
        indent_stack = deque([0])
        while (line := f.readline()):
            if line == '\n':
                continue

            n_top_spaces = calc_n_top_spaces(line)
            line = line.strip().replace('っ', 'つ')

            if indent_stack[-1] == n_top_spaces:
                if n_top_spaces == 0:
                    dom += f'<h3>{line}</h3><div>'
                else:
                    dom += f'<li>{line}</li>'
            elif indent_stack[-1] < n_top_spaces:
                indent_stack.append(n_top_spaces)
                dom += f'<ul><li>{line}</li>'
            else:
                while indent_stack[-1] != n_top_spaces and len(indent_stack) != 0:
                    indent_stack.pop()
                    dom += '</ul>'

                if n_top_spaces == 0:
                    dom += f'</div><h3>{line}</h3><div>'
                else:
                    dom += f'<li>{line}</li>'

    dom += '</div></div>'

    outfile.write(dom)

if __name__ == '__main__':
    all_content_path = sorted(get_all_content_path(), reverse=True)

    with open('index.html', 'w') as f:
        f.write('')

    with open('index.html', 'a') as f:
        f.write('<!DOCTYPE html><html><head><meta charset="utf-8"><title>日記</title><link rel="stylesheet" type="text/css" href="style.css"></head><body><div>')

        for cp in all_content_path:
            append_dom(cp, f)

        f.write('</div></body>')
