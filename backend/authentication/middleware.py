from django.utils.deprecation import MiddlewareMixin
from django.utils import timezone
from django.contrib.auth.models import AnonymousUser
from django.http import HttpResponse
from rest_framework.authtoken.models import Token
from .models import UserToken

class CorsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Add CORS headers to all responses
        response = self.get_response(request)
        response["Access-Control-Allow-Origin"] = "*"
        response["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        response["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
        return response

    def process_view(self, request, view_func, view_args, view_kwargs):
        if request.method == "OPTIONS":
            # Create a response for OPTIONS requests (preflight)
            response = HttpResponse()
            response["Access-Control-Allow-Origin"] = "*"
            response["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
            response["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
            return response
        return None

class TokenAuthMiddleware(MiddlewareMixin):
    def process_request(self, request):
        auth_header = request.headers.get('Authorization')
        if auth_header and auth_header.startswith('Token '):
            token_key = auth_header.split(' ')[1]
            try:
                token = UserToken.objects.get(token=token_key, is_valid=True)
                
                # Check if token is expired
                if token.is_expired:
                    token.is_valid = False
                    token.save()
                    request.user = AnonymousUser()
                    return
                
                # Update last used time
                token.last_used = timezone.now()
                token.save()
                
                # Set the user on the request
                request.user = token.user
                return
            except UserToken.DoesNotExist:
                pass
        
        # Default to anonymous user if no valid token is found
        if not hasattr(request, 'user'):
            request.user = AnonymousUser() 