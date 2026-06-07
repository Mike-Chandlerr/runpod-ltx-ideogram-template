#!/bin/bash
cd /app

# 1. Modell-Download starten
python3 /app/download_models.py

# 2. Jupyter Lab im Hintergrund starten (ohne Passwort für schnellen RunPod-Connect)
jupyter lab --allow-root --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' &

# 3. ComfyUI im Vordergrund starten
python3 main.py --listen 0.0.0.0 --port 8188 --highvram --fp8_e4m3fn-text-enc
