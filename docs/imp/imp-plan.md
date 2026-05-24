# Implementation Plan

更新日: 2026-05-24

## 現在の実装計画（エージェント側）

1. 討論実行の最小実装を作る
- `src/mochat/client.py`: `sessions/create`, `sessions/send`, `sessions/messages`
- `src/debate/orchestrator.py`: 1ラウンド実行 + メドラー判定
- `src/debate/convergence.py`: 合意/対立/保留の正規化

2. 監視ロジックの最小実装を作る
- `src/debate/monitor.py`: `repetition/stuck/off_topic/quality_degraded` 判定の骨格
- 閾値は `docs/spec/monitor-thresholds.md` を初期値として利用

3. 成果物出力を実装する
- `docs/debate-results/template.md` に沿って Markdown を出力
- ファイル名は `YYYY-MM-DD_<topic-slug>.md`
