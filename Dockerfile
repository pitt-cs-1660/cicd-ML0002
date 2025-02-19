FROM python:3.11-buster AS builder

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

COPY . .

FROM python:3.11-buster AS app

WORKDIR /app

COPY --from=builder /app /app
COPY --from=builder /usr/local/ /usr/local/

COPY . .

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
