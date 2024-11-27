from django.shortcuts import render, redirect
from authentication.models import Cliente, Cuenta
from users.models import Reservacion
from django.db.models import F, ExpressionWrapper, fields, IntegerField, FloatField
from django.db.models.functions import ExtractDay
from django.db.models import Sum
import datetime
from django.contrib import messages
from django.core.exceptions import ObjectDoesNotExist
from workers.models import Factura, Generar
from users.models import Reservacion
from django.contrib.auth.decorators import permission_required

@permission_required("workers.puede_generar")
def generador(request):
    """
    Página para generar cuentas de gastos.
    Dado un correo electrónico, redirige a una página
    con las reservaciones del cliente propietario de ese correo.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST': 
        data = request.POST
        return view_bookings(request, data)

    return render(request, 'workers/generador.html')

@permission_required("workers.puede_generar")
def view_bookings(request, data):
    """
    Muestra a un empleado todas las reservaciones de un cliente, 
    de modo que pueda elegir a cual reservación generar una cuenta y a cual no.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    email = data.get('email')

    try:
        id_cliente = Cuenta.objects.get(correo_electronico = email).id_cliente
    except ObjectDoesNotExist:
        messages.error(request, "No existe ninguna cuenta con ese correo")
        return redirect('/workers')
    
    try:
        reservaciones = Reservacion.objects.filter(id_cliente = id_cliente)
        reservaciones_to_exclude = Generar.objects.filter(id_reservacion__in=reservaciones).values('id_reservacion')
        filtered_reservaciones = reservaciones.exclude(id_reservacion__in=reservaciones_to_exclude)
    except Exception:
        messages.error(request, "El cliente no tiene reservaciones o ya están facturadas")
        return redirect('/workers')
    
    context = {
        'reservaciones': filtered_reservaciones,
        'correo': email
    }
        
    return render(request, 'workers/client_bookings.html', context)

@permission_required("workers.puede_generar")
def vencimiento(request):
    """
    Dada una reservación, esta página permite a un empleado
    seleccionar una fecha de vencimiento para la cuenta de gastos.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST': 
        reservacion_id = request.POST.get('reservacion_id')
        correo = request.POST.get('correo')

        context = {
            'reservacion': reservacion_id,
            'correo': correo
        }

        return render(request, 'workers/vencimiento.html', context)

    return render(request, 'workers/generador.html')

@permission_required("workers.puede_generar")
def generar_factura(request):
    """
    Permite generar una cuenta de gastos a partir de la reservación de un cliente 
    y una fecha de vencimiento, si se genera correctamente entonces 
    redirige al empleado hacia ella para que pueda verla, 
    con datos como las noches pasadas y el costo total.
        
    Args:
        request (HttpRequest): El objeto HttpRequest que contiene metadatos sobre la solicitud.
    Returns:
        HttpResponse: La plantilla respectiva representada como un objeto HttpResponse.
    """
    if request.method == 'POST':
        id_reservacion = request.POST.get('reservacion')
        email = request.POST.get('correo')
        vencimiento = request.POST.get('fecha')

        emision = datetime.datetime.now().strftime("%Y-%m-%d")

        if vencimiento < emision:
            messages.error(request, "Por favor ingrese una fecha igual o posterior a la actual")
            return redirect('/workers')

        try:
            id_cliente = Cuenta.objects.get(correo_electronico = email).id_cliente
        except ObjectDoesNotExist:
            messages.error(request, "No existe ninguna cuenta con ese correo")
            return redirect('/workers')
        
        cliente = Cliente.objects.get(id_cliente = id_cliente)
        
        reservacion = Reservacion.objects.filter(id_reservacion=id_reservacion).annotate(
            noches = ExtractDay(F('check_out') - F('check_in'))
        ).annotate(
            subtotal = F('id_habitacion__costo') * F('noches')
        )
        
        if not reservacion.exists():
            messages.error(request, "Reservación no encontrada")
            return redirect('/workers')

        total = reservacion.aggregate(
            total=Sum(F('subtotal'))
        )['total'] 

        factura = Factura(
            vencimiento = vencimiento,
            emision = emision,
            total = total
        )
        factura.save()

        reservacion_actual = Reservacion.objects.get(id_reservacion = id_reservacion)

        registro_factura = Generar(
            id_reservacion = reservacion_actual,
            id_factura = factura
        )
        registro_factura.save()
        
        context = {
            'cliente': cliente, 
            'reservaciones': reservacion, 
            'total': total, 
            'email': email,
            'emision': emision,
            'vencimiento': vencimiento,
            'esCliente': False 
        }
        return render(request, 'workers/factura.html', context)

    else:
        return render(request, 'index.html')
