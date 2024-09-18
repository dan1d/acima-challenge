DOCKER_COMPOSE = docker compose
DOCKER_COMPOSE_FILE = docker-compose.yml

up:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up --build -d

db-create:
	$(DOCKER_COMPOSE) exec backend bundle exec rake db:create

db-migrate:
	$(DOCKER_COMPOSE) exec backend bundle exec rake db:migrate

setup: up db-create db-migrate

down:
	$(DOCKER_COMPOSE) down

restart: down up

test:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) run backend_test

.PHONY: up db-create db-migrate setup down restart test
