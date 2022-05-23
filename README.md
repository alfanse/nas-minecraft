# Minecraft for nas

Uses: 
* Minecraft - (java) edition as the server
* Geyser - as a proxy for bedrock clients

Depends on docker + docker-compose.

## commands
encoded in the [Makefile](Makefile), type `make help` to see them.

```shell
make help

Usage:
  help             Show this help.
  build-geyser     create the geyser docker image
  export-geyser    save the geyser docker image for import by nas	
  start            start all with docker-compose 
  is-up            whats on the mc and geyser ports?
  logs             tail all the logs
```

### Workflow

build the geyser docker image `make build-geyser`.

If you need to move the docker image from say computer to nas, `make export-geyser`.

Start minecraft and geyser using `make start` ~= `docker-compose up -d`.

checks ports are in use `make is-up` and check logs `make logs`.

## Geyser
source - https://github.com/GeyserMC/Geyser  
jar - https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/  
config (wiki) - https://wiki.geysermc.org/geyser/understanding-the-config/  


# References
minecraft [server.propterties](https://minecraft.fandom.com/wiki/Server.properties)

world seeds: https://www.pcgamer.com/best-minecraft-seeds/#section-minecraft-village-seeds

