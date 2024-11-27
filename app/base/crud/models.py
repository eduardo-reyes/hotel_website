# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Cliente(models.Model):
    id_cliente = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    nombre_completo = models.CharField(max_length=300, blank=True, null=True)
    telefono = models.CharField(unique=True, max_length=10)
    fecha_de_nacimiento = models.DateField()

    class Meta:
        managed = False
        db_table = 'cliente'


class Comentario(models.Model):
    id_comentario = models.AutoField(primary_key=True)
    id_cliente = models.OneToOneField(Cliente, models.DO_NOTHING, db_column='id_cliente')
    opinion = models.CharField(max_length=200)
    valoracion = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'comentario'
        unique_together = (('id_cliente', 'id_comentario'),)


class Cuenta(models.Model):
    id_cuenta = models.AutoField(primary_key=True)
    correo_electronico = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=20, blank=True, null=True)
    id_cliente = models.ForeignKey(Cliente, models.DO_NOTHING, db_column='id_cliente', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'cuenta'


class Disponer(models.Model):
    id_trabajador = models.OneToOneField('Trabajador', models.DO_NOTHING, db_column='id_trabajador', primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    telefono = models.CharField(unique=True, max_length=10)
    nombre_completo = models.CharField(max_length=300, blank=True, null=True)
    fecha_de_nacimiento = models.DateField(blank=True, null=True)
    id_hotel = models.IntegerField(blank=True, null=True)
    id_cuenta = models.ForeignKey(Cuenta, models.DO_NOTHING, db_column='id_cuenta')
    correo_electronico = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=20, blank=True, null=True)
    id_cliente = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'disponer'
        unique_together = (('id_trabajador', 'id_cuenta'),)


class Habitacion(models.Model):
    id_habitacion = models.AutoField(primary_key=True)
    id_hotel = models.OneToOneField('Hotel', models.DO_NOTHING, db_column='id_hotel')
    numero = models.IntegerField()
    esta_disponible = models.BooleanField()
    costo = models.FloatField()
    tipo = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'habitacion'
        unique_together = (('id_hotel', 'id_habitacion'),)


class Hotel(models.Model):
    id_hotel = models.AutoField(primary_key=True)
    numero = models.IntegerField(blank=True, null=True)
    nombre = models.CharField(max_length=100)
    calle = models.CharField(max_length=100)
    estado = models.CharField(max_length=100)
    colonia = models.CharField(max_length=100)
    pais = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'hotel'


class Poseer(models.Model):
    id_cuenta = models.ForeignKey(Cuenta, models.DO_NOTHING, db_column='id_cuenta')
    correo_electronico = models.CharField(max_length=100)
    contrasena = models.CharField(max_length=20, blank=True, null=True)
    id_cliente = models.OneToOneField(Cliente, models.DO_NOTHING, db_column='id_cliente', primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    nombre_completo = models.CharField(max_length=300, blank=True, null=True)
    telefono = models.CharField(unique=True, max_length=10)
    fecha_de_nacimiento = models.DateField()

    class Meta:
        managed = False
        db_table = 'poseer'
        unique_together = (('id_cliente', 'id_cuenta'),)


class Reservacion(models.Model):
    id_reservacion = models.AutoField(primary_key=True)
    costo = models.FloatField()
    check_in = models.DateTimeField()
    check_out = models.DateTimeField()
    id_habitacion = models.IntegerField(blank=True, null=True)
    id_hotel = models.ForeignKey(Habitacion, models.DO_NOTHING, db_column='id_hotel', blank=True, null=True)
    id_cliente = models.ForeignKey(Cliente, models.DO_NOTHING, db_column='id_cliente', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'reservacion'


class Servicio(models.Model):
    id_servicio = models.AutoField(primary_key=True)
    esta_activo = models.BooleanField()
    costo = models.FloatField()
    tipo = models.CharField(max_length=20)
    disponibilidad = models.CharField(max_length=20)
    id_hotel = models.ForeignKey(Hotel, models.DO_NOTHING, db_column='id_hotel', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'servicio'


class Trabajador(models.Model):
    id_trabajador = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido_materno = models.CharField(max_length=100)
    apellido_paterno = models.CharField(max_length=100)
    telefono = models.CharField(unique=True, max_length=10)
    nombre_completo = models.CharField(max_length=300, blank=True, null=True)
    fecha_de_nacimiento = models.DateField(blank=True, null=True)
    id_hotel = models.ForeignKey(Hotel, models.DO_NOTHING, db_column='id_hotel', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'trabajador'
