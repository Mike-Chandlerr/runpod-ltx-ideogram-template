FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

# System-Abhängigkeiten installieren
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git \
    git-lfs \
    curl \
    wget \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# ComfyUI installieren
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Python-Abhängigkeiten für ComfyUI installieren
RUN pip install --no-cache-dir -r requirements.txt

# GPU-Optimierungen installieren
RUN pip install --no-cache-dir setuptools wheel

# Custom Nodes installieren
WORKDIR /workspace/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
RUN git clone https://github.com/Lightricks/LTX-Video.git || true

# Zurück zum Hauptverzeichnis
WORKDIR /workspace

# Hugging Face Hub CLI installieren
RUN pip install --no-cache-dir huggingface_hub[cli]

# Startup-Skripte ausführbar machen
EXPOSE 8188 8888

CMD ["bash", "/workspace/start.sh"]
