# Slimming down your containers

## Background

Container images can be inordinately large, taking up lots of disk space and bandwidth. This is a problem for many users. Here, I use advice from Itamar Turner-Trauring to help slim down a typical bioinformatics Docker image. In this case, we go from 1.8GB to 336MB in size!

The original post by Itamar is here: https://pythonspeed.com/articles/conda-docker-image-size/. But, I made some modifications. In particular:

1. I removed the `SHELL` and `ENTRYPOINT` directives, and just added the appropriate `bin` folder to the `PATH`. Those were not necessary for things to work.
2. I changed the `runtime` image to `bitnami/minideb`, which gives a very small Debian image, and matches the linux flavor in the `build` image (`continuumio/miniconda3`).

For this dummy image, I chose to install `python`, `numpy`, and `samtools`. Check out the `environmnet.yml` file for more information.

## Two important elements for this to work

1. Staged builds - you build in one image, then stage the image to another image. In the staged image, you copy just the binaries you need to use, leaving behind all the developer tools/build tools you no longer require.
2. Using `conda-pack` (https://conda.github.io/conda-pack/) – a great tool to package up your conda environment, and share it across environments. It cleans up lots of things you don't need, like the package cache.

## Trying it out

This assumes you have Docker installed on your system, and you are able to run it.

```bash
git clone ...
cd ...
make test
```

If you want to experiment with different versions of `minideb` or `miniconda3`, you can run:

```bash
make build MINIDEB_VERSION=buster CONDA_VERSION=4.11.0
```

This command will build the image locally, and then give you a terminal access to it. You can then try out:

```bash
samtools --help
python -c "import numpy; print('success!')"
```

You can checkout the size of your images with:

```bash
docker images ls
```

As an example, I ran the following:

```bash
make build MINIDEB_VERSION=buster
```

This shaved another 11MB from the final image, bring it down to 325MB.

## Making it your own

Fork the repository and modify the `environmnet.yml` file to your liking.