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

echo Installation dépendances de base...
"%PYTHON%" -m pip install -r requirements.txt --quiet

echo Détection GPU...
nvidia-smi >nul 2>&1
if %errorlevel% equ 0 (
    echo GPU détecté → installation rembg[gpu]
    "%PYTHON%" -m pip install "rembg[gpu]" --quiet
) else (
    echo Mode CPU → rembg[cpu] déjà installé
)

echo.
echo === INSTALLATION TERMINÉE ===
echo Double-clique sur lancer.bat pour traiter tes photos
pause