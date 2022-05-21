help: ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

download-geyser: ## get the latest geyser jar
	curl "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/target/Geyser.jar" -o downloads/geyser.jar 

build: ## create the docker image
	docker build . -t alfanse/geyser:1.0 -f Dockerfile

start: ## start geyser in docker
	docker run --name geyser -d -p 19132:19132 alfanse/geyser:1.0

export: ## save the docker image for import by nas
	docker save --output="downloads/geyser.tar" alfanse/geyser:1.0

########### minecraft java ###########

start-mc: ## start minecraft server, in docker
	docker run --name minecraft -d -it -p 25565:25565 -e EULA=TRUE itzg/minecraft-server

lsof-mc: ## see whats on the ports
	 lsof -i :25565,19132