from django.urls import path
from . import views


urlpatterns = [
    path('', views.homepage, name="homepage"),
    path('signup', views.signup, name="signup"),
    path('login', views.login, name="login"),
    path('results', views.hotel_search, name="results"),
    path('rooms', views.available_rooms, name="rooms"),
    path('new_bookings', views.book, name="new_bookings"),
    path('bookings', views.bookings, name="bookings"),
    path('delete_reservation/<int:reservation_id>/', views.delete_reservation, name='delete_reservation'),
    path('invoice', views.invoice, name="invoice"),
    path('account', views.info_cuenta, name='account'),
    path('delete_account/<username>/', views.eliminar_cuenta, name='delete'),
]
