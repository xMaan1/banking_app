"""
URL Configuration for banking_backend project.
"""
from django.contrib import admin
from django.urls import path, include
from django.shortcuts import redirect

def api_redirect(request):
    return redirect('api/auth/')

urlpatterns = [
    path('', api_redirect),
    path('admin/', admin.site.urls),
    path('api/auth/', include('authentication.urls')),
]