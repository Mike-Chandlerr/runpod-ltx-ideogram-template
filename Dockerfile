FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive

# System-Pakete für Grafik und Video
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    wget \
    curl \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# ComfyUI klonen & installieren
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir setuptools wheel

# Custom Nodes für LTX-Video und den Manager reinladen
WORKDIR /workspace/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
RUN git clone https://github.com/Lightricks/LTX-Video.git || true

WORKDIR /workspace
RUN pip install --no-cache-dir huggingface_hub[cli]

EXPOSE 8188

CMD ["bash", "/workspace/start.sh"]
