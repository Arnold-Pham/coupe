@echo off
chcp 65001 >nul
title Traitement Chaussures

set PYTHON=%~dp0python_embed\python.exe
cd /d "%~dp0"

:: Vérification des dépendances
"%PYTHON%" -c "import PIL, numpy, rembg" >nul 2>&1 || (
    echo ERREUR : dépendances manquantes.
    echo Veuillez d'abord exécuter setup.bat
    pause
    exit /b 1
)

echo Traitement en cours...
"%PYTHON%" traiter_chaussures.py

echo.
echo Terminé → photos dans photos_traitees
pause