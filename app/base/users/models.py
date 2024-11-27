from django.db import models

class Hotel(models.Model):
    """
    Modelo que representa un hotel.

    Attributes:
        id_hotel (AutoField): Llave primaria.
        numero (IntegerField): Número de la calle del hotel.
        nombre (CharField): Nombre del hotel.
        calle (CharField): Calle donde se ubica el hotel.
        estado (CharField): Estado donde se ubica el hotel.
        colonia (CharField): Colonia donde se ubica el hotel.
        pais (CharField): País donde se ubica el hotel.
        latitud (FloatField): Coordenada latitud del hotel (nullable).
        longitud (FloatField): Coordenada longitud del hotel (nullable).
    """
     
    id_hotel = models.AutoField(primary_key=True)
    numero = models.IntegerField()
    nombre = models.CharField(max_length=100)
    calle = models.CharField(max_length=100)
    estado = models.CharField(max_length=100)
    colonia = models.CharField(max_length=100)
    pais = models.CharField(max_length=100)
    latitud = models.FloatField(null=True, blank=True)
    longitud = models.FloatField(null=True, blank=True)

    def hotel_direccion(self):
        """
        Regresa la dirección completa de un hotel como cadena.

        Returns:
            str: Dirección del hotel.
        """
        return f"{self.nombre}, {self.calle} {self.numero}, {self.colonia}, {self.estado}, {self.pais}"
    
    def coordendas(self):
        """
        Regresa la latitud y longitud del hotel

        Returns:
            tupla: Tupla con la latitud y longitud.
        """
        return (self.latitud, self.longitud)

    class Meta:
        db_table = 'hotel'

class Habitacion(models.Model):
    """
    Modelo que representa la habitación de un hotel.

    Attributes:
        id_habitacion (AutoField): Llave primaria.
        id_hotel (ForeignKey): Llave foránea hacia el modelo hotel.
        numero (IntegerField): Número de habitación.
        esta_disponible (BooleanField): Disponibilidad de la habitación.
        costo (FloatField): Costo de la habitación por noche.
        tipo (CharField): Tipo de habitación.
    """
    id_habitacion = models.AutoField(primary_key=True)
    id_hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE, db_column='id_hotel', related_name='habitaciones')
    numero = models.IntegerField()
    esta_disponible = models.BooleanField(default=True)
    costo = models.FloatField()
    tipo = models.CharField(max_length=20)

    class Meta:
        db_table = 'habitacion'

class Reservacion(models.Model):
    """
    Modelo que representa una reservación de una habitación en un hotel
    que pertenece a un cliente.

    Attributes:
        id_reservacion (AutoField): Llave primaria.
        costo (FloatField): Costo de la reservación.
        check_in (DateTimeField): Check-in fecha y hora.
        check_out (DateTimeField): Check-out fecha y hora.
        id_habitacion (ForeignKey): Llave foránea hacia el modelo habitación.
        id_hotel (ForeignKey): Llave foránea hacia el modelo hotel.
        id_cliente (IntegerField): Llave foránea hacia el modelo cliente.
    """
    id_reservacion = models.AutoField(primary_key=True)
    costo = models.FloatField()
    check_in = models.DateTimeField()
    check_out = models.DateTimeField()
    id_habitacion = models.ForeignKey(Habitacion, on_delete=models.CASCADE, db_column='id_habitacion', related_name='reservaciones')
    id_hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE, db_column='id_hotel', related_name='reservaciones')
    id_cliente = models.IntegerField()  # id_cliente is a foreign key to the Cliente model

    class Meta:
        db_table = 'reservacion'
