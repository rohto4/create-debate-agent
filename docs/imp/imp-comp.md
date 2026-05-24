# Implementation Complete

## 2026-05-15 初期化

- `AGENTS.md`、`PROJECT.md`、`docs/` 標準構成を作成。
- ECC由来skillとcommandを必要範囲で取り込み。
- `docs/setting/` に次回以降の初期化一式を保持。

## 2026-05-15 技術スタック設計

- `docs/spec/tech-stack.md` を作成。4エージェント構成とChutes経由のモデル割り当てを確定。
  - スキラー: MiMo-V2.5-Pro（技術最適化 + 堅牢性）
  - ホーク: DeepSeek V3.2 TEE thinking（ユーザ視点 + 要件拡充）
  - キーパー: Kimi K2.5 TEE thinking（セキュリティ + 法務 + 経理）
  - メドラー: MiMo-V2.5-Pro（取りまとめ + 合意形成）
- `docs/candi-ref/agent-stances-*.md` を3ファイル作成し、各エージェントの立場を詳細に定義。
- `docs/candi-ref/use-cases.md` で利用シーン候補を8つ整理。
- `docs/candi-ref/file-trigger-architecture.md` でファイルトリガー型アーキテクチャの実現可能性を調査。
- `docs/diary/20260515.md` に作業記録を残す。

## 2026-05-24 仕様整合性の推敲

- `system-overview.md` を基準に、MoChat 採用と周辺モジュール境界を再整理。
- Slack 動作環境仕様を `docs/spec/` から `docs/candi-ref/` へ移動。
- secret の保存先を `config/local/` に統一し、`.gitignore` の credential 除外を強化。
- Chutes Base URL、DeepSeek V3.2 TEE のモデル名、MoChat `sessions/create` の participants 形式を修正。
