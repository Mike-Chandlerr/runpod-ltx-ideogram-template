FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive

# System-Pakete installieren
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

# WICHTIG: Wir bauen alles in /app, damit das RunPod-Volume es nicht überschreibt!
WORKDIR /app

# ComfyUI klonen & installieren
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir setuptools wheel

# Custom Nodes installieren
WORKDIR /app/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
RUN git clone https://github.com/Lightricks/LTX-Video.git || true

# Skripte direkt nach /app kopieren
WORKDIR /app
RUN pip install --no-cache-dir huggingface_hub[cli]

# Wir kopieren die Skripte beim Build mit rein
COPY start.sh /app/start.sh
COPY download_models.py /app/download_models.py

EXPOSE 8188

# Wir starten das Skript jetzt sicher aus /app/
CMD ["bash", "/app/start.sh"]
