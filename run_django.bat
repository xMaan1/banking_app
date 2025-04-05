@echo off
echo === Starting Django Backend Server ===
cd backend

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Check if activation was successful
if %ERRORLEVEL% NEQ 0 (
  echo Error: Failed to activate virtual environment
  pause
  exit /b 1
)

REM Install required packages
echo Installing required packages...
pip install django djangorestframework django-cors-headers

REM Check if Django is installed
python -c "import django" 2>nul
if %ERRORLEVEL% NEQ 0 (
  echo Error: Django is not installed correctly
  pause
  exit /b 1
)

REM Run Django server in development mode with improved security
echo Starting Django development server...
python manage.py check --deploy
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 127.0.0.1:8000 