ARG BASE_IMAGE=mambaorg/micromamba:0.25.1
FROM $BASE_IMAGE

WORKDIR /app
COPY ./python_env_install.py ./python_requirements.yml .
USER root
SHELL ["/bin/bash", "-c"]
RUN apt-get update \
	&& apt-get -y install gcc iproute2 \
	&& cd /app \
	&& export CONDA_PREFIX=/root/micromamba \
	&& micromamba shell init -p /root/micromamba -s bash > /dev/null \
	&& source /root/.bashrc \
	&& micromamba activate \
	&& micromamba install -y -n base -c conda-forge python=3.8 \
	&& python3 python_env_install.py install packages \
	&& micromamba clean -ay \
	&& find /root/micromamba/ -follow -type f -name '*.a' -delete \
	&& find /root/micromamba/ -follow -type f -name '*.pyc' -delete \
	&& find /root/micromamba/ -follow -type f -name '*.js.map' -delete

ENV PYTHONUNBUFFERED=1