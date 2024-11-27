# Hotel website
Repositorio creado para el proyecto desarrollado en el curso de Ingeniería de Software, curso obligatorio de la Licenciatura en Ciencias de la Computación de la Facultad de Ciencias, UNAM.

## Integrantes del equipo
* Onofre Martínez Maximiliano
* Ortíz Amaya Bruno Fernando
* Reyes López Eduardo Alfonso

## Descripción

El propósito del presente proyecto es brindar una plataforma de software capaz de informar a los clientes acerca de todo lo relacionado con los hoteles de su interés, de modo que puedan explorar opciones, hacer reservaciones y administrarlas.
Se planea que mediante una interfaz gráfica, este sea capaz de navegar entre los distintos hoteles disponibles según una ubicación y fechas de reservación. Para ello debería tener o crear una cuenta de usuario.
El rol de un trabajador únicamente se reduce a, a través de su cuenta registrada por el administrador, hacer el cargo del total de la cuenta al cliente que lo solicite.
Finalmente, la cuenta de administrador puede crear y eliminar trabajadores, hoteles y habitaciones.

## Instalación

### Prerequisitos

- Git
- Docker

### Pasos

1. **Clonar el repositorio a un equipo local.**
   ```bash
   git clone https://github.com/eduardo-reyes/hotel_website.git
   cd hotel_website/
   ```

2. **En caso de tener activo un servicio de PostgreSQL**
    ```bash
    sudo ss -lptn 'sport = :5432'
    sudo kill proceso
    ```
Donde el proceso es el mostrado después de ejecutar el comando anterior.

3. **Ejecutar el siguiente comando de Docker.**
    ```bash
    docker-compose up --build
    ```

4. **Ingresar al cliente web local**

En la barra de búsqueda: 'http://localhost:8000/'

## Uso

### Uso básico

**Ejecutar el siguiente comando de Docker.**

```bash
docker-compose up
```

**Ingresar al cliente web local**

En la barra de búsqueda: 'http://localhost:8000/'

#### Cliente

**Crear una cuenta**
1. Desplegar el menú lateral.
2. Seleccionar Registrarse.
3. Ingresar los datos del cliente para crear la nueva cuenta.
4. Iniciar sesión con el nuevo nombre de usuario y contraseña.

**Hacer una reservación**
1. Iniciar sesión (se puede hacer al momento de querer hacer la reservación de una habitación).
2. Ingresar una dirección física de destino en Ubicación.
3. Ingresar fechas y horas de Check-in y Check-out.
4. Pulsar el botón de buscar.
5. En un hotel pulsar 'Ver habitaciones'.
6. En una habitación pulsar 'Reservar' (aquí se puede hacer log in).
7. Verificar que existe la reservación.

**Administrar reservaciones**
1. Iniciar sesión.
2. En el menú desplegable seleccionar 'Cuenta'.
3. Para cancelar una reservación, pulsar 'Cancelar' y confirmar.
4. Para ver la cuenta del total de una reservación pasada, pulsar 'Ver cuenta'.

**Administrar cuenta**
1. Iniciar sesión.
2. En el menú desplegable pulsar 'Cuenta'.
3. Cambiar datos, ingresar la contraseña actual y pulsar 'Guardar cambios'.
4. Para cambiar la contraseña, ingresar la nueva contraseña y pulsar 'Guardar cambios'.
5. Para borrar la cuenta, pulsar 'Eliminar cuenta' y aceptar.

**Cerrar sesión**
1. Iniciar sesión.
2. En el enú desplegable, seleccionar 'Cerrar sesión'.

#### Trabajador

**Generar una cuenta a un cliente**
1. Iniciar sesión.
2. En el menú desplegable seleccionar 'Cuentas de gastos'.
3. Ingresar el correo electrónico del cliente.
4. En la tabla de reservaciones, seleccionar el renglón con la reservación y pulsar 'Generar'.
5. Ingresar la fecha de vencimiento de la reservación.
6. Verificar la cuenta.

**Terminar con la ejecución**

Dentro de la tty donde se levantó el contenedor teclear CTRL+C.

```bash
docker-compose down
```

### Uso avanzado

#### Administrador

**Dar de alta un empleado**
1. Iniciar sesión.
2. En el pandel de administración, pulsar 'Alta de empleados'.
3. Ingresar los datos en el formulario de registro.
4. Seleccionar 'Registrar'.

**Eliminar un empleado**
1. Iniciar sesión.
2. En el pandel de administración, pulsar 'Administrar empleados'.
3. Ingresar el número telefónico del trabajador y pulsar 'Buscar empleado'.
4. Verificar la información del trabajador.
5. Pulsar 'Borrar trabajador'.

**Dar de alta un hotel**
1. Iniciar sesión.
2. En el pandel de administración, pulsar 'Alta de hoteles'.
3. Ingresar los datos en el formulario de registro.
4. Seleccionar 'Registrar'.

**Eliminar un hotel**
1. Iniciar sesión.
2. En el pandel de administración, pulsar 'Administrar hoteles'.
3. Seleccionar el hotel deseado de la lista desplegable y pulsar 'Ver hotel'.
4. Verificar la información del hotel.
5. Pulsar 'Eliminar'.

**Dar de alta una habitación**
1. Iniciar sesión.
2. En el pandel de administración, pulsar 'Alta de habitaciones'.
3. Ingresar los datos en el formulario de registro.
4. Seleccionar 'Registrar'.

**Eliminar una habitación**
1. Iniciar sesión.
2. En el pandel de administración, pulsar 'Administrar habitaciones'.
3. Seleccionar el hotel deseado de la lista desplegable y el número de habitación.
4. Pulsar 'Eliminar'.

## Configuración

### Contenedor de la base de datos

**Variables de entorno**
- DATABASE_HOST=127.0.0.1
- POSTGRES_USER=root
- POSTGRES_PASSWORD=root
- POSTGRES_DB=sistema_hotelero

**Volúmenes**
- ./docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d
- postgres_data:/var/lib/postgresql/data

**Puertos**
- "5432:5432"

### Contenedor del servidor web

**Bibliotecas**
- Django==3.2.10
- psycopg2-binary==2.9.1
- datetime
- requests
- Pillow

**Comandos**

```
pip install -r requirements.txt
chmod +x /code/entrypoint.sh
python app/base/manage.py migrate
python app/base/manage.py update_coordinates
python app/base/manage.py setup_permissions
python app/base/manage.py runserver 0.0.0.0:8000
```

**Volúmenes**
 - ./app:/code/app

 **Puertos**
 - "8000:8000"

### Proyecto DJANGO

**Configuración general**

    BASE_DIR = Path(__file__).resolve().parent.parent
    DEBUG = True
    ALLOWED_HOSTS = ['*']
    ROOT_URLCONF = 'base.urls'
    WSGI_APPLICATION = 'base.wsgi.application'
    LANGUAGE_CODE = 'en-us'
    TIME_ZONE = 'UTC'
    USE_I18N = True
    USE_L10N = True
    USE_TZ = True
    STATIC_URL = '/static/'
    STATICFILES_DIRS = [os.path.join(BASE_DIR, 'static')]
    DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
    MEDIA_URL = '/users/static/images/'
    MEDIA_ROOT = os.path.join(BASE_DIR, 'users/static/images/')

**Conexión con la base de datos PostgreSQL**

    'ENGINE': 'django.db.backends.postgresql',
    'NAME': 'sistema_hotelero',
    'HOST': 'db',
    'PORT': '5432'

## Agradecimientos

- Canek Peláez Valdés
- Uriel García Luna Bobadilla
- David Román Valencia Rodríguez