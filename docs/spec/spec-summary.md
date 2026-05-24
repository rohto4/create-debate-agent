# Spec Summary

## 現在の仕様

- [tech-stack.md](tech-stack.md): 技術スタック（モデル選定、API互換性、オーケストレーション、ファイルトリガー技術）
- [system-overview.md](system-overview.md): 討論システム全体の概念図（Mermaid + ASCII、登場人物一覧、データフロー）
- [debate-protocol.md](debate-protocol.md): ラウンド進行、収束判定、停止条件
- [monitor-thresholds.md](monitor-thresholds.md): 停滞検知閾値とアクション基準
- [debate-targeting-rule.md](debate-targeting-rule.md): manifest方式での討論対象指定ルール（正本）

## 方針

- チャット基盤は MoChat を主対象にする。
- Slack は候補・代替案として扱い、確定仕様には含めない。
