from django.shortcuts import render, redirect
from authentication.models import Trabajador
from users.models import Hotel
from django.contrib import messages
from django.contrib.auth.models import Group, User, Permission
from django.db.models import Max
from users.models import Hotel, Habitacion
from users.views import get_coordenadas
import os
from django.conf import settings
from django.http import HttpResponse
from django.utils.text import slugify
from PIL import Image
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth.decorators import permission_required

@permission_required("users.puede_administrar")
def home(request):
    return render(request, 'hoteladmin/adminpanel.html')

@permission_required("users.puede_administrar")
def empleado(request):
    """
    Metodo que guarda un nuevo empleado en la base de datos, solo si el usuario
    que desea administrar el nuevo hotel tiene los permisos necesarios.
    
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
            return redirect('hoteladmin:empleado')

        if User.objects.filter(email=email).exists():
            messages.error(request, "Ya existe una cuenta con ese correo electrónico")
            return redirect('hoteladmin:empleado')

        if Trabajador.objects.filter(telefono=telefono).exists():
            messages.error(request, "Ya existe una cuenta con ese teléfono")
            return redirect('hoteladmin:empleado')

        if len(username) > 15:
            messages.error(request, "El usuario excedió el límite de carácteres")
            return redirect('hoteladmin:empleado')

        if pass1!=pass2:
            messages.error(request, "Las contraseñas no coinciden")
            return redirect('hoteladmin:empleado')

        if not username.isalnum():
            messages.error(request, "Usuario con carácteres inválidos.")
            return redirect('hoteladmin:empleado')

        myuser = User.objects.create_user(username, email, pass1)
        myuser.first_name= nombre
        myuser.last_name= apellido_paterno
        myuser.save()
        worker_group = Group.objects.get(name="Trabajador")
        myuser.groups.add(worker_group)

        myuser_db = Trabajador(
            id_trabajador = myuser.id,
            nombre = nombre,
            apellido_materno = apellido_materno,
            apellido_paterno = apellido_paterno,
            telefono = telefono, 
            fecha_de_nacimiento = fecha_de_nacimiento
        )
        myuser_db.save()


        registro_cuenta = User.objects.filter(username=username).exists()

        if registro_cuenta:
            messages.success(request, "¡Cuenta creada con éxito!")
        else:
            messages.error(request, "Error al crear cuenta. Vuelva a intentar")

        return redirect('hoteladmin:home')
    
    return render(request, 'hoteladmin/signup.html')

@permission_required("users.puede_administrar")
def nuevo_hotel(request):
    """
    Metodo que guarda un nuevo hotel en la base de datos, solo si el usuario
    que desea administrar el nuevo hotel tiene los permisos necesarios.
    
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == "POST":
        nombre = request.POST['nombre']
        numero = request.POST['numero']
        calle = request.POST['calle']
        estado = request.POST['estado']
        colonia = request.POST['colonia']
        pais = request.POST['pais']
        image = request.FILES.get('image')

        if not image:
            return HttpResponse("No se subió ninguna imagen", status=400)

        if Hotel.objects.filter(nombre=nombre):
            messages.error(request, "Un hotel con ese nombre ya está dado de alta")
            return redirect('hoteladmin:nuevohotel')
        
        try:
            numero = int(numero)
        except ValueError:
            messages.error(request, "El valor ingresado en número no es un entero")
            return redirect('hoteladmin:nuevohotel')
        
        if numero <= 0:
            messages.error(request, "El número ingresado no es válido")
            return redirect('hoteladmin:nuevohotel')
        
        try:
            img = Image.open(image)
            if img.format != 'JPEG':
                return HttpResponse("La imagen no es JPG", status=400)
        except Exception as e:
            return HttpResponse("Archivo no válido", status=400)
        
        direccion = calle + ', ' + str(numero) + ', ' + colonia + ', ' + estado + ', ' + pais
 
        (latitud, longitud) = get_coordenadas(direccion)

        max_hotel = Hotel.objects.aggregate(max_value = Max('id_hotel'))['max_value']
        if max_hotel is None:
            max_hotel = 0

        hotel = Hotel(
            id_hotel = max_hotel + 1,
            numero = numero,
            nombre = nombre,
            calle = calle,
            estado = estado,
            colonia = colonia,
            pais = pais,
            latitud = latitud,
            longitud = longitud
        )
        hotel.save()

        custom_filename = slugify(str(hotel.id_hotel))
        new_filename = f'{custom_filename}.jpg'
        save_path = os.path.join(settings.MEDIA_ROOT, new_filename)
        os.makedirs(os.path.dirname(save_path), exist_ok=True) # Verificar que el directorio existe
        # Escribir el archivo en la ruta especificada
        with open(save_path, 'wb+') as destination:
            for chunk in image.chunks():
                destination.write(chunk)

        registro_hotel = Hotel.objects.filter(nombre=nombre).exists()

        if registro_hotel:
            messages.success(request, "¡Hotel creado con éxito!")
        else:
            messages.error(request, "Error al crear hotel. Vuelva a intentar")

        return redirect('hoteladmin:home')

    return render(request, 'hoteladmin/newhotel.html')


