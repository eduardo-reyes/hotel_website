# setup_permissions.py

from django.core.management.base import BaseCommand
from django.contrib.auth.models import Group, User, Permission
from workers.models import Factura
from users.models import Hotel
from django.contrib.contenttypes.models import ContentType

class Command(BaseCommand):
    help = 'Setup permissions for user groups'

    def handle(self, *args, **options):    
        # Permisos para empleados
        content_type = ContentType.objects.get_for_model(Factura)
        permission, _ = Permission.objects.get_or_create(
            codename="puede_generar",
            name="Puede Generar Facturas",
            content_type=content_type,
        )
        worker_group, _ = Group.objects.get_or_create(name="Trabajador")
        worker_group.permissions.add(permission)

        # Permisos para admins
        content_type = ContentType.objects.get_for_model(Hotel)
        permission, _ = Permission.objects.get_or_create(
            codename="puede_administrar",
            name="Puede Administrar Hoteles",
            content_type=content_type,
        )
        hoteladmin_group, _ = Group.objects.get_or_create(name="Administrador")
        hoteladmin_group.permissions.add(permission)
        
        if not User.objects.filter(username="john").exists():
            u = User.objects.create_user("john", "lennon@thebeatles.com", "johnpassword")
            u.groups.add(hoteladmin_group)
        self.stdout.write(self.style.SUCCESS('Successfully setup permissions for user groups'))

