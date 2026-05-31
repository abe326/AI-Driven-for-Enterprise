"""Office ファイル変換スクリプト群（docx/pptx/xlsx ↔ md）の共通ユーティリティ"""

import sys
from pathlib import Path
from typing import NoReturn


def md_table_cell(value) -> str:
    """セル値を Markdown テーブル用に正規化する。改行を空白に、| をエスケープ。"""
    if value is None:
        return ""
    return str(value).replace("\n", " ").replace("|", "\\|").strip()


def rows_to_md_table(rows) -> list[str]:
    """2 次元のセル配列を Markdown テーブル行のリストに変換する（先頭行をヘッダ扱い）。"""
    lines: list[str] = []
    if not rows:
        return lines
    for i, row in enumerate(rows):
        cells = [md_table_cell(c) for c in row]
        lines.append("| " + " | ".join(cells) + " |")
        if i == 0:
            lines.append("| " + " | ".join(["---"] * len(cells)) + " |")
    return lines


def validate_input_file(input_arg: str, expected_ext: str) -> Path:
    """入力ファイルパスの存在と拡張子を検証する。エラー時は exit(1)。"""
    resolved = Path(input_arg).resolve()
    if not resolved.exists():
        print(f"エラー: ファイルが見つかりません: {resolved}", file=sys.stderr)
        sys.exit(1)
    if resolved.suffix.lower() != expected_ext:
        print(f"エラー: {expected_ext} ファイルを指定してください: {resolved}", file=sys.stderr)
        sys.exit(1)
    return resolved


def default_images_dir(input_path: Path) -> Path:
    """画像抽出先のデフォルトパス: <input_dir>/<input_stem>_images"""
    return input_path.parent / f"{input_path.stem}_images"


def fail_missing_dependency(pip_name: str) -> NoReturn:
    """依存パッケージ未インストール時のエラーメッセージを出して exit(1)。"""
    print(f"エラー: {pip_name} が未インストールです。", file=sys.stderr)
    print(f"  pip install {pip_name}", file=sys.stderr)
    sys.exit(1)
