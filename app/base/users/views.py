from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from users.models import Hotel, Habitacion, Reservacion
from workers.models import Generar, Factura
from authentication.models import Cliente, Cuenta, Poseer
from django.contrib.auth.models import User
from django.contrib import auth
import authentication.views as auth
from datetime import datetime
from django.db.models import Max
from django.http import JsonResponse
import requests
from django.db.models import Q
from django.utils import timezone
from django.db.models import FloatField, F, Func
from django.db.models.functions import ACos, Cos, Radians, Sin
from django.db.models import Count
from django.contrib import messages
from .forms import ClienteForm, CuentaForm
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth.hashers import check_password
from django.db.models.functions import ExtractDay
import pytz

def homepage(request):
    """
    Redirección a la página principal.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    return render(request, 'users/index.html')


def signup(request):
    """
    Método que registra un nuevo usuario. Llama al método signup de authentication.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    return auth.signup(request)


def login(request):
    """
    Método que da acceso a un usuario. Llama al método login_view de authentication.

    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    return auth.login_view(request)


def get_coordenadas(direccion):
    """
    Obtiene las coordenadas geográficas de una dirección real.

    Args:
        direccion (string): Dirección física.
 
    Returns:
        (float,float): Tupla con la latitud y longitud.
    """
    API_KEY = '' # IMPORTANTE: Ingresar una API_KEY de Google Maps válida para que funcione la búsqueda por distancia.
    
    params = {
        'key': API_KEY,
        'address': direccion
    }
    
    base_url = 'https://maps.googleapis.com/maps/api/geocode/json?'
    response = requests.get(base_url, params=params).json()
    
    response.keys()
    
    if response['status'] == 'OK':
        geometry = response['results'][0]['geometry']
        lat = geometry['location']['lat']
        lon = geometry['location']['lng']
        return (lat,lon)
    else:
        print("Error en la respuesta de la API")
        return (0,0)


class Radians(Func):
    """
    Representa la función RADIANS de SQL que convierte grados a radianes.

    Attributes:
        function: Ajustado a RADIANS indicando la función SQL a usar.
        output_field: Especifica que el valor de salida es flotante.
    """
    function = 'RADIANS'
    output_field = FloatField()

class Sin(Func):
    """
    Representa la función SQL SIN para calcular el seno de un ángulo.
    
    Attributes:
        function: Ajustado a SIN.
        output_field: Especifica que el valor de salida es flotante.
    """
    function = 'SIN'
    output_field = FloatField()

class Cos(Func):
    """
    Representa la función SQL COS para calcular el coseno de un ángulo.
    
    Attributes:
        function: Ajustado a COS.
        output_field: Especifica que el valor de salida es flotante.
    """
    function = 'COS'
    output_field = FloatField()

class Acos(Func):
    """
    Representa la función SQL ACOS para calcular el arco coseno de un ángulo.
    
    Attributes:
        function: Ajustado a ACOS.
        output_field: Especifica que el valor de salida es flotante.
    """
    function = 'ACOS'
    output_field = FloatField()
    
def calculate_distance(lat1, lon1, lat2, lon2):
    """
    Esta función calcula la distancia del círculo máximo entre dos puntos
    de la Tierra utilizando sus coordenadas de latitud y longitud. 
    El cálculo se basa en la fórmula de Haversine.
        
    Args:
        lat1 (float): Latitud del primer punto en grados.
        lon1 (float): Longitud del primer punto en grados.
        lat2 (float): Latitud del segundo punto en grados.
        lon2 (float): Longitud del segundo punto en grados.
    Returns:
        distance (float): La distancia entre los dos puntos en kilómetros.
    """
    R = 6371  # Radio de la Tierra en kilómetros
    dlat = Radians(lat2 - lat1)
    dlon = Radians(lon2 - lon1)
    a = Sin(dlat / 2) ** 2 + Cos(Radians(lat1)) * Cos(Radians(lat2)) * Sin(dlon / 2) ** 2
    c = 2 * ACos(Cos(a))
    distance = R * c
    return distance


def find_nearest_hotels(latitude, longitude):
    """
    Encuentra los hoteles más cercanos según la latitud y
    longitud recibidas y la lista de hoteles guardados
    en la base de datos con sus coordenadas respectivas.
    Para ello, se calcula la distancia en kilómetros usando
    un QuerySet y se ordena de menor a mayor.
        
    Args:
        latitude (float): Latitud del punto en grados.
        lonngitude (float): Longitud del punto en grados.
    Returns:
        hotels (QuerySet): Listado de hoteles ordenados por distancia.
    """
    hotels = Hotel.objects.annotate(
        distance=calculate_distance(
            latitude,
            longitude,
            F('latitud'),
            F('longitud')
        )
    ).order_by('distance')
    
    return hotels
    

def get_available_rooms(hotel_id, checkin_date, checkout_date):
    """
    Dado un hotel y fechas particulares de checkin y checkout,
    ecnuentra las habitaciones del hotel disponibles que no
    tienen reservaciones dentro de ese lapso de fechas.
        
    Args:
        hotel_id (int): Identificador del hotel.
        checkin_date (datetime): Día y hora del checkin.
        checkout_date (datetime): Día y hora del checkout.
    Returns:
        habitaciones (QuerySet): Listado de habitaciones disponibles.
    """
    reservaciones = Reservacion.objects.filter(
        Q(check_in__lte=checkin_date, check_out__gte=checkin_date) |
        Q(check_in__lte=checkout_date, check_out__gte=checkout_date) |
        Q(check_in__gte=checkin_date, check_out__lte=checkout_date),
        id_hotel=hotel_id
    )
        
    habitaciones_ocupadas = reservaciones.values_list('id_habitacion', flat=True)
        
    habitaciones = Habitacion.objects.filter(
        id_hotel=hotel_id
    ).exclude(
        id_habitacion__in=habitaciones_ocupadas
    )
    
    return habitaciones


def hotel_search(request):
    """
    Página de búsqueda de hoteles. Dado una dirección física como
    destino y fechas de checkin y checkout, redirige a una página
    con los hoteles que tienen habitaciones que cumplen esas condiciones.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST':
        destino = request.POST.get('destino')

        if destino is None or destino == '':
            messages.error(request, "Por favor ingrese un destino")
            return redirect('users:homepage')
        
        checkin_date = request.POST.get('checkin_date')
        checkout_date = request.POST.get('checkout_date')

        if checkin_date is None or checkin_date == '':
            messages.error(request, "Por favor ingrese una fecha de check-in")
            return redirect('users:homepage')

        if checkout_date is None or checkout_date == '':
            messages.error(request, "Por favor ingrese una fecha de check-out")
            return redirect('users:homepage')
    
        if checkin_date >= checkout_date:
            messages.error(request, "La fecha de check-out no puede ser anterior o igual a la fecha de check-in")
            return redirect('users:homepage')

        checkin_date = datetime.strptime(checkin_date, '%m/%d/%Y %I:%M %p')
        checkout_date = datetime.strptime(checkout_date, '%m/%d/%Y %I:%M %p')

        local_timezone = pytz.timezone('Mexico/General')

        checkin_date = local_timezone.localize(checkin_date)
        checkout_date = local_timezone.localize(checkout_date)

        today = timezone.now().astimezone(local_timezone)

        if checkin_date <= today:
            messages.error(request, "La fecha de check-in no puede ser anterior o igual a la fecha actual")
            return redirect('users:homepage')
        
        request.session['checkin_date'] = checkin_date.isoformat()
        request.session['checkout_date'] = checkout_date.isoformat()

        (latitude, longitude) = get_coordenadas(destino)
        hoteles_cercanos = find_nearest_hotels(latitude, longitude)

        hoteles_con_habitaciones = []
        for hotel in hoteles_cercanos:
            habitaciones_disponibles = get_available_rooms(hotel.id_hotel, checkin_date, checkout_date)
            if habitaciones_disponibles.exists():
                hoteles_con_habitaciones.append(hotel)
        
        return render(request, 'users/hotel_search.html', {'hoteles': hoteles_con_habitaciones})
    else:
        return render(request, 'index.html')


