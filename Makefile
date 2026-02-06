.PHONY: setup test lint format docker-build

# Install dependencies using uv
setup:
	uv sync

# Run tests (expected to fail initially per TDD)
# Run tests (IN DOCKER per requirements)
test: docker-build
	docker run --rm chimera-agent uv run pytest tests/

# Run tests locally (for fast dev loop)
test-local:
	uv run pytest tests/

# Linting and formatting
lint:
	uv run ruff check .

format:
	uv run ruff format .

# Spec Verification
spec-check:
	uv run python scripts/spec_check.py

# Docker operations
docker-build:
	docker build -t chimera-agent .

docker-run:
	docker run -it --rm chimera-agent
