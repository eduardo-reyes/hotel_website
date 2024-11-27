from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.models import User

from django import forms

from django.forms.widgets import PasswordInput, TextInput


class CreateUserForm(UserCreationForm):
    """
    Formulario para crear instancias de usuarios.

    Este formulario incluye los siguientes campos:
    - nombre
    - apellido_paterno
    - apellido_materno
    - telefono
    - fecha_de_nacimiento
    """
    nombre = forms.CharField(max_length=90, required=True)
    apellido_materno = forms.CharField(max_length=30, required=True)
    apellido_paterno = forms.CharField(max_length=30, required=True)
    fecha_de_nacimiento = forms.DateField(required=True)
    telefono = forms.CharField(max_length=12, required=True)

    class Meta:
        model = User
        fields = [
                    'username',
                    'password1',
                    'password2',
                    'email',
                    'nombre',
                    'apellido_materno',
                    'apellido_paterno',
                    'fecha_de_nacimiento',
                    'telefono',
                ]



class LoginForm(AuthenticationForm):
    """
    Formulario iniciar sesion.

    Este formulario incluye los siguientes campos:
    - username
    - pasword

    Widgets:
    - username: Un widget de input texto con 'tipo' establecido en 'username'.
    - password: Un widget de input password con 'tipo' establecido en 'password'.
    """

    username = forms.CharField(widget=TextInput())
    password = forms.CharField(widget=PasswordInput())

