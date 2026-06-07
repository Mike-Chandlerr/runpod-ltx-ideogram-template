#!/bin/bash
cd /app

# 1. Modell-Download starten
python3 /app/download_models.py

# 2. Jupyter Lab im Hintergrund starten
jupyter lab --allow-root --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password='' &

# 3. ComfyUI starten UND mit --input-directory / --output-directory auf /workspace lenken
python3 main.py --listen 0.0.0.0 --port 8188 --highvram --fp8_e4m3fn-text-enc --extra-model-paths-config /workspace/extra_model_paths.yaml || python3 main.py --listen 0.0.0.0 --port 8188 --highvram --fp8_e4m3fn-text-enc
