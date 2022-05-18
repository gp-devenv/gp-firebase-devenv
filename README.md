[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![Ubuntu](https://img.shields.io/badge/ubuntu-20.04-orange)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/docker-hub-blue)](https://hub.docker.com/repository/docker/gpfister/firebase-devenv)

[![ARM64](https://img.shields.io/badge/linux%2farm64-Yes-red)](https://hub.docker.com/repository/docker/gpfister/firebase-devenv/tags)
[![AMD64](https://img.shields.io/badge/linux%2famd64-Yes-red)](https://hub.docker.com/repository/docker/gpfister/firebase-devenv/tags)

# Firebase Dev Environment

Copyright (c) 2022, Greg PFISTER. MIT License

<div id="about" />

## About

This is a simple Ubuntu container to use as development environment for
Node/Typescript/Firebas/Angular projects, which I use with Visual Studio Code
Remote Container feature.

See [version](#version) mapping to find out which version Ubuntu, node, npm,
firebase-tools, angular and java.

This image is built from
[gpfister/base-devenv](https://hub.docker.com/repository/docker/gpfister/base-devenv)
and adds

- a node environment compatible with Firebase and Angular 13.
- `chromium` (actually `chromium-browser` on Ubuntu:20.04), for Angular unit
  testing.

Please find [here](https://github.com/gpfister/base-devenv#README) the details
for base image.

The image can be found on
[Docker Hub](https://hub.docker.com/repository/docker/gpfister/base-devenv).

<div id="volumes" />

## Volumes

In order to persist user data, a volume for the /home folder is set. The root
user will not be persisted.

| Volume | Description                                        |
| ------ | -------------------------------------------------- |
| /home  |  Persist the user data stored in their home folder |

<div id="build-run-scan-push" />

## Build, scan and push

### A word about in progress developments

When you are making change to the image, use :develop at the end of the
[build](#build), [run](#run) and [scan](#scan) commands. The `develop` tag
should not be pushed...

### A word about cross-platform building

In order to build x-platform, `docker buildx` must be enabled (more info
[here](https://docs.docker.com/buildx/working-with-buildx/)). Then, instead of
`build` command, `buildx` command should be used (for example:
`npm run buildx:develop` will create a cross-platform image tagged `develop`).

You will need to create a multiarch builder:

```sh
$ docker buildx create --name multiarch
```

Then, prior to building, you need to use it (example output on Mac M1):

```sh
$ docker buildx use multiarch && docker buildx inspect --bootstrap

[+] Building 5.8s (1/1) FINISHED
 => [internal] booting buildkit                                             5.8s
 => => pulling image moby/buildkit:buildx-stable-1                            7s
 => => creating container buildx_buildkit_multiarch0                          1s
Name:   multiarch
Driver: docker-container

Nodes:
Name:      multiarch0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Platforms: linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64,
           linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64,
           linux/arm/v7, linux/arm/v6
```

`Ubuntu 20.04` been exclusively x64, only x64 architecture must be considered.

<div id="build" />

### Build

To build the image for upload, using the versionning in `package.json`, simply
run:

```sh
$ npm run build
```

It will create and image `gpfister/firebase-devenv` tagged with the version in the
`package.json` file and `latest`. For example:

```sh
$ sdocker images
REPOSITORY                                                TAG       IMAGE ID       CREATED          SIZE
gpfister/firebase-devenv                                  0.1.0     5fe9772cc4d1   23 minutes ago   1.28GB
gpfister/firebase-devenv                                  latest    5fe9772cc4d1   23 minutes ago   1.28GB
```

You may alter the `package.json` should you want to have different tags or
names, however if you PR your change, it will be rejected. The ideal solution
is to run the `docker build` command instead of the changing the provided
scripts.

<div id="run" />

## Run a container

To run an interactive container, simple use:

```sh
$ npm run start
```

It should create a container and name it `firebase-devenv-<VERSION>-test`.

<div id="scan" />

### Scan

To scan the image, simple run:

```sh
npm run scan
```

<div id="build-from-this-image" />

## Build from this image

Should you want to make other changes, the ideal solution is to build from this
image. For example, here's the way to set the image to a different timezone than
"Europe/Paris" (the default one):

```Dockerfile
FROM gpfister/firebase-devenv:latest

ENV TZ="America/New_York"

# Switch to root
USER root

# Reconfigure tzdata
RUN dpkg-reconfigure -f noninteractive tzdata

# Switch back to vscode
USER vscode
```

**Important:** unless you really want to use the root user, you should always
make sure the `vscode` is the last one activate.

<div id="version" />

## Version

| Image   |  Base image version | Ubuntu      | Node       |  NPM   |  Firebase Tools | Angular | Java                          | amd64 | arm64 |
| ------- | :-----------------: | ----------- | ---------- | ------ | --------------- | ------- | ----------------------------- | :---: | :---: |
| 0.1.0   |          -          | 20.04 (LTS) | 16.x (LTS) | 8.7.0  | 10.5.0          |  13.3.3 | 11 (open-jdk-11-jre-headless) |       |   X   |
| 0.2.0   |          -          | 20.04 (LTS) | 16.x (LTS) | 8.7.0  | 10.7.0          |  13.3.3 | 11 (open-jdk-11-jre-headless) |       |   X   |
| 0.3.0   |          -          | 20.04 (LTS) | 16.x (LTS) | 8.7.0  | 10.7.0          |  13.3.3 | 11 (open-jdk-11-jre-headless) |       |   X   |
| 0.4.0   |          -          | 20.04 (LTS) | 16.x (LTS) | 8.7.0  | 10.7.0          |  13.3.3 | 11 (open-jdk-11-jre-headless) |   X   |   X   |
| 0.5.0   |        0.1.0        | 20.04 (LTS) | 16.x (LTS) | 8.10.0 | 10.9.2          |  13.3.5 | 11 (open-jdk-11-jre-headless) |   X   |   X   |

<div id="faq" />

## FAQ

1. [How to require password for sudo command ?](#faq1)
2. [Is there an example to use it with Visual Studio Code ?](#faq2)

<div id="faq1" />

### 1. How to require password for sudo command ?

You will have to [build from this image](#build-from-this-image) to disable the
the password less sudo command. Typically create a `Dockerfile` like:

```Dockerfile
FROM gpfister/firebase-devenv:latest

ARG VSCODE_PASSWORD="dummy"

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    usermod -aG sudo vscode

# Change the password.
RUN usermod -p $VSCODE_PASSWORD vscode

# Switch back to vscode
USER vscode
```

If you simply want to get rid of `sudo`:

```Dockerfile

FROM gpfister/firebase-devenv:latest

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    apt-get purge -y sudo

# Switch back to vscode
USER vscode
```

<div id="faq2"/>

### 2. Is there an example to use it with Visual Studio Code ?

There will be one soon !!! Add notification to this project so that when the
update on this file is done you can check.

<div id="contrib" />

## Contributions

See instructions [here](./CONTRIBUTING.md).

<div id="license" />

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See license [here](./LICENSE).
