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

echo Mise a jour pip...
"%PYTHON%" -m pip install --upgrade pip --quiet --no-warn-script-location

echo Installation des dependances...
"%PYTHON%" -m pip install -r requirements.txt --quiet --no-warn-script-location

echo Detection GPU...
nvidia-smi >nul 2>&1
if %errorlevel% equ 0 (
    echo GPU detecte - installation onnxruntime-gpu...
    "%PYTHON%" -m pip install onnxruntime-gpu --quiet --no-warn-script-location
) else (
    echo Mode CPU - onnxruntime standard conserve
)

echo.
echo Preparation du modele IA (telechargement si necessaire ~175 Mo)...
"%PYTHON%" -c "from rembg import new_session; new_session('isnet-general-use')"
if %errorlevel% neq 0 (
    echo AVERTISSEMENT : echec du telechargement du modele.
    echo Le modele sera telecharge au premier lancement.
)

echo.
echo === INSTALLATION TERMINEE ===
echo Double-clique sur lancer.bat pour traiter tes photos
pause
