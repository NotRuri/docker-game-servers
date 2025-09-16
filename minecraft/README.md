# Minecraft Dedicated Server

running minecraft dedicated server in Docker making it simple

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

> **NOTE** make sure to set `EULA: true` environment variable as it's required.

> **NOTE** you should always detach so it will run in the background. if you need to interact with the terminal, run `docker attach minecraft-server-1` (make sure to replace the id with the correct one)

stopping and disposing it is easy

```bash
docker compose down server
```

### configuration

#### installation environment variables

- `VERSION` - server version to download (optional)

- `SERVER_URL` - custom server url to download from (optional)

#### runtime environment variables

you may see several environment variables inside [compose.yml](compose.yml)

- `HOME` - this sets the home directory, never touch this if you don't know what you're doing

- `EULA` - required, set to `true` to agree to the EULA

- `JVM_ARGS` - JVM Arguments, already optimized by using Aikar's flags, don't touch this if you don't know what you're doing.
https://docs.oracle.com/en/java/javase/21/docs/specs/man/java.html

#### deploy variables

these are the container variables used by docker

under `deploy > resources > limits` and `deploy > resources > reservations`

- `cpu` - max cpu the container can use in percentage (1.0 = 100% core, 5.0 = 500% cores)

- `memory` - max memory the container can use in bytes

see https://docs.docker.com/reference/compose-file/deploy/#resources

#### volumes

- `data` - this is where everything are stored

> **NOTE** you can use bind-mounts if you want to import your worlds/plugins/etc.

see https://docs.docker.com/reference/compose-file/volumes/
