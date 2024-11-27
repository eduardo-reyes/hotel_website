from django.urls import path
from . import views

urlpatterns = [
    path('', views.generador, name='workers'),
    path('vencimiento', views.vencimiento, name='vencimiento'),
    path('new_invoice', views.generar_factura, name='new_invoice')
]

