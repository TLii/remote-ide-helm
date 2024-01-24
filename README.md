# Remote IDE: yaml, helm and k8s

## General information

This is my personal image of a remote IDE for developing helm charts. Based on my own base image at [tlii/ide-debian-base](https://github.com/TLii/ide-debian-base). See the README there for more accurate instructions on usage.

## How to use?

### Basics

You can use this container either locally as you please or remotely through SSH. The login password is either provided by you or set randomly at container startup. If you don't provide a password, it is randomly set *each time you start the container*. The random password is printed to `stdout`.
`.ssh/authorized_keys` is rebuilt on every container start. See below for persisting keys.

### Helm chart?!

Not yet.

### Environment variables

- `$IDE_PASSWORD` sets login password for the created user. User name, however is set during image build and shouldn't be changed any more; the default is `vscode`.
- You can provide a single base64 encoded key through the environment variable `SSH-KEY`. If you need more than one key, use `authorized_keys.d` (see below)
- `/home/vscode/.ssh/authorized_keys.d`: In addition to key provided with `SSH-KEY` variable, files endin with `.key` in this directory will be included in `.ssh/authorized_keys`.

### Special mount locations
The following locations should be mounted as persistent volumes:

- `/home/vscode`: The home directory, under which all source code and user configuration is located.
- `/usr/local/etc/ssh`: The location of ssh(d) configuration. This is persisted to maintain ssh keys over instances and avoid warnings on changing keys.

### Custom scripting

You can add scripts to be run at container startup:
- `/home/vscode/setup.sh` is executed in the beginning of the entrypoint script,
- `/usr/local/bin/entrypoint.d/*.sh` are executed as part of container setup
- `/home/vscode/start.sh` is executed after setup, ie. right before user login is available.

Commands are not, by default, run as root, but you can use sudo to run commands with higher privileges. Please note that `/usr/local/bin/entrypoint.d` might also include scripts included with the image, so do not mount it as external volume. Mounting single files is preferrable.

### Extending container

Easiest way is to build an image using this as the source image. Instead of changing the docker-entrypoint.sh script itself you can extend entrypoint setup by placing additional scripts under `/usr/local/bin/entrypoint.d/`). All files with ending `.sh` will be executed during entrypoint. Note that entrypoint is run only with user privileges, so use sudo where necessary.