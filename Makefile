help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

build-geyser: ## create the geyser docker image
	docker build . -t alfanse/geyser:1.1 -f geyser.dockerfile

export-geyser: ## save the geyser docker image for import by nas	
	mkdir tmp
	docker save --output="tmp/geyser.tar" alfanse/geyser:1.1

start: ## start all with docker-compose 
	docker-compose up -d

is-up: ## whats on the mc and geyser ports?
	 lsof -i :25565,19132

logs: ## tail all the logs
	docker-compose logs -f
