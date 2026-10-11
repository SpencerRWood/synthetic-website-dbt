# Repository Guidance

## Purpose and boundaries
- Own SQL transformations and analytical marts for the synthetic website dataset.
- Generation, ML, dashboards, and application services belong in downstream or sibling repos.

## Development
- Keep raw-source cleanup in `models/staging/`, reusable derivations in `models/intermediate/`, and final facts and dimensions in `models/marts/`.
- Put source and model tests near their dbt definitions; follow the model contract in `README.md`.

## Validation
- Run `uv run ruff check .`, `uv run ruff format --check .`, `uv run sqlfluff lint .`, and `uv run pre-commit run --all-files`.
- After configuring a local profile and warehouse connection, run `uv run dbt deps`, `uv run dbt parse`, and `uv run dbt build`.

## Architecture constraints
- Keep dbt materializations and dependencies in `dbt_project.yml` and model YAML, not external orchestration code.

## Safety
- Use `profiles.example.yml` as a contract; never commit a real profile or warehouse credentials.

## Branching strategy

- This repository uses **release-branch integration**. Create Story branches from the verified active `release/vX.Y.Z` and target Story PRs there; `main` changes only after the release readiness gate.
- Follow the [canonical branching and delivery policy](https://github.com/SpencerRWood/codex-config/blob/main/docs/branching-policy.md), available through the installed codex-config source path. Verify the strategy, release association, fetched base and PR target before implementation and record them in Story evidence. Story completion does not authorize publication or deployment; retain existing review, CI, security and rollback requirements.
