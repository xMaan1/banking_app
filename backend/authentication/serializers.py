from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProfile, UserToken, Transaction
import random
import string

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password_confirm = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 'password', 'password_confirm')
    
    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({"password_confirm": "Passwords do not match."})
        return data
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        # Generate a random account number
        account_number = ''.join(random.choices(string.digits, k=10))
        UserProfile.objects.create(user=user, account_number=account_number, balance=10000)  # Default balance for demo
        return user

class UserProfileSerializer(serializers.ModelSerializer):
    email = serializers.CharField(source='user.email', read_only=True)
    full_name = serializers.SerializerMethodField()
    
    class Meta:
        model = UserProfile
        fields = ('account_number', 'balance', 'email', 'full_name')
    
    def get_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}".strip()

class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()
    remember_me = serializers.BooleanField(default=False)

class TokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserToken
        fields = ('token', 'expires_at')

class TransactionSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = Transaction
        fields = ('id', 'username', 'transaction_type', 'amount', 'recipient', 
                  'recipient_account', 'description', 'timestamp')
        read_only_fields = ('id', 'username', 'timestamp') 