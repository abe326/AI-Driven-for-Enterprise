---
name: aide-pm-slide
description: スライド・見積書・スケジュール表・ディスカッション資料の4種類を自動判定して作成する。「スライドを作って」「提案資料を作りたい」「見積書を作って」「報告書が欲しい」と言われたら使う。SCQ（Situation-Complication-Question）で構成を立て、CRAP 原則で読みやすく仕上げる。既存成果物をPDF/Word/HTMLに変換する場合は aide-export を使う。
short_description: 資料を自動判定して生成する（スライド/見積書/スケジュール/ディスカッション資料）
---

# aide-pm-slide: 資料作成（自動判定）

依頼内容から資料種別を判定し、適切な形式で生成する。

## 手順

### 1. 資料種別の判定
| 種別 | 手がかり | 形式 / 連携 |
|---|---|---|
| 説明・報告スライド | 「説明」「報告」「提案」「プレゼン」 | Marp スライド |
| 見積書 | 「見積」「費用」 | 表（`aide-pm-estimate` 連携） |
| スケジュール表 | 「スケジュール」「WBS」「工程」 | 表（`aide-pm-manage` 連携） |
| ディスカッション資料 | 「論点」「たたき台」「議論」 | 論点整理 |

迷う場合はユーザーに確認する。

### 2. 構成設計（SCQ）
スライド/提案系は **SCQ** で骨子を立てる：Situation（前提）→ Complication（課題）→ Question（問い）→ 回答（提案）。既存成果物（憲章・設計書・議事録）を素材にする。

### 3. 生成（CRAP 原則）
- **CRAP**（Contrast/Repetition/Alignment/Proximity）で視認性を整える
- スライドは Marp 形式（`.aide/templates/export/marp-theme.css` テーマ）
- 作業フォルダの該当フェーズの `slides`（無ければフェーズ直下）に出力

### 4. 仕上げ・エクスポート
- VS Code の Marp プレビューで手動調整できる旨を案内
- HTML/PDF/PPTX 化は `aide-export` を案内

## 注意事項
- 資料は成果物の派生。正本（憲章・設計書等）や管理領域の数値と矛盾させない
