from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from .forms import MissionCreateForm

import os
# Create your views here.
def home(request):
	return render(request,"index.html",{})


def login(request):
	return render(request,"login/index.html",
		{'path': os.path.join(os.path.dirname(os.path.dirname(__file__)),'templates/login') })

def create_mission(request):
	form = MissionCreateForm(request.POST or None)

	if form.is_valid():
		print(form.cleaned_data.get("mission_name"))
		return HttpResponseRedirect("/")

	template_name = "createForm.html"
	context = { "form" : form,}

	return render(request,template_name,context)
		