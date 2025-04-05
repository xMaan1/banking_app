from rest_framework import status, permissions
from rest_framework.views import APIView
from rest_framework.response import Response
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.utils import timezone
from django.http import JsonResponse

from .models import UserProfile, UserToken, Transaction
from .serializers import (
    UserSerializer, 
    UserProfileSerializer, 
    UserLoginSerializer, 
    TokenSerializer, 
    TransactionSerializer
)

class RegisterAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            token = UserToken.objects.create(user=user)
            return Response({
                'user': UserSerializer(user).data,
                'token': TokenSerializer(token).data
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        serializer = UserLoginSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            password = serializer.validated_data['password']
            remember_me = serializer.validated_data['remember_me']
            
            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                return Response({'error': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)
            
            authenticated_user = authenticate(username=user.username, password=password)
            
            if authenticated_user:
                # Invalidate old tokens if not remember_me
                if not remember_me:
                    UserToken.objects.filter(user=user).update(is_valid=False)
                
                # Create a new token
                token = UserToken.objects.create(user=user)
                
                # Extend expiration if remember_me
                if remember_me:
                    token.expires_at = timezone.now() + timezone.timedelta(days=30)
                    token.save()
                
                return Response({
                    'user': UserSerializer(user).data,
                    'token': TokenSerializer(token).data,
                    'profile': UserProfileSerializer(user.profile).data
                })
            
            return Response({'error': 'Invalid email or password'}, status=status.HTTP_400_BAD_REQUEST)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LogoutAPIView(APIView):
    def post(self, request):
        # Invalidate the token
        auth_header = request.headers.get('Authorization')
        if auth_header and auth_header.startswith('Token '):
            token_key = auth_header.split(' ')[1]
            try:
                token = UserToken.objects.get(token=token_key, is_valid=True)
                token.is_valid = False
                token.save()
                return Response({'message': 'Successfully logged out'})
            except UserToken.DoesNotExist:
                pass
        
        return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)

class CheckTokenView(APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        token_key = request.data.get('token')
        if not token_key:
            return Response({'error': 'Token not provided'}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            token = UserToken.objects.get(token=token_key, is_valid=True)
            
            # Check if token is expired
            if token.is_expired:
                token.is_valid = False
                token.save()
                return Response({'valid': False, 'error': 'Token expired'})
            
            # Update last used time
            token.last_used = timezone.now()
            token.save()
            
            return Response({
                'valid': True,
                'user': UserSerializer(token.user).data,
                'profile': UserProfileSerializer(token.user.profile).data
            })
        
        except UserToken.DoesNotExist:
            return Response({'valid': False, 'error': 'Invalid token'})

class ProfileAPIView(APIView):
    def get(self, request):
        profile = request.user.profile
        serializer = UserProfileSerializer(profile)
        return Response(serializer.data)

class TransactionListAPIView(APIView):
    def get(self, request):
        transactions = Transaction.objects.filter(user=request.user).order_by('-timestamp')
        serializer = TransactionSerializer(transactions, many=True)
        return Response(serializer.data)
    
    def post(self, request):
        serializer = TransactionSerializer(data=request.data)
        if serializer.is_valid():
            transaction_type = serializer.validated_data['transaction_type']
            amount = serializer.validated_data['amount']
            user_profile = request.user.profile
            
            # Handle different transaction types
            if transaction_type == Transaction.DEPOSIT:
                user_profile.balance += amount
            elif transaction_type == Transaction.WITHDRAWAL:
                if user_profile.balance < amount:
                    return Response({'error': 'Insufficient balance'}, status=status.HTTP_400_BAD_REQUEST)
                user_profile.balance -= amount
            elif transaction_type == Transaction.TRANSFER:
                if user_profile.balance < amount:
                    return Response({'error': 'Insufficient balance'}, status=status.HTTP_400_BAD_REQUEST)
                
                recipient_account = serializer.validated_data.get('recipient_account')
                if not recipient_account:
                    return Response({'error': 'Recipient account number is required'}, 
                                    status=status.HTTP_400_BAD_REQUEST)
                
                try:
                    recipient_profile = UserProfile.objects.get(account_number=recipient_account)
                    recipient_profile.balance += amount
                    recipient_profile.save()
                    user_profile.balance -= amount
                except UserProfile.DoesNotExist:
                    return Response({'error': 'Recipient account not found'}, 
                                    status=status.HTTP_400_BAD_REQUEST)
            
            user_profile.save()
            
            # Save the transaction
            transaction = serializer.save(user=request.user)
            
            return Response({
                'transaction': TransactionSerializer(transaction).data,
                'profile': UserProfileSerializer(user_profile).data
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class TestAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):
        return JsonResponse({"status": "ok", "message": "API is working"})
        
    def post(self, request):
        return JsonResponse({"status": "ok", "message": "API received your data", "data": request.data}) 