ARG CONDA_VERSION=4.12.0
ARG MINIDEB_VERSION=bullseye
FROM continuumio/miniconda3:${CONDA_VERSION} AS build

COPY environment.yml .

RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict && \
    conda env create -f environment.yml && \
    conda install -c conda-forge conda-pack

RUN conda-pack -n pkgs -o /tmp/pkgs.tar && \
    mkdir -p /opt/pkgs && \
    cd /opt/pkgs && \
    tar -xvf /tmp/pkgs.tar && \
    rm /tmp/pkgs.tar

RUN /opt/pkgs/bin/conda-unpack


FROM bitnami/minideb:${MINIDEB_VERSION} AS runtime

COPY --from=build /opt/pkgs /opt/pkgs

ENV PATH "/opt/pkgs/bin:$PATH"
