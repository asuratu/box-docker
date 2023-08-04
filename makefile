## color output
COLOR_NORMAL=$(shell printf '\033[0m')
COLOR_RED=$(shell printf '\033[1;31m')
COLOR_GREEN=$(shell printf '\033[1;32m')
COLOR_YELLOW=$(shell printf '\033[1;33m')

DONE="${COLOR_GREEN}Done${COLOR_NORMAL}"

.PHONY: all clean release update update-dev update-main init migrate php nginx restart
.IGNORE: all

all:

init:
	@echo "${COLOR_GREEN}Init ...${COLOR_NORMAL}"
	@(cd logs;rm -rf hyperf-logs;ln -sf ../app/logs hyperf-logs)
	@chmod 0600 ./config/php-fpm/ssh/id_rsa
	@echo $(DONE)

clean:

git-init:
	@docker-compose exec php bash -c "cd current;git config pull.rebase false;git config pull.rebase true;git config pull.ff only";

release:
	@docker-compose exec php bash -c "./deploy.sh";

update:
	@docker-compose exec php bash -c "cd current;git pull";

update-dev:
	@docker-compose exec php bash -c "cd current;git checkout develop;git pull;make clean";

update-main:
	@docker-compose exec php bash -c "cd current;git checkout main;git pull;make clean";

migrate:
	@docker-compose exec php bash -c "cd current;make migrate";

php:
	@docker-compose exec php env LANG=C.UTF-8 bash;

nginx:
	@docker-compose exec nginx env LANG=C.UTF-8 bash;

rabbit:
	@docker exec -it rabbit /bin/bash;

update-nginx:
	@docker-compose exec nginx bash -c "nginx -s reload";

restart:
	@docker-compose restart;
