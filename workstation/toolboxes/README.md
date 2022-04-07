# Toolboxes

These are all managed by `toolbox` (via `podman`).

## Usage

### Building a container

To build one of the container images, use:

```bash
podman build --tag localhost/container-name:version ./my.Containerfile
```

### Entering a container

After building the container, use the below command to create a toolbox which will use the container.

```bash
toolbox create --image localhost/container-name:version
```

### Removing unused images

Use the following commands to remove an unused container image. There's probably an easier way to do this but haven't figured it out.

```bash
toolbox list
toolbox rm --force my-toolbox
podman image prune # or podman image rm <container-id>
```