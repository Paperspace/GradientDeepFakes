FROM tensorflow/tensorflow:latest-gpu-py3

LABEL maintainer="Cris Valenzuela <cris@paperspace.com>"

RUN apt-get update -qq -y \
 && apt-get install -y libsm6 libxrender1 libxext-dev python3-tk\
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /opt/
RUN pip3 install cmake
RUN pip3 install dlib --install-option=--yes
RUN pip3 --no-cache-dir install -r /opt/requirements.txt && rm /opt/requirements.txt

# patch for tensorflow:latest-gpu-py3 image
RUN cd /usr/local/cuda/lib64 \
 && mv stubs/libcuda.so ./ \
 && ln -s libcuda.so libcuda.so.1 \
 && ldconfig

WORKDIR "/root"
COPY . .
WORKDIR /root