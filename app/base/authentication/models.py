from django.db import models
from django.core.validators import MinLengthValidator


class Cliente(models.Model):
    """
    Modelo que representa a un cliente
    
    Attributes:
        id_cliente (AutoField): Llave primaria.
        nombre (CharField): Nombre del cliente.
        apellido_materno (CharField): Apellido paterno del cliente.
        apellido_paterno (CharField): Apellido materno del cliente.
        telefono (IntegerField): Telefono del cliente.
        fecha_de_nacimiento (DateField): Fecha de nacimiento del cliente.
    """
    id_cliente = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    telefono = models.CharField(max_length=10, unique=True)
    fecha_de_nacimiento = models.DateField()
    
    @property
    def nombre_completo(self):
        """
        Regresa el nombre completo del cliente.

        Returns:
            str: Nombre completo.
        """
        return f"{self.nombre} {self.apellido_paterno} {self.apellido_materno}"

    class Meta:
        db_table = 'cliente'

class Cuenta(models.Model):
    """
    Modelo de una cuenta
    
    Attributes:
        id_cuenta (AutoField): Llave primaria.
        correo_electronico (CharField): Correo electronico de la cuenta.
        contrasena (CharField): Contraseña de la cuenta:
        id_cliente (ForeignKey): Llave foránea hacia el modelo cliente.
    """
    id_cuenta = models.AutoField(primary_key=True)
    correo_electronico = models.EmailField(max_length=100, unique=True)
    contrasena = models.CharField(max_length=128, validators=[MinLengthValidator(8)])
    id_cliente = models.IntegerField()

    def __str__(self):
        """
        Regresa el correo electronico.

        Returns:
            str: correo electronico.
        """
        return f"Correo {self.correo_electronico}"

    class Meta:
        db_table = 'cuenta'

class Trabajador(models.Model):
    """
    Modelo de una cuenta
    
    Attributes:
        id_trabajador (AutoField): Llave primaria.
        nombre (CharField): Nombre del trabajador.
        apellido_paterno (CharField): Apellido paterno del trabajador.
        apellido_materno (CharField): Apellido materno del trabajador.
        telefono (IntegerField): Telefono del trabajador.
        fecha_de_nacimiento (DateField): Fecha de nacimiento del trabajador.
    """
    id_trabajador = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    telefono = models.CharField(max_length=10, unique=True)
    fecha_de_nacimiento = models.DateField(null=True)

    @property
    def nombre_completo(self):
        """
        Regresa el nombre completo del trabajador.

        Returns:
            str: Nombre completo.
        """
        return f"{self.nombre} {self.apellido_paterno} {self.apellido_materno}"

    class Meta:
        db_table = 'trabajador'

class Poseer(models.Model):
    """
    Modelo de poseer
    
    Attributes:
        id_cuenta (ForeignKey): Llave foránea hacia el modelo cuenta.
        correo_electronico (CharField): Correo electronico de la cuenta.
        contrasena (CharField): Contraseña de la cuenta.
        id_cliente (ForeignKey): Llave foránea hacia el modelo cliente.
        nombre (CharField): Nombre del cliente.
        apellido_materno (CharField): Apellido paterno del cliente.
        apellido_paterno (CharField): Apellido materno del cliente.
        telefono (IntegerField): Telefono del cliente.
        fecha_de_nacimiento (DateField): Fecha de nacimiento del cliente.
    """
    id_cuenta = models.IntegerField(primary_key=True)
    correo_electronico = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=128, validators=[MinLengthValidator(8)])
    id_cliente = models.IntegerField()
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    telefono = models.CharField(max_length=10, unique=True)
    fecha_de_nacimiento = models.DateField()

    class Meta:
        db_table = 'poseer'
        unique_together = (('id_cliente', 'id_cuenta'),)
        constraints = [
            models.CheckConstraint(check=models.Q(contrasena__length__gte=8), name='contrasena_length_check'),
        ]
        indexes = [
            models.Index(fields=['id_cliente']),
            models.Index(fields=['id_cuenta']),
        ]

    @property
    def nombre_completo(self):
        """
        Regresa el nombre completo del cliente.

        Returns:
            str: Nombre completo.
        """
        return f"{self.nombre} {self.apellido_paterno} {self.apellido_materno}"

    @nombre_completo.setter
    def nombre_completo(self, value):
        """
        Establece el nombre competo.
        """
        # Dummy setter to allow the property to be set in save method
        pass