def available_rooms(request):
    """
    Página de búsqueda de habitaciones. Dado una dirección física como
    destino y fechas de checkin y checkout, muestra las habitaciones
    disponibles de un hotel que cumplen esas condiciones.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST':
        hotel_id = request.POST.get('hotel_id')
        
        checkin_date = request.session.get('checkin_date')
        checkout_date = request.session.get('checkout_date')
        
        habitaciones = get_available_rooms(hotel_id, checkin_date, checkout_date)
        
        # Obtener los distintos tipos de habitaciones y crear un diccionario para contarlas
        tipos = habitaciones.values('tipo').distinct()
        tipo_counts = {tipo['tipo']: habitaciones.filter(tipo=tipo['tipo']).count() for tipo in tipos}

        habitaciones = habitaciones.distinct('tipo')
       
        return render(request, 'users/hotel_rooms.html', {'habitaciones': habitaciones, 'tipo_counts': tipo_counts})
    else:
        return render(request, 'index.html')

def book(request):
    """
    Permite generar una reservación a partir del identificador de un hotel y redirige al
    usuario hacia todas sus reservaciones incluyendo la nueva. En caso de no estar
    autenticado, permite hacer login y generar la reservación de la habitación posteriormente.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if 'post_data' in request.session:
        post_data = request.session.pop('post_data')
        request.POST = post_data
        request.method = 'POST'

    if request.method == 'POST':
        if request.user.is_authenticated:
            habitacion_id = request.POST.get('habitacion_id')

            user_id = request.session.get('user_id')
            user = User.objects.get(id=user_id)
            
            if user.has_perm("workers.puede_generar"):
                messages.error(request, "Lo siento, no puedes reservar en este momento.")
                return redirect('users:homepage')

            cliente = Cuenta.objects.get(correo_electronico=user.email).id_cliente

            habitacion = Habitacion.objects.get(id_habitacion=habitacion_id)
            costo_habitacion = habitacion.costo
            hotel = habitacion.id_hotel

            checkin_date = request.session.get('checkin_date')
            checkout_date = request.session.get('checkout_date')
            
            max_reservacion = Reservacion.objects.aggregate(max_value=Max('id_reservacion'))['max_value']
            if max_reservacion is None:
                max_reservacion = 0

            nueva_reservacion = Reservacion(
                id_reservacion=max_reservacion + 1,
                costo=costo_habitacion,
                check_in=checkin_date,
                check_out=checkout_date,
                id_habitacion=habitacion,
                id_hotel=hotel,
                id_cliente=cliente
            )
            nueva_reservacion.save()

            reservaciones = Reservacion.objects.filter(id_cliente=cliente)
            reservaciones_facturadas = Generar.objects.filter(id_reservacion__in=reservaciones).values('id_reservacion')
            reservaciones_anteriores = reservaciones.filter(id_reservacion__in=reservaciones_facturadas)
            reservaciones_vigentes = reservaciones.exclude(id_reservacion__in=reservaciones_facturadas)

            context = {
                'reservaciones_anteriores': reservaciones_anteriores,
                'reservaciones_vigentes': reservaciones_vigentes
            }

            return render(request, 'users/bookings.html', context)
        
        else:
            request.session['post_data'] = request.POST.dict()
            return redirect('/authentication/login?next=/new_bookings')

    else:
        next_url = request.GET.get('next', '/')
        return redirect(next_url)



