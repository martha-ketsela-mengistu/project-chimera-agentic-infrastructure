.PHONY: setup test lint format docker-build

# Install dependencies using uv
setup:
	uv sync

# Run tests (expected to fail initially per TDD)
test:
	uv run pytest tests/

# Linting and formatting
lint:
	uv run ruff check .

format:
	uv run ruff format .

# Docker operations
docker-build:
	docker build -t chimera-agent .

docker-run:
	docker run -it --rm chimera-agent
