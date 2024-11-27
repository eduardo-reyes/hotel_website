from django.db import models
from django.core.validators import MinLengthValidator


class Disponer(models.Model):
    """
    Modelo que representa disponer
    
    Attributes:
        id_trabajador (ForeignKey): Llave foránea hacia el modelo trabajador.
        id_cuenta (ForeignKey): Llave foránea hacia el modelo cuenta.
        nombre (CharField): Nombre del cliente.
        apellido_materno (CharField): Apellido paterno del cliente.
        apellido_paterno (CharField): Apellido materno del cliente.
        telefono (IntegerField): Telefono del cliente.
        fecha_de_nacimiento (DateField): Fecha de nacimiento del cliente.
        id_hotel (ForeignKey): Llave foránea hacia el modelo hotel.
        correo_electronico (CharField): Correo electronico de la cuenta.
        contrasena (CharField): Contraseña de la cuenta:
        id_cliente (ForeignKey): Llave foránea hacia el modelo hotel.
    """
    id_trabajador = models.IntegerField()
    id_cuenta = models.IntegerField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    telefono = models.CharField(max_length=10, unique=True)
    fecha_de_nacimiento = models.DateField(null=True, blank=True)
    id_hotel = models.IntegerField()
    correo_electronico = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=20, validators=[MinLengthValidator(8)])
    id_cliente = models.IntegerField()

    class Meta:
        db_table = 'disponer'
        unique_together = (('id_trabajador', 'id_cuenta'),)
        constraints = [
            models.CheckConstraint(check=models.Q(contrasena__length__gte=8), name='contrasena_trabajador_length_check'),
        ]

    @property
    def nombre_completo(self):
        """
        Regresa el nombre completo del cliente.

        Returns:
            str: Nombre completo.
        """
        return f"{self.nombre} {self.apellido_paterno} {self.apellido_materno}"

    def save(self, *args, **kwargs):
        """
        Guarda los datos.
        """
        super().save(*args, **kwargs)