@permission_required("users.puede_administrar")
def nueva_habitacion(request):
    """
    Metodo que guarda una nueva habitacion de un hotel en la base de datos, solo si el usuario
    que desea administrar el nuevo hotel tiene los permisos necesarios.
    
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == "POST":
        id_hotel = request.POST['hotel']
        numero = request.POST['numero']
        esta_disponible = request.POST['disponibilidad']
        costo = request.POST['costo']
        tipo = request.POST['tipo']
        
        try:
            numero = int(numero)
        except ValueError:
            messages.error(request, "El valor ingresado en número no es un entero")
            return redirect('hoteladmin:home')
        
        if numero <= 0:
            messages.error(request, "El número ingresado no es válido")
            return redirect('hoteladmin:home')
        
        try:
            costo = float(costo)
        except ValueError:
            messages.error(request, "El valor ingresado en costo no es válido")
            return redirect('hoteladmin:home')
        
        if costo <= 0:
            messages.error(request, "El costo no puede ser negativo")
            return redirect('hoteladmin:home')

        habitaciones_hotel = Habitacion.objects.filter(id_hotel = id_hotel)
        max_habitacion = habitaciones_hotel.aggregate(max_value = Max('id_habitacion'))['max_value']
        if max_habitacion is None:
            max_habitacion = 0

        hotel = Hotel.objects.get(id_hotel=id_hotel)

        habitacion = Habitacion(
            id_habitacion = max_habitacion + 1,
            id_hotel = hotel,
            numero = numero,
            esta_disponible = esta_disponible,
            costo = costo,
            tipo = tipo
        )
        habitacion.save()

        id_habitacion = habitacion.id_habitacion

        registro_habitacion = Habitacion.objects.filter(id_habitacion=id_habitacion).exists()

        if registro_habitacion:
            messages.success(request, "¡Habitación creada con éxito!")
        else:
            messages.error(request, "Error al crear habitación. Vuelva a intentar")

        return redirect('hoteladmin:home')

    else:
        hoteles = Hotel.objects.all().order_by('nombre')
        return render(request, 'hoteladmin/newroom.html', {'hoteles': hoteles})
    

@permission_required("users.puede_administrar")
def buscar_empleado(request):
    """
    Busca a un empleado dentro de la base de datos, solo si el usuario que desea 
    realizar la busqueda tiene los permisos necesarios para invocar la funcion.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST': 
        telefono = request.POST['telefono']

        try:
            trabajador = Trabajador.objects.get(telefono = telefono)
        except ObjectDoesNotExist:
            messages.error(request, "No existe el trabajador buscado")
            return redirect('hoteladmin:home')
            
        return render(request, 'hoteladmin/delete_employee.html', {'trabajador': trabajador})
    
    else:
        return render(request, 'hoteladmin/employee.html')
    

@permission_required("users.puede_administrar")
def eliminar_empleado(request):
    """
    Elimina a un empleado de la base de datos, solo si el usuario que desea 
    eliminar al empleado tiene los permisos necesarios para invocar la funcion.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST': 
        trabajador_id = request.POST['trabajador_id']

        if trabajador_id:
            try:
                trabajador = Trabajador.objects.get(id_trabajador=trabajador_id)
                trabajador.delete()
                messages.success(request, "Trabajador eliminado")
            except Trabajador.DoesNotExist:
                messages.error(request, "No se pudo eliminar al trabajador")

        return redirect('hoteladmin:home')
    
    else:
        return render(request, 'hoteladmin/delete_employee.html')
    

@permission_required("users.puede_administrar")
def buscar_hotel(request):
    """
    Busca un hotel dentro de la base de datos, solo si el usuario que desea 
    realizar la busqueda tiene los permisos necesarios para invocar la funcion

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST': 
        hotel_id = request.POST['hotel']

        try:
            hotel = Hotel.objects.get(id_hotel = hotel_id)
        except ObjectDoesNotExist:
            messages.error(request, "No existe el hotel buscado")
            return redirect('hoteladmin:home')
            
        return render(request, 'hoteladmin/delete_hotel.html', {'hotel': hotel})
    
    else:
        hoteles = Hotel.objects.all().order_by('nombre')
        return render(request, 'hoteladmin/hotels.html', {'hoteles': hoteles})
    

@permission_required("users.puede_administrar")
def eliminar_hotel(request):
    """
    Elimina un hotel de la base de datos, solo si el usuario que desea 
    eliminar al empleado tiene los permisos necesarios para invocar la funcion.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST': 
        hotel_id = request.POST['hotel_id']

        try:
            hotel = Hotel.objects.get(id_hotel=hotel_id)
            hotel.delete()

            filename = f'{slugify(str(hotel_id))}.jpg'
            image_path = os.path.join(settings.MEDIA_ROOT, filename)
    
            if os.path.exists(image_path):
                os.remove(image_path)
            
            messages.success(request, "Hotel eliminado")

        except Hotel.DoesNotExist:
            messages.error(request, "No se pudo eliminar el hotel")

        return redirect('hoteladmin:home')
    
    else:
        return render(request, 'hoteladmin/delete_hotel.html')
    

@permission_required("users.puede_administrar")
def eliminar_habitacion(request):
    """
    Elimina una habitacion de un hotel de la base de datos, solo si el usuario que desea 
    eliminar al empleado tiene los permisos necesarios para invocar la funcion.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == "POST":
        id_hotel = request.POST['hotel']
        numero = request.POST['numero']
        
        if numero:
            try:
                numero = int(numero)
            except ValueError:
                messages.error(request, "El valor ingresado en número no es un entero")
                return redirect('hoteladmin:home')
            
            if numero <= 0:
                messages.error(request, "El número ingresado no es válido")
                return redirect('hoteladmin:home')
            
            try:
                habitacion = Habitacion.objects.get(id_hotel=id_hotel, numero=numero)
                habitacion.delete()

                messages.success(request, "Habitación con número " + str(numero) + " eliminada")
            except Habitacion.DoesNotExist:
                messages.error(request, "No se pudo eliminar la habitación")

            return redirect('hoteladmin:home')

        messages.error(request, "No se ingresó ningún núm. de habitación")
        return redirect('hoteladmin:home')

    else:
        hoteles = Hotel.objects.all().order_by('nombre')
        return render(request, 'hoteladmin/delete_rooms.html', {'hoteles': hoteles})