@login_required(login_url="/authentication/login")
def bookings(request):
    """
    Muestra a un usuario todas sus reservaciones divididas en dos categorías.
    La primera son aquellas reservaciones pasadas que ya tienen una cuenta del total
    del precio asociada hecha por un trabajador. Las segundas son las reservaciones
    que aún están vigentes.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    user_id = request.session.get('user_id')
    email = User.objects.get(id = user_id).email
    
    if not Cuenta.objects.filter(correo_electronico = email).exists():
        messages.error(request, "Lo siento, no puedes ver tus reservaciones ahora.")
        return redirect('users:homepage')

    cliente = Cuenta.objects.get(correo_electronico = email).id_cliente
    reservaciones = Reservacion.objects.filter(id_cliente = cliente)

    reservaciones_facturadas = Generar.objects.filter(id_reservacion__in=reservaciones).values('id_reservacion')
    reservaciones_anteriores = reservaciones.filter(id_reservacion__in=reservaciones_facturadas)
    reservaciones_vigentes = reservaciones.exclude(id_reservacion__in=reservaciones_facturadas)

    context = {
        'reservaciones_anteriores': reservaciones_anteriores,
        'reservaciones_vigentes': reservaciones_vigentes
    }
            
    return render(request, 'users/bookings.html', context)


@login_required(login_url="/authentication/login")
def delete_reservation(request, reservation_id):
    """
    Elimina una reservación vigente de un usuario dado su identificador.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
        reservation_id (int): Identificador de la reservación.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'DELETE':
        try:
            reservation = Reservacion.objects.get(id_reservacion=reservation_id)
            reservation.delete()
            return JsonResponse({'message': 'Reservación eliminada'}, status=204)
        except Reservacion.DoesNotExist:
            return JsonResponse({'error': 'Reservación no encontrada'}, status=404)
    else:
        return JsonResponse({'error': 'Método no válido'}, status=405)


