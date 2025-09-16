# Terraria Dedicated Server

running terraria dedicated server in Docker making it simple

## prerequisites

- Docker Engine
- Docker Compose plugin (usually comes preinstalled, if not. google it.)

## usage

### installing

installing the server itself is simple, it's already automated.

just run this command

```bash
docker compose up --force-recreate installer
```

add `-d/--detach` flag if you don't want to see the logs

then make sure to dispose the installer after it's finished doing its job

```bash
docker compose down installer
```

### running

you can run the server with the following command

```bash
docker compose up -d --force-recreate server
```

> **NOTE** you should always detach so it will run in the background. if you need to interact with the terminal, run `docker attach terraria-server-1` (make sure to replace the id with the correct one)

stopping and disposing it is easy

```bash
docker compose down server
```

### configuration

#### environment variables

you may see several environment variables inside [compose.yml](compose.yml)

- `HOME` - this sets the home directory, never touch this if you don't know what you're doing

- `BIN` - terraria binary to use, switch to `TerrariaServer` if you want to use 32-bit (default `TerrariaServer.bin.x86_64`)

- `PARAMS` - params for terraria server, see https://terraria.wiki.gg/wiki/Server#Command-line%20parameters

#### deploy variables

these are the container variables used by docker

under `deploy > resources > limits` and `deploy > resources > reservations`

- `cpu` - max cpu the container can use in percentage (1.0 = 100% core, 5.0 = 500% cores)

- `memory` - max memory the container can use in bytes

see https://docs.docker.com/reference/compose-file/deploy/#resources

#### volumes

there are 2 volumes that's being used here.

- `data` - this is where the server files are stored (`srv/`)

- `worlds` - worlds directory

> we're using volumes here so that we can reuse it, and it's persistent between restarts. it saves time when you need to run multiple instances at the same time, or migrating to another server. obviously, you can also just use bind mounts but that's up to you, volumes are still very useful.

see https://docs.docker.com/reference/compose-file/volumes/
