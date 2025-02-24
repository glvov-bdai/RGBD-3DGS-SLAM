FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04
SHELL ["/bin/bash", "-c"]
WORKDIR /workspace
# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    build-essential \
    git \
    sudo 

# Install Miniforge as root in /root's home directory
ENV CONDA_DIR=/root/miniforge3
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_DIR} && \
    rm Miniforge3-$(uname)-$(uname -m).sh
RUN git clone https://github.com/jagennath-hari/RGBD-3DGS-SLAM --recursive && cd RGBD-3DGS-SLAM && chmod +x install.sh

ENV PATH="${CONDA_DIR}/bin:$PATH"

RUN conda init bash && \
    echo "conda config --set auto_activate_base true" >> ~/.bashrc

RUN conda create --name rgbd-3dgs-slam python=3.10 -y
SHELL ["conda", "run", "-n", "rgbd-3dgs-slam", "/bin/bash", "-c"]
RUN source /workspace/RGBD-3DGS-SLAM/install.sh
