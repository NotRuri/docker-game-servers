# Left 4 Dead 2 Dedicated Server

running left 4 dead 2 dedicated server in Docker making it simple

## features

- simple

- easy to setup

- scalable (maybe? i havent tried it)

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

> **NOTE** you should always detach so it will run in the background

stopping and disposing it is easy

```bash
docker compose down server
```

> **NOTE** never run `docker compose up` directly, since it will run both services. always run `installer` first before the `server`

### configuration

#### environment variables

you may see several environment variables inside [compose.yml](compose.yml)

- `STEAM_USER` - this is optional, it's your server's steam username (leave it alone if you don't know what's it for)

- `STEAM_PASS` - steam password

- `STEAM_AUTH` - steam auth code

- `PORT` - server port, default is `27015`

- `DEFAULT_MAP` - starting map, default is `c1m2_streets`

- `CVARS` - optional cvars, default is `+ip 0.0.0.0 +maxplayers 8`

- `FLAGS` - server flags, default is `-strictportbind -norestart`

#### deploy variables

these are the container variables used by docker

under `deploy > resources > limits` and `deploy > resources > reservations`

- `cpu` - max cpu the container can use in percentage (1.0 = 100% core, 5.0 = 500% cores)

- `memory` - max memory the container can use in bytes

see https://docs.docker.com/reference/compose-file/deploy/#resources

#### volumes

there are 3 volumes that's being used here.

- `data` - this is where the server files are stored (`left4dead2/`)

- `addons` - where the addon files are stored (`left4dead2/addons`)

- `cfg` - where the config files are stored (`left4dead2/cfg`)

we're using volumes here so that we can reuse it, and it's persistent between restarts.

it saves time when you need to run multiple instances at the same time, or migrating to another server

obviously, you can also just use bind mounts but that's up to you, volumes are still very useful.

see https://docs.docker.com/reference/compose-file/volumes/

#### addons/cfg

installing mods or plugins are easy, you should already know how to do this but oh well. here it is.

> if you're new to Docker, interacting with volumes might be a bit difficult and confusing.

you can use `tinyfilemanager/tinyfilemanager` from Docker Hub to manage volume files. just run this:

```sh
docker run -d \
    -v left4dead2_data:/var/www/html/left4dead2 \
    -v left4dead2_addons:/var/www/html/left4dead2/left4dead2/addons \
    -v left4dead2_cfg:/var/www/html/left4dead2/left4dead2/cfg \
    -p 8780:80 \
    --name tinyfilemanager tinyfilemanager/tinyfilemanager:master
```

then go to `<your ip>:8780` and login with `admin` & `admin@123`

or if you're comfortable with terminal, you can directly attach to the `installer` container and download files there instead.

just uncomment these lines

```yml
installer:
  # entrypoint: /bin/bash
  # tty: true
  # stdin_open: true
```

and comment out

```yml
entrypoint: /mnt/left4dead2/install.sh`
```

then run

```bash
docker compose up installer
docker attach left4dead2-installer-1
```

make sure to use the right container ID, if you don't know the ID, docker usually prints them like this:

```bash
✔ Container     left4dead2-installer-1    Created 0.1s
```

there you have it, just copy it. or if it didn't, run this command:

```bash
docker ps -a
```

it will show something like this:

```bash
CONTAINER ID  IMAGE                            COMMAND                  CREATED        STATUS        NAMES
a731299c8794  ghcr.io/notruri/steamcmd:latest  "/mnt/left4dead2/ins…"   2 seconds ago  Up 2 seconds  left4dead2-installer-1
```

find the one that has a name starting with `left4dead2-installer`. then just copy it.

at this point, you should be attached to the container already. you can confirm it if you see a new shell like this:

```bash
root@5f96148a83d6:/mnt/left4dead2#

```

`curl` and `wget` is not available here, so make sure to manually install it first.

```bash
apt-get -y update; apt-get -y install curl wget;
```

you may also need to use `tar` or other tools, then you'd need to install it as well.

i won't be discussing everything here, you're on your own now. there are a lot of guides out there that you can use.
