---
name: aide-export
description: 既存の成果物（要件書・設計書・製造計画書など）を HTML・PDF・docx・pptx 形式に変換し、提出用ドキュメントを生成する。「提出用ファイルを作りたい」「PDFに変換して」「Word形式にしたい」「HTML版を作って」と言われたら使う。新規のスライド・報告書・見積書を作る場合は aide-pm-slide を使う。
short_description: 成果物（要件書・設計書等）を HTML / PDF / docx に一括変換する
---

# aide-export: 成果物エクスポート

成果物を提出用形式に変換する。**基本フロー: md → HTML →（PDF / docx / pptx）**。HTML を中間形式として必ず生成する（HTML-First）。

## テンプレート（`.aide/templates/export/`）
| ファイル | 用途 |
|---|---|
| `document-template.html` / `document-style.css` | 提出用ドキュメント |
| `estimate-template.html` | 見積書 |
| `schedule-template.html` | スケジュール表（ガント） |
| `discussion-template.html` | ディスカッション資料 |
| `marp-theme.css` / `slide-template.md` | スライド |

## 手順

### 1. 対象の特定
プロファイルの作業フォルダから、変換対象の成果物を特定する。種別（ドキュメント／見積書／スケジュール／ディスカッション／スライド）に応じてテンプレートを選ぶ。

### 2. 変換（OS対応）
- md → HTML（テンプレート適用）
- HTML → PDF / docx / pptx（pandoc 等）。**コマンドは OS で読み替える**（[クロスプラットフォーム](../../rules.md#クロスプラットフォーム)：`python3`⇔`python`/`py`）
- 図（`.drawio.svg`）は埋め込み or 添付

### 3. 出力と確認
変換物を作業フォルダの該当フェーズ（または `export/`）に出力し、生成物一覧を報告する。フェーズ完了を待たずいつでも実行可能。

## 注意事項
- 正本は md。変換物は提出用の派生（正本と矛盾させない）
- 必要ツール（pandoc 等）が未導入なら導入を案内（OS別コマンド）
