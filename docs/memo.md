# 一時メモ

このファイルは一時メモ用です。確定した事項は適切なフォルダへ移してください。

---

## 2026-05-24 統合・修正サマリ（一次）

### 実施内容

- `docs/imp/task-lists.md` を MoChat 討論運用の正本として再作成した。
- `docs/guide/user-setup.md` は重複手順を削り、API 実行例とトラブルシュート中心の補助ガイドに再構成した。
- 「実施済みだが修正が必要な項目」を `task-lists.md` に明記した。

### 修正が必要と判断した点

- 過去にリポジトリ配下に secret が置かれたため、MoChat トークンの再発行（`rotateToken`）が必要。
- internal 名称の揺れ（`medler`/`mediator`）は `mediator` に統一するのが妥当。
- 実行手順が `guide/user-setup.md` と `imp/task-lists.md` に分散していたため、タスク管理の正本を `task-lists.md` に一本化。

### 反映先

- `docs/imp/task-lists.md`
- `docs/guide/user-setup.md`
