FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive

# System-Pakete installieren (inklusive Jupyter-Abhängigkeiten)
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

WORKDIR /app

# ComfyUI klonen & installieren
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir setuptools wheel jupyterlab

# Die absoluten Umsatz-Bringer Custom Nodes direkt vorinstallieren
WORKDIR /app/custom_nodes
RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git
RUN git clone https://github.com/Lightricks/LTX-Video.git || true
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
RUN git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git

# Skripte kopieren
WORKDIR /app
RUN pip install --no-cache-dir huggingface_hub[cli]

COPY start.sh /app/start.sh
COPY download_models.py /app/download_models.py

# Ports für ComfyUI (8188) und Jupyter Lab (8888) öffnen
EXPOSE 8188 8888

CMD ["bash", "/app/start.sh"]
