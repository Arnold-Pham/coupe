# ChaussuresAuto

Outil portable Windows pour supprimer automatiquement le fond de photos de chaussures et les recentrer sur un canvas blanc.

## Prérequis

- Windows 10 / 11
- Connexion internet (premier lancement uniquement, pour télécharger le modèle IA ~175 Mo)
- GPU NVIDIA recommandé (fonctionne aussi en CPU)

## Installation

Double-cliquer sur **`setup.bat`** et attendre la fin du processus.

Il installe automatiquement :
- les dépendances Python (Pillow, NumPy, rembg)
- `onnxruntime-gpu` si un GPU NVIDIA est détecté, sinon `onnxruntime` CPU
- le modèle IA `isnet-general-use`

> L'installation ne se fait qu'une seule fois. Après un clone ou un déplacement du dossier, relancer `setup.bat`.

## Utilisation

1. Placer les photos dans le dossier `photos_a_traiter/`
2. Double-cliquer sur **`start.bat`**
3. Les images traitées apparaissent dans `photos_traitees/` au format JPEG

Formats acceptés : `.jpg`, `.jpeg`, `.png`, `.webp`

## Configuration

Modifier `config.ini` pour ajuster le comportement :

| Paramètre | Défaut | Description |
|---|---|---|
| `input_folder` | `photos_a_traiter` | Dossier source |
| `output_folder` | `photos_traitees` | Dossier de sortie |
| `target_square_size` | `2000` | Taille du canvas carré en pixels |
| `object_fill_ratio` | `0.78` | Proportion occupée par le sujet (0.0 – 1.0) |
| `model_name` | `isnet-general-use` | Modèle rembg utilisé |
| `sort_order` | `natural` | `natural` = tri numérique, `alpha` = tri alphabétique |
| `padding_threshold` | `20` | Seuil alpha pour détecter le sujet (0 – 255) |
| `use_alpha_matting` | `True` | `True` = bords fins, `False` = masque brut (ombres conservées) |
| `alpha_fg_threshold` | `200` | Seuil avant-plan (alpha matting uniquement) |
| `alpha_bg_threshold` | `30` | Seuil arrière-plan (alpha matting uniquement) |
| `alpha_erode_size` | `6` | Érosion des bords (alpha matting uniquement) |

## Structure du projet

```
coupe/
├── python_embed/          # Python 3.14 portable (ne pas modifier)
├── photos_a_traiter/      # Dossier source (créé automatiquement)
├── photos_traitees/       # Dossier de sortie (créé automatiquement)
├── config.ini             # Configuration
├── script.py              # Script principal
├── requirements.txt       # Dépendances Python
├── setup.bat              # Installation (lancer une fois)
└── start.bat              # Lancement du traitement
```

## Modèles rembg disponibles

Changer `model_name` dans `config.ini` et relancer `setup.bat` pour télécharger le nouveau modèle.

| Modèle | Usage |
|---|---|
| `isnet-general-use` | Usage général, recommandé |
| `u2net` | Polyvalent, plus rapide |
| `birefnet-general` | Haute qualité, plus lent |
| `sam` | Masquage assisté (avancé) |