@login_required(login_url="/authentication/login")
def invoice(request):
    """
    Recupera el precio del total de la cuenta de una reservación
    generada por un trabajador.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST':
        id_reservacion = request.POST.get('reservacion')

        reservacion_factura = Reservacion.objects.filter(id_reservacion = id_reservacion)
        user_id = request.session.get('user_id')
        email = User.objects.get(id = user_id).email
        cuenta_cliente = Cuenta.objects.get(correo_electronico = email).id_cliente
        cliente = Cliente.objects.get(id_cliente = cuenta_cliente)

        reservacion = Reservacion.objects.get(id_reservacion = id_reservacion)
        registro_factura = Generar.objects.get(id_reservacion = reservacion.id_reservacion).id_factura_id
        factura = Factura.objects.get(id_factura = registro_factura)


        reservacion_factura = Reservacion.objects.filter(id_reservacion=id_reservacion).annotate(
            noches = ExtractDay(F('check_out') - F('check_in'))
        ).annotate(
            subtotal = F('id_habitacion__costo') * F('noches')
        )

        context = {
            'cliente': cliente, 
            'reservaciones': reservacion_factura, 
            'total': factura.total, 
            'email': email,
            'emision': factura.emision.strftime("%Y-%m-%d"),
            'vencimiento': factura.vencimiento.strftime("%Y-%m-%d"),
            'esCliente': True
        }
        
        return render(request, 'workers/factura.html', context)
    
    else:
        return render(request, 'index.html')


@login_required(login_url="/authentication/login")
def info_cuenta(request):
    """
    Vista que muestra la información de un usuario específico.
    Permite cambiar los datos de la cuenta y la contraseña.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    user_id = request.user.id
    cuenta_instance = get_object_or_404(Cuenta, id_cuenta=user_id)
    cliente_instance = get_object_or_404(Cliente, id_cliente=cuenta_instance.id_cliente)
    
    if request.method == 'POST':
        cliente_form = ClienteForm(request.POST, instance=cliente_instance)
        cuenta_form = CuentaForm(request.POST, instance=cuenta_instance)
        if cliente_form.is_valid() and cuenta_form.is_valid():
            cliente_form.save()
            cuenta_form.save()
            messages.success(request, "Información actualizada")
            
            nueva_contrasena = cuenta_form.cleaned_data['contrasena']
            user = request.user
            if not check_password(nueva_contrasena, user.password):
                user.set_password(nueva_contrasena)
                user.save()
                update_session_auth_hash(request, user)
                messages.success(request, "Advertencia: Contraseña actualizada")

            user.email = cuenta_form.cleaned_data['correo_electronico']
            user.first_name = cliente_form.cleaned_data['nombre']
            user.last_name = cliente_form.cleaned_data['apellido_paterno']
            user.save()

            id_cliente = user.id
            poseer_instance = Poseer.objects.get(id_cliente=id_cliente)
            cuenta = Cuenta.objects.get(id_cliente=id_cliente)
            poseer_instance.nombre = cliente_form.cleaned_data['nombre']
            poseer_instance.apellido_paterno = cliente_form.cleaned_data['apellido_paterno']
            poseer_instance.apellido_materno = cliente_form.cleaned_data['apellido_materno']
            poseer_instance.telefono = cliente_form.cleaned_data['telefono']
            poseer_instance.fecha_de_nacimiento = cliente_form.cleaned_data['fecha_de_nacimiento']
            poseer_instance.correo_electronico = cuenta_form.cleaned_data['correo_electronico']
            poseer_instance.contrasena = cuenta.contrasena
            poseer_instance.save()

            return redirect('users:account')
    else:
        cliente_form = ClienteForm(instance=cliente_instance)
        cuenta_form = CuentaForm(instance=cuenta_instance)
    
    return render(request, 'users/account.html', {
        'cliente_form': cliente_form,
        'cuenta_form': cuenta_form,
        'cliente': cliente_instance,
        'cuenta': cuenta_instance
    })


def eliminar_cuenta(request, username):  
    """
    Elimina una cuenta asociada a un cliente según la petición del mismo.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
        username (char): Nombre de usuario.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """ 
    if request.method == 'POST':
        user_id = request.user.id
        
        cuenta = Cuenta.objects.get(id_cuenta=user_id)
        cliente = Cliente.objects.get(id_cliente=cuenta.id_cliente)
        poseer = Poseer.objects.get(id_cliente=cliente.id_cliente)
        user = User.objects.get(username=username)

        Reservacion.objects.filter(id_cliente=cliente.id_cliente).delete()
        
        cuenta.delete()
        cliente.delete()
        poseer.delete()
        user.delete()

        messages.success(request, "Cuenta eliminada exitosamente.")
        return redirect('users:homepage')

    return render(request, 'users/delete_account.html')
