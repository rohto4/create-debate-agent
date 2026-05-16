# Reusable PJ Settings

このディレクトリは、新しいPJへコピーしてAI agent / ECC / docs運用設定を初期導入するための設定一式です。

## 最短の使い方

1. 新しいPJ rootに、この `docs/setting/` ディレクトリ一式をコピーする。
2. 新しいPJ rootでagentに次を依頼する。

```text
docs/setting/init.md を読んで、このPJにAI agent / ECC / docs運用設定を初期導入してください。
PJ名は <PJ-NAME>、slugは <PJ-SLUG>、目的は <PJ-PURPOSE> です。
PJ固有の方針は次の通りです: <PJ-POLICY>
```

## 含まれるもの

- `init.md`: 初期化を実行するための指示
- `init-prompt.md`: 次のPJでagentに送る依頼文テンプレート
- `bootstrap-checklist.md`: 初期化時の確認リスト
- `agents-template.md`: `AGENTS.md` の説明用テンプレート
- `project-template.md`: `PROJECT.md` の説明用テンプレート
- `docs-structure.md`: `docs/` 配下の標準構成
- `ecc-import-profile.md`: ECC skills / commands の取り込み方針
- `diary-rule.md`: 作業記録の標準ルール
- `templates/`: 初期化時に実体化するテンプレート

## 方針

- すべて UTF-8 で読み書きする。
- 日本語で進める。
- テンプレートが文字化けしている場合、そのまま展開せず、日本語で作り直す。
- secret、トークン、private URLは書かない。
- ECC repo全体、hooks、`.codex/config.toml` は標準では導入しない。
