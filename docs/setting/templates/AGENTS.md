# <PJ-NAME> Agent Instructions

## 最優先ルール

1. 日本語で対応する。
2. すべてのファイルは UTF-8 として読み書きする。
3. 文字化けしたテンプレートをそのまま展開しない。意図と構成を保って、日本語の文書として作り直す。
4. secret、トークン、Cookie、未公開の認証情報をリポジトリに書かない。
5. <PJ-POLICY>

## PJの扱い

このPJは、<PJ-PURPOSE>

主に次を管理します。

<PJ-FEATURES>

## 読み込み順

1. `AGENTS.md`
2. `PROJECT.md`
3. `docs/ecc-<PJ-SLUG>-setup.md`
4. 必要に応じて `.agents/skills/*/SKILL.md`
5. 必要に応じて `commands/*.md`

## 情報の置き場所

- `docs/guide/`: 採用済みの運用ガイド、判断基準、ルール補足
- `docs/spec/`: 確定した仕様、要件、設計前提
- `docs/candi-ref/`: 候補、調査、比較、未採用案
- `docs/imp/`: 実装メモ、作業計画、完了記録、ユーザー作業
- `docs/diary/`: セッション単位の作業記録
- `docs/setting/`: 初期化用テンプレート、設定資料

## 回答方針

- 通常回答は短く、結論と次の行動を優先する。
- 詳細説明、比較、展開を求められた場合だけ十分に掘り下げる。
- PJ固有方針に関わる判断では、リスク、前提、不確実性を明示する。
- 不確かな最新情報、外部サービスの現行仕様、規約、料金、API仕様は確認してから扱う。

## ECCの扱い

- ECC由来のskillは `.agents/skills/` にコピー済みのものを優先して使う。
- ECC全体、hooks、`.codex/config.toml` は標準では導入しない。
- `commands/` はECCまたはecc-expand由来の試用command置き場として扱う。
