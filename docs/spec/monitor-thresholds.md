# Monitor Thresholds

作成日: 2026-05-24
更新日: 2026-05-24

## 目的

討論停滞検知の初期閾値を定義し、`src/debate/monitor.py` の実装基準を固定する。

## 初期閾値（v0）

```yaml
debate:
  monitor:
    enabled: true
    max_stagnant_rounds: 2
    similarity_threshold: 0.80
    min_response_length: 120
    off_topic_threshold: 0.35
    max_timeout_per_round: 1
```

## 判定ルール

1. 反復（repetition）
- 同一エージェントの連続ラウンド発言類似度が `>= 0.80` なら 1 カウント。
- 2 ラウンド連続でカウントされたら `repetition` 発火。

2. 収束不能（stuck）
- メドラー判定が `対立` を 2 回連続で返したら `stuck` 発火。

3. 話題逸脱（off_topic）
- 議題埋め込みとの類似度が `<= 0.35` なら `off_topic` 発火。

4. 品質低下（quality_degraded）
- 応答文字数が `120` 未満、または空疎応答（同意のみ）が連続 2 回で発火。

## 推奨アクション

- `repetition`: 焦点限定の再質問を投入
- `stuck`: 人間判断を依頼して保留終了
- `off_topic`: 元議題を明示して軌道修正
- `quality_degraded`: プロンプト補強または該当エージェント再実行

## 見直しタイミング

- 5 セッション実行後に閾値を再評価
- `docs/debate-results/` と `logs/` の実績で過検知/見逃しを調整
