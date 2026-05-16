# ECC Import Profile

ECC由来のskills / commandsをPJへ取り込むための標準方針。

## コピー元

- ECC: `G:\devwork\clone-dir\everything-claude-code`
- ecc-expand: `G:\devwork\clone-dir\ecc-expand`

PJごとに別のcloneを使う場合は、`PROJECT.md` と `docs/ecc-<PJ-SLUG>-setup.md` に反映する。

## 方針

- ECC repo全体は導入しない。
- `hooks/` と `.codex/config.toml` は標準では導入しない。
- 必要なskillだけ `.agents/skills/` にコピーする。
- 必要なcommandだけ `commands/` にコピーする。
- コピーできなかったものは、作成せずsetup memoに記録する。

## 標準skill

- `api-design`: API設計、status code、pagination、error設計
- `backend-patterns`: Node.js / Express / Next.js API routesなど
- `coding-standards`: コード品質、命名、読みやすさ
- `documentation-lookup`: ライブラリやframeworkの最新docs確認
- `product-capability`: 大きめの要求を実装可能な制約・契約へ落とす
- `security-review`: secret、認証、外部API、権限、支払いなどの安全確認
- `tdd-workflow`: 新機能、修正、refactor時のテスト方針
- `verification-loop`: 実装後のbuild/test/typecheck確認

## 用途別追加skill

- `content-engine`: 投稿文、要約、返信文面を扱う時
- `crosspost`: 複数SNSや複数投稿先への配信設計を扱う時

## 標準command

- `expand-answer.md`: 短い一次回答を必要時に詳しく展開する
- `prp-plan.md`: 実装候補を詳細な計画ファイルに落とす
- `prp-implement.md`: 計画ファイルを段階的に実行する
- `prp-prd.md`: 大きめの要望をPRD / phaseに分解する
