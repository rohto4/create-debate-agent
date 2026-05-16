# <PJ-NAME> Project Context

## 目的

<PJ-PURPOSE>

## PJ固有方針

<PJ-POLICY>

## 主な機能・成果物

<PJ-FEATURES>

## 優先度モデル

1. `AGENTS.md`: agent共通の最上位ルール
2. `PROJECT.md`: PJ固有の目的、構成、運用方針
3. `docs/guide/`: 採用済みガイド、判断基準
4. `docs/spec/`: 確定仕様、要件、設計前提
5. `docs/candi-ref/`: 候補、調査、比較、未採用案
6. `docs/imp/`: 作業計画、実装メモ、完了記録
7. `docs/diary/`: セッション記録
8. `docs/setting/`: 初期化とテンプレート
9. `.agents/skills/`: 必要時に読むECC由来skill
10. `commands/`: 必要時に読むECC/ecc-expand由来command

## ECCコピー元

- ECC: `<ECC-ROOT>`
- ecc-expand: `<ECC-EXPAND-ROOT>`

## 取り込み対象skill

- `api-design`
- `backend-patterns`
- `coding-standards`
- `documentation-lookup`
- `product-capability`
- `security-review`
- `tdd-workflow`
- `verification-loop`
- `content-engine`
- `crosspost`

## 取り込み対象command

- `expand-answer.md`
- `prp-plan.md`
- `prp-implement.md`
- `prp-prd.md`

## 運用ルール

- 採用済みルールは `docs/guide/` または `docs/spec/` に移す。
- 未確定の案、比較、調査は `docs/candi-ref/` に置く。
- 一時メモは `docs/memo.md` に置いてよいが、確定したら適切な場所へ移す。
- PJ固有の重要な決定は、可能な限り理由も残す。
- 外部サービスの最新仕様や規約に依存する内容は、必要時に公式情報を確認する。
