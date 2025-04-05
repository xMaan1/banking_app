# Banking App Backend

This is the Django REST API backend for the Banking App. It provides authentication, user management, and banking operations.

## Setup

1. Install dependencies:
   ```
   pip install django djangorestframework django-cors-headers
   ```

2. Run migrations:
   ```
   python manage.py makemigrations
   python manage.py migrate
   ```

3. Start the development server:
   ```
   python manage.py runserver
   ```

## API Endpoints

### Authentication
- `POST /api/auth/register/` - Register a new user
- `POST /api/auth/login/` - Login and get authentication token
- `POST /api/auth/logout/` - Logout and invalidate token
- `POST /api/auth/check-token/` - Check if a token is valid

### User Profile
- `GET /api/auth/profile/` - Get user profile information

### Transactions
- `GET /api/auth/transactions/` - List all user transactions
- `POST /api/auth/transactions/` - Create a new transaction

## Models

### UserProfile
Extends the default Django User model with banking details:
- account_number
- balance

### UserToken
Custom token implementation with expiration:
- token
- created_at
- expires_at
- last_used
- is_valid

### Transaction
Records financial transactions:
- transaction_type (deposit, withdrawal, transfer)
- amount
- recipient
- recipient_account
- description
- timestamp 