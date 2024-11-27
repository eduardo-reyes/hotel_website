from django import forms
from authentication.models import Cliente, Cuenta
from django.contrib.auth.hashers import make_password


class ClienteForm(forms.ModelForm):
    """
    Formulario para crear y actualizar instancias de clientes.

    Este formulario incluye los siguientes campos:
    - nombre
    - apellido_paterno
    - apellido_materno
    - telefono
    - fecha_de_nacimiento

    Widgets:
    - fecha_de_nacimiento: Un widget de input fecha con 'tipo' establecido en 'fecha'.
    """

    class Meta:
        model = Cliente
        fields = ['nombre', 'apellido_paterno', 'apellido_materno', 'telefono', 'fecha_de_nacimiento']
        widgets = {
            'fecha_de_nacimiento': forms.DateInput(attrs={'type': 'date'}),
        }


class CuentaForm(forms.ModelForm):
    """
    Formulario para crear y actualizar instancias de cuentas.

    Este formulario incluye los siguientes campos:
    - correo_electronico
    - contrasena

    Widgets:
    - contrasena: Un widget PasswordInput para ocultar la entrada de la contraseña.

    Methods:
    - save: Sobreescribe el método de guardado predeterminado para hashear
    la contraseña antes de guardarla.
    """
    class Meta:
        model = Cuenta
        fields = ['correo_electronico', 'contrasena']
        widgets = {
            'contrasena': forms.PasswordInput()
        }
    
    def save(self, commit=True):
        """
        Guarda una instancia de cuenta con una contraseña hasheada.
        Sobreescribe el método de guardado predeterminado para codificar 
        la contraseña antes de guardarla en la base de datos.
        
        Args:
            commit (bool): Si es verdad, guarda la instancia a la BD. 
            De manera predeterminada es verdad.

        Returns:
            Cuenta: La instancia de cuenta guardada.
        """
        cuenta = super().save(commit=False)
        cuenta.contrasena = make_password(self.cleaned_data['contrasena'])
        if commit:
            cuenta.save()
        return cuenta