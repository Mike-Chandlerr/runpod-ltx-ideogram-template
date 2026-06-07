#!/bin/bash
# Production Entrypoint Script for RunPod Serverless

echo "[START] Starting RunPod Worker Initialization..."

# Check for HF Token
if [ -z "$HF_TOKEN" ]; then
  echo "[WARNING] HF_TOKEN is not set. Gated models might fail to download!"
else
  echo "[INFO] HF_TOKEN is set. Configuring Hugging Face Authentication..."
  huggingface-cli login --token $HF_TOKEN --add-to-git-credential
fi

# Set custom cache directory to persist models if storage volume is mounted
export HF_HOME=${HF_HOME:-/workspace/hf_cache}
mkdir -p $HF_HOME

echo "[INFO] Target HF Cache Directory: $HF_HOME"

# Execute primary handler script
echo "[START] Launching Serverless Worker..."
python -u /app/handler.py
