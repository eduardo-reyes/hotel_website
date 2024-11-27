from .models import *


class BaseCRUDService:
    model = None

    @classmethod
    def list_all(cls):
        return model.objects.all()

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


class ClienteService(BaseCRUDService):
    model = Cliente


class ComentarioService(BaseCRUDService):
    model = Comentario


class CuentaService(BaseCRUDService):
    model = Cuenta 


class HotelService(BaseCRUDService):
    model = Hotel


class ReservacionService(BaseCRUDService):
    model = Reservacion
    

class ServicioService(BaseCRUDService):
    model = Servicio 


class TrabajadorService(BaseCRUDService):
    model = Trabajador
