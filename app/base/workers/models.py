from django.db import models
from users.models import Reservacion

class Factura(models.Model):
    """
    Modelo que representa la cuenta de gastos de un cliente por una reservación.

    Attributes:
        id_factura (AutoField): Llave primaria.
        vencimiento (DateField): Fecha de vencimiento.
        emision (DateField): Fecha de emisión.
        total (FloatField): Costo total de la cuenta.
    """
    id_factura = models.AutoField(primary_key=True)
    vencimiento = models.DateField()
    emision = models.DateField()
    total = models.FloatField()

    class Meta:
        db_table = 'factura'

class Generar(models.Model):
    """
    Modelo que representa la relación entre una reservación y una cuenta de gastos.

    Attributes:
        id_generar (IntegerField): Llave primaria.
        id_reservacion (ForeignKey): Llave foránea hacia el modelo reservación.
        id_factura (ForeignKey): Llave foránea hacia el modelo factura.
    """
    id_generar = models.IntegerField(primary_key=True)
    id_reservacion = models.ForeignKey(Reservacion, on_delete=models.CASCADE, db_column='id_reservacion')
    id_factura = models.ForeignKey(Factura, on_delete=models.CASCADE, db_column='id_factura')

    class Meta:
        db_table = 'generar'
        unique_together = (('id_reservacion', 'id_factura'),)
