# OpenCode on UBI 10

Runs the OpenCode CLI on `registry.access.redhat.com/ubi10/ubi`.
The image installs the latest OpenCode release at build time.

Build and run locally:

```sh
podman build -t ubi10-opencode -f Containerfile .
podman run --rm -it -v "$PWD:/workspace:Z" ubi10-opencode
```

GitHub Actions builds Linux AMD64 and ARM64 images. Pushes to `main`
publish `latest`, `main`, and `sha-<commit>` tags to
`ghcr.io/bkoz/ubi10-opencode`. Version tags such as `v1.0.0` publish a
matching image tag. Pull requests build without publishing. The workflow
can also be run manually from the Actions tab.

Publishing uses the built-in `GITHUB_TOKEN` with `packages: write`;
no additional repository secrets are required.

Run the published image:

```sh
podman run --rm -it -v "$PWD:/workspace:Z" ghcr.io/bkoz/ubi10-opencode:latest
```

For a private package, first use `podman login ghcr.io` with your GitHub
username and a classic personal access token with `read:packages` access.
Configure an AI provider using `/connect` inside OpenCode.

The image supports OpenShift's arbitrary UID model. `HOME` and the XDG
directories point to `/opt/app-root/src`, and that directory and `/workspace`
use root group ownership with `chmod -R g=u`. OpenShift-assigned UIDs can
write logs, configuration, cache, and project files through group `0`.
The default image user is non-root UID `1001`.

Mounted volumes replace the image directory permissions; ensure any mounted
home or workspace volume is writable by the pod's assigned UID or groups.

The `openshift/` directory contains existing sandbox examples with their
own image references; they are separate from this CLI image.
