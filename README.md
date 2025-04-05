# Banking App

A modern banking application with Flutter frontend and Django backend.

## Features

- **Secure Authentication**: Login/Register with token-based authentication
- **Remember Me Functionality**: Stay logged in with extended token expiration
- **Dashboard**: View account summary, balances, and recent transactions
- **Transfer Money**: Send funds between accounts with detailed transaction history
- **Profile Management**: View and edit user profile information
- **Responsive UI**: Beautiful, intuitive interface that works across devices

## Tech Stack

### Frontend
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language for Flutter
- **Shared Preferences**: Local storage for token management

### Backend
- **Django**: Python web framework
- **Django REST Framework**: API toolkit for Django
- **SQLite**: Database (can be changed to PostgreSQL for production)

## Setup Instructions

### Prerequisites
- Flutter SDK
- Python 3.8+
- Git

### Backend Setup
1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Create and activate a virtual environment:
   ```
   python -m venv venv
   ```

   - On Windows:
     ```
     .\venv\Scripts\activate
     ```
   - On macOS/Linux:
     ```
     source venv/bin/activate
     ```

3. Install dependencies:
   ```
   pip install django djangorestframework django-cors-headers
   ```

4. Run migrations:
   ```
   python manage.py makemigrations
   python manage.py migrate
   ```

5. Start the server:
   ```
   python manage.py runserver
   ```
   
   Alternatively, use the provided batch file (Windows):
   ```
   .\run_django.bat
   ```

### Frontend Setup
1. Navigate to the project root
   
2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the app:
   ```
   flutter run
   ```

## Screenshots

[Add screenshots of key screens here]

## API Endpoints

- `POST /api/auth/register/`: Register a new user
- `POST /api/auth/login/`: Login a user
- `POST /api/auth/logout/`: Logout a user
- `POST /api/auth/check-token/`: Validate user token
- `GET /api/auth/profile/`: Get user profile
- `GET /api/auth/transactions/`: List transactions
- `POST /api/auth/transactions/`: Create a transaction

## License

[MIT License](LICENSE)

## Contributors

- Your Name - Initial work

## Acknowledgments

- Flutter team for the amazing framework
- Django team for the robust backend framework
