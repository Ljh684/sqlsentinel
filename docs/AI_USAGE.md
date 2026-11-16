# AI usage and explainability

AI tools may be used to assist implementation, tests, documentation, and review.
They are not part of the runtime analysis path.

- SQLSentinel does not call a model or network service while scanning.
- Rules are deterministic MoonBit code with named inputs, outputs, and tests.
- Unsupported semantic layers are explicitly listed by `--capabilities` and in
  machine-readable `analysis_model` metadata.
- Examples and reports can be reproduced without AI.
- Each accepted feature is validated by native tests, wasm-gc tests, browser
  smoke tests, and CI examples.

The intended acceptance standard is that the participant can explain the design,
constraints, tradeoffs, and failure cases without relying on an AI-generated
claim. The project documents those decisions in:

- [Analysis model](ANALYSIS_MODEL.md);
- [Competition acceptance guide](ACCEPTANCE.md);
- [Ecosystem positioning](ECOSYSTEM.md);
- [Review response](REVIEW_RESPONSE.md).
