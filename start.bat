@echo off
chcp 65001 >nul
title Traitement Chaussures

set PYTHON=%~dp0python_embed\python.exe
cd /d "%~dp0"

:: Verification des dependances - executer setup.bat si manquantes
"%PYTHON%" -c "import PIL, numpy, rembg" >nul 2>&1 || (
    echo ERREUR : dependances manquantes.
    echo Veuillez d'abord executer setup.bat
    pause
    exit /b 1
)

echo Traitement en cours...
"%PYTHON%" script.py

echo.
echo Termine - photos dans photos_traitees
pause
