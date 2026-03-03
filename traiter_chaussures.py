import os
from pathlib import Path
from rembg import remove, new_session
from PIL import Image
import numpy as np
import configparser
import re

# ===================== CONFIG =====================
config = configparser.ConfigParser()
config.read('config.ini')

INPUT_FOLDER  = config.get('Settings', 'input_folder', fallback='photos_a_traiter')
OUTPUT_FOLDER = config.get('Settings', 'output_folder', fallback='photos_traitees')

TARGET_SIZE   = config.getint('Settings', 'target_square_size', fallback=1200)
FILL_RATIO    = config.getfloat('Settings', 'object_fill_ratio', fallback=0.78)
MODEL         = config.get('Settings', 'model_name', fallback='isnet-general-use')
PADDING_TH    = config.getint('Settings', 'padding_threshold', fallback=20)
SORT_ORDER    = config.get('Settings', 'sort_order', fallback='natural')

USE_MATTING   = config.getboolean('Settings', 'use_alpha_matting', fallback=False)
FG_TH         = config.getint('Settings', 'alpha_fg_threshold', fallback=210)
BG_TH         = config.getint('Settings', 'alpha_bg_threshold', fallback=25)
ERODE_SIZE    = config.getint('Settings', 'alpha_erode_size', fallback=8)

# Création dossiers
for folder in [INPUT_FOLDER, OUTPUT_FOLDER]:
    Path(folder).mkdir(exist_ok=True)

# Tri naturel (IMG_0001, IMG_10, IMG_0550, IMG_10000...)
def natural_key(s):
    return [int(c) if c.isdigit() else c.lower() for c in re.split(r'(\d+)', s)]

files = [f for f in os.listdir(INPUT_FOLDER) if f.lower().endswith(('.jpg','.jpeg','.png','.webp'))]

if SORT_ORDER == 'natural':
    files = sorted(files, key=natural_key)
else:
    files = sorted(files)

session = new_session(MODEL)

print(f"Modèle : {MODEL} | Matting : {USE_MATTING} | {len(files)} photos")

for filename in files:
    input_path = Path(INPUT_FOLDER) / filename
    output_path = Path(OUTPUT_FOLDER) / (filename.rsplit('.', 1)[0] + '.jpg')

    try:
        input_img = Image.open(input_path).convert("RGB")

        if USE_MATTING:
            output_img = remove(
                input_img,
                session=session,
                alpha_matting=True,
                alpha_matting_foreground_threshold=FG_TH,
                alpha_matting_background_threshold=BG_TH,
                alpha_matting_erode_size=ERODE_SIZE
            )
        else:
            output_img = remove(input_img, session=session, alpha_matting=False)

        # Détection bounding box
        alpha = np.array(output_img.getchannel("A"))
        y, x = np.where(alpha > PADDING_TH)
        if len(x) == 0:
            print(f"⚠️ Rien détecté dans {filename}")
            continue

        x_min, x_max = x.min(), x.max()
        y_min, y_max = y.min(), y.max()

        cropped = output_img.crop((x_min, y_min, x_max+1, y_max+1))

        scale = (TARGET_SIZE * FILL_RATIO) / max(cropped.width, cropped.height)
        new_w = int(cropped.width * scale)
        new_h = int(cropped.height * scale)

        resized = cropped.resize((new_w, new_h), Image.LANCZOS)

        final = Image.new("RGB", (TARGET_SIZE, TARGET_SIZE), (255, 255, 255))
        paste_x = (TARGET_SIZE - new_w) // 2
        paste_y = (TARGET_SIZE - new_h) // 2
        final.paste(resized.convert("RGB"), (paste_x, paste_y), mask=resized.split()[3] if resized.mode == "RGBA" else None)

        final.save(output_path, "JPEG", quality=95, optimize=True)
        print(f"✓ {filename}")

    except Exception as e:
        print(f"✗ {filename} → {e}")

print("\nTraitement terminé")