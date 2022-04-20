# Firebase Dev Environment

Copyright (c) 2022, Greg PFISTER. MIT License

<div id="About">

## About

A simple Ubuntu container to use as development environment for
Node/Typescript/Firebas/Angular projects.

See [version](#version) mapping to find out which version Ubuntu, node, npm,
firebase-tools, angular and java.

Along with the basic requirements, the image provides:

- zsh
- vim with a few plugins (airline, syntastic, ripgrep, nerdcommenter, vim-colorschemes, ctrlp.vim)
- additionnal tools like `less`, `curl`, `nmap`, ...
- a `vscode` user account

## Run a container

To run an interactive container, simple use:

```sh
$ npm run start
```

It should create a container and name it firebase-devenv-<VERSION>-test.

```sh
$ docker ps

```

<div id="build">

## Build

To build the image, simple run:

```sh
$ npm run build
```

It will create and image `gpfister/firebase-devenv` tag with the version in the
`package.json` file and `latest`. For example:

```sh
$ sdocker images
REPOSITORY                                                TAG       IMAGE ID       CREATED          SIZE
gpfister/firebase-devenv                                  0.1.0     5fe9772cc4d1   23 minutes ago   1.28GB
gpfister/firebase-devenv                                  latest    5fe9772cc4d1   23 minutes ago   1.28GB
```

You may alter the `package.json` should you want to have different tags or
names, however if you PR your change, it will be rejected. The ideal solution
is to run the `docker build` command.

<div id="run">

## Scan

To scan the image, simple run:

```sh
npm run scan
```

## Build from this image

Should you want to make other changes, the ideal solution is to build from this
image. For example, here's the way to set the image to a different timezone than
"Europe/Paris" (the default one):

```docker
FROM gpfister/firebase-devenv:latest

ENV TZ="America/New_York"

RUN dpkg-reconfigure -f noninteractive tzdata
```

<div id="version">

## Version

| Image |  Ubuntu     | Node       |  NPM  |  Firebase Tools | Angular | Java                          |
| ----- | ----------- | ---------- | ----- | --------------- | ------- | ----------------------------- |
| 0.1.0 | 20.04 (LTS) | 16.x (LTS) | 8.7.0 | 10.5.0          |  13.3.3 | 11 (open-jdk-11-jre-headless) |

<div id="contrib">

## Contributions

See instructions [here](./CONTRIBUTING.md).

<div id="license">

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See license [here](./LICENSE).
