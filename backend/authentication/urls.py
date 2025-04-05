from django.urls import path
from .views import (
    RegisterAPIView, 
    LoginAPIView, 
    LogoutAPIView, 
    CheckTokenView,
    ProfileAPIView,
    TransactionListAPIView,
    TestAPIView
)

urlpatterns = [
    path('register/', RegisterAPIView.as_view(), name='register'),
    path('login/', LoginAPIView.as_view(), name='login'),
    path('logout/', LogoutAPIView.as_view(), name='logout'),
    path('check-token/', CheckTokenView.as_view(), name='check-token'),
    path('profile/', ProfileAPIView.as_view(), name='profile'),
    path('transactions/', TransactionListAPIView.as_view(), name='transactions'),
    path('test/', TestAPIView.as_view(), name='test'),
] 