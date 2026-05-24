# Task Lists (MoChat 討論運用)

更新日: 2026-05-24

## 目的

MoChat 上で、提示した設計書を 4 エージェント（スキラー / ホーク / キーパー / メドラー）に討論させ、
推敲結果を `docs/debate-results/` に反映できる状態を作る。

## 運用ルール（`imp-plan` / `imp-wait` との分離）

- 本ファイル: 実行タスクのチェックリスト（担当者別・進行管理）
- `imp-plan.md`: 実装側の未完了計画（設計や開発の段取り）
- `imp-wait.md`: 外部依存や意思決定待ちで止まっている項目
- 判断基準:
  - 今すぐ手を動かせる作業は本ファイル
  - 実装の設計計画は `imp-plan.md`
  - 自分たちだけでは進められない待機事項は `imp-wait.md`

## ユーザー必須タスク

- [ ] MoChat / Chutes のアカウントと API キーを準備する
- [x] 4エージェントを MoChat に `selfRegister` する
- [x] 各エージェントを `bind` で自分のメールに紐付ける
- [ ] 以前露出した可能性があるトークンを `rotateToken` で再発行する

## エージェント実施タスク

- [x] `config/local/` 前提の secret 管理手順を文書で固定する
- [x] 討論停止条件（合意 / 対立 / 保留）を `protocol` と仕様に明文化する
- [x] 停滞検知（反復 / 逸脱 / 品質低下）の閾値案を定義する
- [x] 結果保存先を `docs/debate-results/` に固定し、出力テンプレートを作る
- [x] internal 命名（`mediator`）と表示名（「メドラー」）の使い分けを統一する

## 共同作業タスク（ユーザー + エージェント）

- [x] 討論セッションを `sessions/create` で作成し、実行テストを行う
- [x] 設計書レビュー依頼を `sessions/send` で投稿する
- [ ] thinking モード（DeepSeek/Kimi）の実機結果を確認し、必要ならパラメータを調整する
- [ ] 実運用ログの粒度（セッション単位 or ラウンド単位）を決める

## 完了条件

- [ ] 任意の設計書パスを渡して、MoChat スレッドで 1 ラウンド以上の討論が完走する
- [ ] メドラーの最終整理（合意点 / 対立点 / 保留理由）が取得できる
- [ ] 結果を `docs/debate-results/*.md` に保存できる

## 参照

- `docs/guide/user-setup.md` : API エンドポイントと実行例
- `docs/spec/system-overview.md` : 構成とモジュール境界
- `docs/spec/tech-stack.md` : モデル ID と接続前提
- `docs/spec/debate-targeting-rule.md` : manifest方式の討論対象指定ルール（正本）
