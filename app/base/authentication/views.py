from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.contrib.auth.models import User
from .forms import CreateUserForm, LoginForm
from django.contrib.auth.models import auth
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Cliente, Cuenta, Poseer
from django.contrib.auth.hashers import make_password
from datetime import datetime
from django.utils.dateparse import parse_date


def homepage(request):
    """
    Carga la pagina home.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    return render(request, 'authentication/index.html')


def signup(request):
    """
    Permite a los nuevos usuarios crear una cuenta para poder utilizar la aplicacion
    de una manera mas completa 
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == "POST":
        username = request.POST['username']
        nombre = request.POST['nombre']
        apellido_paterno = request.POST['apellido_paterno']
        apellido_materno= request.POST['apellido_materno']
        telefono = request.POST['telefono']
        fecha_de_nacimiento = request.POST['fecha_de_nacimiento']
        email = request.POST['email']
        pass1 = request.POST['pass1']
        pass2 = request.POST['pass2']

        if User.objects.filter(username=username):
            messages.error(request, "El usuario ya existe. Intente con otro distinto")
            return redirect('users:signup')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Ya existe una cuenta con ese correo electrónico")
            return redirect('users:signup')

        if Cliente.objects.filter(telefono=telefono).exists():
            messages.error(request, "Ya existe una cuenta con ese teléfono")
            return redirect('users:signup')

        if len(username) > 15:
            messages.error(request, "El usuario excedió el límite de carácteres")
            return redirect('users:signup')

        if pass1!=pass2:
            messages.error(request, "Las contraseñas no coinciden")
            return redirect('users:signup')

        if not username.isalnum():
            messages.error(request, "Usuario con carácteres inválidos.")
            return redirect('users:signup')
        
        nacimiento = parse_date(fecha_de_nacimiento)
        if nacimiento >= datetime.now().date():
            messages.error(request, "Fecha de nacimiento no válida.")
            return redirect('users:signup')

        myuser = User.objects.create_user(username, email, pass1)
        myuser.first_name= nombre
        myuser.last_name= apellido_paterno
        myuser.save()

        myuser_db = Cliente(
            id_cliente = myuser.id,
            nombre = nombre,
            apellido_materno = apellido_materno,
            apellido_paterno = apellido_paterno,
            telefono = telefono, 
            fecha_de_nacimiento = fecha_de_nacimiento
        )
        myuser_db.save()

        hashed_password = make_password(pass1)

        cliente_id = myuser_db.id_cliente
        cuenta = Cuenta(
            id_cuenta = myuser.id,
            correo_electronico = email,
            contrasena = hashed_password,
            id_cliente = cliente_id
        )
        cuenta.save()

        cuenta_cliente = Poseer(
            id_cuenta = myuser.id,
            correo_electronico = email,
            contrasena = hashed_password,
            id_cliente = myuser.id,
            nombre = nombre,
            apellido_materno = apellido_materno,
            apellido_paterno = apellido_paterno,
            telefono = telefono, 
            fecha_de_nacimiento = fecha_de_nacimiento
        )
        cuenta_cliente.save()

        registro_cuenta = Cuenta.objects.filter(id_cuenta = cuenta.id_cuenta).exists()

        if registro_cuenta:
            messages.success(request, "¡Cuenta creada con éxito!")
        else:
            messages.error(request, "Error al crear cuenta. Vuelva a intentar")

        return redirect('authentication:login')
    return render(request, 'authentication/signup.html')


def login_view(request):
    """
    Permite a los usuarios con una cuenta ya creada iniciar sesion dentro de la
    aplicacion.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == "POST":
        username = request.POST['username']
        pass1 = request.POST['pass1']
        next_url = request.POST.get('next', 'users:homepage')  

        user = authenticate(username=username, password=pass1)

        if user is not None:
            login(request, user)
            request.session['user_id'] = user.id
            u = User.objects.get(id=user.id)
            messages.success(request, "¡Sesión iniciada con éxito!")
            
            if u.has_perm("workers.puede_generar"):
                return redirect('workers:workers')

            if u.has_perm("users.puede_administrar"):
                return redirect('hoteladmin:home')
        
            return redirect(next_url)

        else:
            messages.error(request, "Credenciales inválidas")
            return render(request, 'authentication/login.html', {'next': next_url})

    next_url = request.GET.get('next', 'users:homepage')
    return render(request, 'authentication/login.html', {'next': next_url})


@login_required(login_url="login")
def main_user_dashboard(request):
    """
    Permite a los usuarios con sesion iniciada utilizar el dashboard
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    return render(request, 'authentication/main_user_dashboard.html')


def signout(request):
    """
    Permite a los usuarios cerrar sesion dentro de la aplicacion.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    logout(request)
    messages.success(request, "Sesión cerrada con éxito")
    return redirect('users:homepage')


def custom_404(request, exception):
    """
    Muestra el error 404 de la aplicacion.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
        exception (Exception): El objeto Exception que contiene la excepcion.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    return render(request, 'authentication/404.html', status=404)
