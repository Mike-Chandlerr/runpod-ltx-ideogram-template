#!/bin/bash

# In den App-Ordner wechseln, wo ComfyUI liegt
cd /app

# 1. Modell-Download starten (Modelle werden nach /workspace geladen, damit sie persistent bleiben!)
python3 /app/download_models.py

# 2. ComfyUI starten
python3 main.py --listen 0.0.0.0 --port 8188 --highvram --fp8_e4m3fn-text-enc
