from .models import *


class BaseCRUDService:
    model = None

    @classmethod
    def get_object(cls, pk):
        return cls.model.objects.get(pk=pk)

    @classmethod
    def create_object(cls, **kwargs):
        return cls.model.objects.create(**kwargs)

    @classmethod
    def updatge_object(cls, pk, **kwargs):
        obj = cls.get_object(pk)
        for key, value in kwargs.items():
            setattr(obj, key, value)
        obj.save()
        return obj

    @classmethod
    def delete_object(cls, pk):
        obj = cls.get_object(pk)
        obj.delete()
        return obj


class ServiciosCliente(BaseCRUDService):
    model = Cliente


class ServiciosComentario(BaseCRUDService):
    model = Comentario


class ServiciosCuenta(BaseCRUDService):
    model = Cuenta 


class ServiciosHotel(BaseCRUDService):
    model = Hotel


class ServiciosReservacion(BaseCRUDService):
    model = Reservacion
    

class ServiciosServicio(BaseCRUDService):
    model = Servicio 


class ServiciosTrabajador(BaseCRUDService):
    model = Trabajador
