# syntax=docker/dockerfile:1
FROM ghcr.io/astral-sh/uv:0.10.0 AS uv

FROM python:3.14-slim

COPY --from=uv /uv /uvx /bin/

WORKDIR /app

ENV PATH="/app/.venv/bin:${PATH}" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DBT_PROFILES_DIR=/app

# Install the locked runtime dependencies before copying application files so
# dependency installation is cached independently from model changes.
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project

COPY . ./
COPY profiles.example.yml ./profiles.yml
RUN dbt deps

CMD ["dbt", "build"]
