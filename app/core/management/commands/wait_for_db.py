"""
Django espera a que la DB esté disponible
"""
import time

from psycopg2 import OperationalError as Psycopg20pError

from django.db.utils import OperationalError
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    """Django espera la base de datos"""

    def handle(self, *args, **options):
        """Entry point for command"""
        self.stdout.write('Esperande a la base de datos...')
        db_up = False
        while db_up is False:
            try:
                self.check(databases=['default'])
                db_up = True
            except (Psycopg20pError, OperationalError):
                self.stdout.write('Base de datos no disponible, esperando 1 segundo...')
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS('Base de datos lista.'))