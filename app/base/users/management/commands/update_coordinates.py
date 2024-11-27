# update_coordinates.py
from django.core.management.base import BaseCommand
from users.models import Hotel
from users.views import get_coordenadas

class Command(BaseCommand):
    help = 'Update coordinates for all hotels'

    def handle(self, *args, **kwargs):
        print("Checking location updates")
        hotels = Hotel.objects.all()
        for hotel in hotels:
            # Check if latitude or longitude is None or empty
            if not hotel.latitud or not hotel.longitud:
                address = hotel.hotel_direccion()
                (latitude, longitude) = get_coordenadas(address)
                hotel.latitud = latitude
                hotel.longitud = longitude
                hotel.save()
                self.stdout.write(self.style.SUCCESS(f'Updated coordinates for hotel {hotel.nombre}'))
            else:
                break