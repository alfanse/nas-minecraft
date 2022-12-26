GEYSER_NAME="alfanse/geyser"
GEYSER_IMAGE="${GEYSER_NAME}:1.3"

help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

geyser-build: ## create the geyser docker image
	docker build -t "${GEYSER_NAME}:latest" -t ${GEYSER_IMAGE} -f geyser.dockerfile .

geyser-export: ## save the geyser docker image for import by nas
	mkdir tmp
	docker save --output="tmp/geyser.tar" ${GEYSER_IMAGE}

up: ## start all with docker-compose
	docker-compose up -d &

all-up: ## start minecraft, geyser, dns
	docker-compose -f docker-compose.yml -f docker-compose-dns-to-nas.yml up -d &

down: ## stop all with docker-compose
	docker-compose stop

is-up: ## whats on the mc and geyser ports?
	 lsof -i :25565,19132

logs: ## tail all the logs
	docker-compose logs -f

ip: Whats this machines IP address
	ipconfig getifaddr en0

