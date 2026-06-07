FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git git-lfs wget curl ffmpeg libgl1-mesa-glx libglib2.0-0 build-essential \
    && rm -rf /var/lib/apt/lists/*

# Zurück auf workspace!
WORKDIR /workspace

RUN git clone https://github.com/comfyanonymous/ComfyUI.git .
RUN pip install --no-cache-dir r requirements.txt setuptools wheel jupyterlab

WORKDIR /workspace/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
RUN git clone https://github.com/Lightricks/LTX-Video.git || true
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
RUN git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git

WORKDIR /workspace
RUN pip install --no-cache-dir huggingface_hub[cli]

COPY start.sh /workspace/start.sh
COPY download_models.py /workspace/download_models.py

EXPOSE 8188 8888

CMD ["bash", "/workspace/start.sh"]
