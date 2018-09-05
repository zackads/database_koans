.PHONY: down
down: 
	docker-compose down

.PHONY: build
build:
	docker-compose build

.PHONY: start
start: down build
	docker-compose run --rm --service-ports pgcli

.PHONY: start-koans
start-koans: down build
	docker-compose run --rm --service-ports koans
