#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
将测试用例 JSON 文件转换为 Markdown 格式。

每条用例展开为一行完整路径：
  功能点 > [子功能点 >] 测试点 > 用例/测试步骤 > 预期结果
"""

import json
import sys
import os


def load_json(filepath: str) -> list:
    with open(filepath, "r", encoding="utf-8") as f:
        return json.load(f)


def flatten(node: dict, path: list[str], results: list[str]):
    """递归遍历树，到达 type=5 时拼出完整路径行"""
    node_type = node.get("caseNodeType")
    name = node.get("name", "")
    children = node.get("children", [])

    if node_type == 1:
        # 根节点，不加入路径，直接递归
        for child in children:
            flatten(child, path, results)

    elif node_type in (2, 3, 4):
        # 功能点 / 子功能点 / 测试点 → 追加到路径，继续递归
        for child in children:
            flatten(child, path + [name], results)

    elif node_type == 5:
        # 用例/测试步骤 → 找预期结果，输出完整行
        expected = ""
        for child in children:
            if child.get("caseNodeType") == 6:
                expected = child.get("name", "")
                break
        # 预期结果中的换行替换为 "; "
        expected_clean = expected.replace("\n", "; ")
        full_path = path + [name, expected_clean]
        results.append(" > ".join(full_path))

    elif node_type == 6:
        # 预期结果由 type=5 处理，跳过
        pass

    else:
        # 未知类型，继续递归
        for child in children:
            flatten(child, path + [name] if name else path, results)


def convert(input_path: str, output_path: str = None):
    if output_path is None:
        base = os.path.splitext(input_path)[0]
        output_path = base + ".md"

    data = load_json(input_path)
    results: list[str] = []

    for root_node in data:
        flatten(root_node, [], results)

    # 每行一条，编号输出
    lines = [f"{i+1}. {line}" for i, line in enumerate(results)]
    content = "\n".join(lines)

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"转换完成: {output_path}（共 {len(results)} 条用例）")
    return output_path


if __name__ == "__main__":
    if len(sys.argv) < 2:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        txt_files = [
            os.path.join(script_dir, f)
            for f in os.listdir(script_dir)
            if f.startswith("test_") and f.endswith(".txt")
        ]
        if not txt_files:
            print("用法: python convert_to_md.py <input.txt> [output.md]")
            print("  或将脚本放在 test_*.txt 同目录下直接运行")
            sys.exit(1)
        for txt_file in txt_files:
            convert(txt_file)
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2] if len(sys.argv) > 2 else None
        convert(input_file, output_file)
