# Bootstrap Checklist

初期化時はこのチェックリストで抜けを確認する。

## 入力確認

- [ ] PJ名を確認した。
- [ ] slugを確認した。
- [ ] PJ目的を確認した。
- [ ] PJ固有方針を確認した。
- [ ] secretやprivate URLを入力値に含めていない。

## ファイル作成

- [ ] `AGENTS.md` を作成または更新した。
- [ ] `PROJECT.md` を作成または更新した。
- [ ] `docs/README.md` を作成または更新した。
- [ ] `docs/ecc-<PJ-SLUG>-setup.md` を作成または更新した。
- [ ] `docs/memo.md` を作成した。
- [ ] `docs/candi-ref/` を作成した。
- [ ] `docs/guide/` を作成した。
- [ ] `docs/imp/` を作成した。
- [ ] `docs/spec/` を作成した。
- [ ] `docs/diary/` を作成した。
- [ ] `docs/setting/` に初期化一式を保持した。

## ECC取り込み

- [ ] `.agents/skills/` を作成した。
- [ ] 必要なskillをコピーした。
- [ ] コピーできなかったskillをsetup memoに記録した。
- [ ] `commands/` を作成した。
- [ ] 必要なcommandをコピーした。
- [ ] コピーできなかったcommandをsetup memoに記録した。

## 品質確認

- [ ] 主要ファイルがUTF-8日本語として読める。
- [ ] 文字化けテンプレートをそのまま展開していない。
- [ ] `git status --short -- .` で差分を確認した。
- [ ] secret、トークン、Cookie、未公開URLを書いていない。
