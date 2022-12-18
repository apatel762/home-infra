# Toolboxes

These are all managed by `toolbox` (via `podman`).

## Usage

### Building a container

To build one of the container images, use:

```bash
podman build --tag localhost/main:1 main/
```

### Entering a container

After building the container, use the below command to create a toolbox which will use the container.

```bash
toolbox create --image localhost/main:1
```

### Removing unused images

Use the following commands to remove an unused container image. There's probably an easier way to do this but haven't figured it out.

```bash
toolbox list
toolbox rm --force main-1
podman image prune # or podman image rm <image-id>
```
