# Project Setting Init

最優先: この初期化作業は、すべて UTF-8 で読み書きし、日本語で進めること。既存テンプレートや参照ファイルが文字化けしている場合は、文字化けした本文をそのまま展開せず、同じ意図・構成を保った日本語の文書として作り直すこと。

## agentへの依頼例

```text
docs/setting/init.md を読んで、このPJにAI agent / ECC / docs運用設定を初期導入してください。
PJ名は <PJ-NAME>、slugは <PJ-SLUG>、目的は <PJ-PURPOSE> です。
PJ固有の方針は次の通りです: <PJ-POLICY>
```

## 入力値

- `<PJ-NAME>`: 表示用PJ名。例: `create-debate-agent`
- `<PJ-SLUG>`: ファイル名やsetup名に使う短い識別子。例: `create-debate-agent`
- `<PJ-PURPOSE>`: PJの目的。
- `<PJ-POLICY>`: PJ固有の重要方針。未指定なら目的から自然に補う。
- `<PJ-FEATURES>`: 主な成果物や機能。未指定なら目的から自然に補う。
- `<ECC-ROOT>`: ECC clone path。標準は `G:\devwork\clone-dir\everything-claude-code`
- `<ECC-EXPAND-ROOT>`: ecc-expand clone path。標準は `G:\devwork\clone-dir\ecc-expand`

## 初期化手順

1. 既存状態を確認する。
   - `AGENTS.md`、`PROJECT.md`、`docs/`、`.agents/skills/`、`commands/` の有無を見る。
   - 既存ファイルがある場合、破壊せず内容を確認してから追記または差分適用にする。
2. 標準ディレクトリを作る。
   - `.agents/skills/`
   - `commands/`
   - `docs/candi-ref/`
   - `docs/diary/`
   - `docs/guide/`
   - `docs/imp/`
   - `docs/spec/`
   - `docs/setting/`
3. `templates/AGENTS.md` から `AGENTS.md` を作る。
4. `templates/PROJECT.md` から `PROJECT.md` を作る。
5. docs配下の標準ファイルを作る。
   - `docs/README.md`
   - `docs/ecc-<PJ-SLUG>-setup.md`
   - `docs/memo.md`
   - `docs/candi-ref/README.md`
   - `docs/candi-ref/candi-ref-summary.md`
   - `docs/guide/README.md`
   - `docs/guide/guide-summary.md`
   - `docs/imp/README.md`
   - `docs/imp/imp-plan.md`
   - `docs/imp/imp-comp.md`
   - `docs/imp/imp-wait.md`
   - `docs/imp/user-tasks.md`
   - `docs/spec/README.md`
   - `docs/spec/spec-summary.md`
6. 初期化資料一式を `docs/setting/` に残す。
   - このディレクトリをコピー元として使った場合は、そのまま保持する。
   - root直下にある設定素材から実行した場合は、`docs/setting/` にコピーする。
7. ECC skillsを必要範囲でコピーする。
   - 標準skillは `ecc-import-profile.md` を参照する。
   - 見つからないskillは無理に作らず、setup memoに未取り込みとして記録する。
8. commandsを必要範囲でコピーする。
   - 標準commandは `ecc-import-profile.md` を参照する。
   - 見つからないcommandはsetup memoに未取り込みとして記録する。
9. `git status --short -- .` で作業結果を確認する。

## 置換ルール

すべてのテンプレートに対して、次を置換する。

- `<PJ-NAME>` -> 実PJ名
- `<PJ-SLUG>` -> slug
- `<PJ-PURPOSE>` -> PJ目的
- `<PJ-POLICY>` -> PJ固有方針
- `<PJ-FEATURES>` -> 主な成果物や機能
- `<ECC-ROOT>` -> ECC clone path
- `<ECC-EXPAND-ROOT>` -> ecc-expand clone path
- `<TITLE>` -> `Candidate Reference`、`Guide`、`Spec` などの見出し

## 標準ECC設定

- ECC: `G:\devwork\clone-dir\everything-claude-code`
- ecc-expand: `G:\devwork\clone-dir\ecc-expand`

標準skill:

- `api-design`
- `backend-patterns`
- `coding-standards`
- `documentation-lookup`
- `product-capability`
- `security-review`
- `tdd-workflow`
- `verification-loop`

用途に応じて追加する候補:

- `content-engine`
- `crosspost`

標準command:

- `expand-answer.md`
- `prp-plan.md`
- `prp-implement.md`
- `prp-prd.md`

## 完了条件

- `AGENTS.md` と `PROJECT.md` がPJ固有の内容になっている。
- `docs/` の標準構成が存在する。
- `docs/ecc-<PJ-SLUG>-setup.md` に取り込み済みskill/commandが記録されている。
- `docs/setting/` にこの初期化一式が残っている。
- 日本語が文字化けせず読める。
