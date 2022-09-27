default: help

PROJECT_NAME := BASIC
IDU := $(shell id -u)
IDG := $(shell id -g)
CONTAINERS := $(shell docker ps -a -q)

.PHONY: help build-up down web-sh mysql-sh remove-containers remove-images docker-purge

#
### General
#

## build, create and start containers
build-up:
	docker-compose build --build-arg UID=$(IDU) --build-arg GID=$(IDG)
	docker-compose up -d
	echo "docker-compose up with USER: $(IDU)(uid) GROUP: $(IDG)(gid)"

## stop and remove resources
down:
	docker-compose down

## access to apache docker container
web-sh:
	docker-compose exec -u www-data web bash

## access to mysql docker container
mysql-sh:
	docker-compose exec mysql bash

## remove all Docker containers
remove-containers:
	docker rm -f $(CONTAINERS)

## remove all Docker images
remove-images:
	docker image prune -a

## remove all stopped containers, networks, images (at least one container associated to them) and build cache
remove-purge:
	docker system prune -a

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
TARGET_MAX_CHAR_NUM=25

#
### Utils
#

## Show the nice helper with the targets and their description
help:
	@echo "= Project $(PROJECT_NAME) make helper ="
	@awk '/^### (.*)/ { \
		print ""; \
		for (i = 2; i <= NF; i++) {\
			printf "%s ", $$i; \
		} \
		print ""; \
	} \
	/^#### (.*)/ { \
		printf "  "; \
		for (i = 2; i <= NF; i++) { \
			printf "%s ", $$i; \
		} \
		print ""; \
	} \
	/^[a-zA-Z\-\_0-9\/]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "    ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} { lastLine = $$0 }' $(MAKEFILE_LIST)
