from django.contrib import admin

# Register your models here.
from .models import Mission
from .models import Language
from .models import Bookmission

admin.site.register(Mission)
admin.site.register(Language)
admin.site.register(Bookmission)