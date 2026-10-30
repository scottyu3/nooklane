FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    tar \
    procps \
    lsof \
    git \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false && \
    poetry install --no-root --no-interaction

COPY . .

ENV NOOKLANE_DATA_DIR=/data
ENV PYTHONUNBUFFERED=1

EXPOSE 3000 8000 7581 7582/udp

CMD ["reflex", "run"]
