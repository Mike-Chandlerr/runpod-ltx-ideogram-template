import os
from huggingface_hub import snapshot_download

def download_nextgen_models():
    hf_token = os.getenv("HF_TOKEN")
    
    # 1. Wir definieren die Pfade auf der großen Netzwerk-Festplatte
    models_base_dir = "/workspace"
    checkpoints_dir = f"{models_base_dir}/checkpoints"
    unet_dir = f"{models_base_dir}/unet"
    cache_dir = f"{models_base_dir}/hf_cache" # Hier wandert der temporäre Cache hin!
    
    os.makedirs(checkpoints_dir, exist_ok=True)
    os.makedirs(unet_dir, exist_ok=True)
    os.makedirs(cache_dir, exist_ok=True)

    # 2. WICHTIG: Wir zwingen Hugging Face, den Cache auf der 130GB Platte zu nutzen
    os.environ["HF_HOME"] = cache_dir
    os.environ["HF_HUB_CACHE"] = cache_dir

    print("=== STARTE DOWNLOAD (INKLUSIVE CACHE AUF DIE GROSSE VOLUME DISK) ===")

    try:
        # LTX-Video 2.3
        print("Lade LTX-Video Komponenten herunter...")
        snapshot_download(
            repo_id="Lightricks/LTX-Video",
            allow_patterns=["*.safetensors", "*.json"],
            local_dir=f"{checkpoints_dir}/ltx-video",
            cache_dir=cache_dir, # Doppelte Absicherung für den Cache-Pfad
            token=hf_token,
            max_workers=4
        )

        # FLUX.1 Dev
        print("Lade FLUX.1 Dev herunter...")
        snapshot_download(
            repo_id="black-forest-labs/FLUX.1-dev",
            allow_patterns=["*.safetensors", "*.json"],
            local_dir=f"{unet_dir}/flux1-dev",
            cache_dir=cache_dir, # Doppelte Absicherung für den Cache-Pfad
            token=hf_token,
            max_workers=4
        )
        
        print("=== ALLE MODELLE ERFOLGREICH UND FEHLERFREI GELADEN! ===")

    except Exception as e:
        print(f"HINWEIS beim Download: {e}")
        print("Pod-Start wird fortgesetzt.")

if __name__ == "__main__":
    download_nextgen_models()
