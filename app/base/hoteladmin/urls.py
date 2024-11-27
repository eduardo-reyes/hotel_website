from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('empleado/', views.empleado, name='empleado'),
    path('nuevohotel/', views.nuevo_hotel, name='nuevohotel'),
    path('nuevahabitacion/', views.nueva_habitacion, name='nuevahabitacion'),
    path('empleados/', views.buscar_empleado, name='empleados'),
    path('ver_empleado/', views.eliminar_empleado, name='ver_empleado'),
    path('hoteles/', views.buscar_hotel, name='hoteles'),
    path('ver_hotel/', views.eliminar_hotel, name='ver_hotel'),
    path('habitaciones/', views.eliminar_habitacion, name='habitaciones')
]
