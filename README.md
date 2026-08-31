# synthetic-website-dbt

`synthetic-website-dbt` contains dbt transformations and analytical marts for
the synthetic website dataset.

This repository is intentionally focused on dbt-based SQL transformations. It
does not own every form of analytics performed on the dataset. ML, forecasting,
recommendation, experimentation, statistical modeling, notebooks, dashboards,
and services should live in downstream or separate repositories.

## Repository Boundaries

```text
synthetic-website-data
        |
        v
generates + loads
        |
        v
PostgreSQL raw.events
        |
        v
synthetic-website-dbt
        |
        v
staging / intermediate / marts
        |
        v
downstream consumers
        |-- BI
        |-- notebooks
        |-- ML
        `-- other analytics repos
```

`synthetic-website-data` owns synthetic generation and raw ingestion.

`synthetic-website-dbt` owns analytical SQL transformations and marts.

Future ML repositories own predictive and statistical modeling.

## Database

```text
database: synthetic_website_data
source schema: raw
dbt schemas:
  staging
  intermediate
  marts
```

dbt connects with the dedicated PostgreSQL role:

```text
dbt_editor
```

Expected permission model:

```text
raw          -> SELECT
staging      -> dbt-managed
intermediate -> dbt-managed
marts        -> dbt-managed
```

Database user and permission management is outside this repository. Do not put
passwords or other credentials in source control.

## Environment Variables

```text
DBT_HOST=<postgres host>
DBT_PORT=5432
DBT_USER=dbt_editor
DBT_PASSWORD=<secret>
```

`profiles.example.yml` uses these variables. Copy it to your local dbt profiles
location or to an ignored repository-local `profiles.yml`.

## Initial Setup

```bash
uv sync
cp profiles.example.yml ~/.dbt/profiles.yml
uv run dbt deps
uv run dbt debug
uv run dbt parse
uv run dbt build
```

For repository-local development:

```bash
cp profiles.example.yml profiles.yml
uv run dbt debug --profiles-dir .
uv run dbt parse --profiles-dir .
uv run dbt build --profiles-dir .
```

## Architecture

```text
source
  |
  v
staging
  |
  v
intermediate
  |
  v
marts
```

`staging` models stay close to raw source data. They select, rename, order, and
lightly normalize source columns without aggregate business logic.

`intermediate` models derive reusable analytical building blocks from staged
events, including event ordering, source-provided session summaries, and visitor
summaries.

`marts` models expose final BI- and analytics-facing facts and dimensions.

## Naming Conventions

```text
stg_<source>__<entity>
int_<entity>__<purpose>
dim_<entity>
fct_<entity>
```

## Initial Models

The raw source is `synthetic_website_data.raw.events`. The infrastructure table
`raw.alembic_version` is not modeled as an analytics source.

Initial marts:

```text
fct_events   -> one row per website event
fct_sessions -> one row per source-provided visitor session
dim_visitors -> one row per generated visitor
```

`session_id` is provided by the source table, so this project does not perform
inactivity-threshold sessionization in the initial model set.

`reached_order_confirmation` is derived from the generator's current conversion
page configuration, where `order_confirmation` is the conversion page.

## Static Checks

```bash
uv run ruff check .
uv run ruff format --check .
uv run sqlfluff lint .
uv run pre-commit run --all-files
uv run dbt deps
uv run dbt parse --profiles-dir .
```

`dbt compile`, `dbt test`, and `dbt build` require a live PostgreSQL connection
with the expected `dbt_editor` permissions.

## SQLFluff

SQLFluff is configured with:

```ini
dialect = postgres
templater = jinja
apply_dbt_builtins = True
```

The Jinja templater with dbt builtins keeps SQL linting available without a
live PostgreSQL connection. `dbt parse` provides dbt-aware project validation
against `profiles.example.yml`.

## Release Validation

The release workflow installs dependencies with `uv`, runs `dbt deps`, optional
`dbt parse`, and pre-commit before semantic-release. Ruff and SQLFluff are run
through pre-commit.

Database-backed validation should be enabled separately with real workflow
secrets and should not store credentials in source control.

## Semantic Release

semantic-release follows the template family's conventional commit behavior:

- `feat:` creates minor releases
- `fix:` and `perf:` create patch releases
- `chore:`, `ci:`, `docs:`, `refactor:`, `style:`, and `test:` do not create
  releases by themselves

Release tags use `v{version}` and the release workflow updates
`project.version` in `pyproject.toml`.
