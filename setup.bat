@echo off
chcp 65001 >nul
title SETUP - ChaussuresAuto

set PYTHON=%~dp0python_embed\python.exe

if not exist "%PYTHON%" (
    echo ERREUR : dossier python_embed introuvable
    pause
    exit /b
)

cd /d "%~dp0"

echo Installation de pip...
"%PYTHON%" python_embed\get-pip.py --quiet

echo Mise à jour pip...
"%PYTHON%" -m pip install --upgrade pip --quiet

echo Installation dépendances de base (CPU)...
"%PYTHON%" -m pip install -r requirements.txt --quiet

echo Détection GPU...
nvidia-smi >nul 2>&1
if %errorlevel% equ 0 (
    echo GPU détecté - installation onnxruntime-gpu...
    "%PYTHON%" -m pip install onnxruntime-gpu --quiet
) else (
    echo Mode CPU - onnxruntime standard conservé
)

echo.
echo Préparation du modèle IA (téléchargement si nécessaire ~175 Mo)...
"%PYTHON%" -c "from rembg import new_session; new_session('isnet-general-use')"
if %errorlevel% neq 0 (
    echo AVERTISSEMENT : échec du téléchargement du modèle.
    echo Le modèle sera téléchargé au premier lancement.
)

echo.
echo === INSTALLATION TERMINÉE ===
echo Double-clique sur lancer.bat pour traiter tes photos
pause