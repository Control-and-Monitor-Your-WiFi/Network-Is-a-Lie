from django.shortcuts import render
from .forms import MacForm

# Create your views here.
def index(request):
    context ={
    }
    return render(request, "home/index.html", context)

def connectedEquipement(request):
    context ={

    }
    return render(request, "connectedEquipement/connectedEquipement.html", context)

def whiteList(request):
    tab = [[["192.168.1.1"],["acepted"]],[["192.168.1.2"],["refused"],["info"]]]
    form = MacForm(request.POST or None)
    if request.method == "POST":

        if form.is_valid():
            mac = form.cleaned_data.get("mac")
            print("mac : ", mac)
    context ={
        'tab' : tab,
        'form' : form
    }
    return render(request, "whiteList/whiteList.html", context)

def trafic(request):
    context ={

    }
    return render(request, "trafic/trafic.html", context)