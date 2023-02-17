from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('connected-equipment', views.connectedEquipement, name='connectedEquipement'),
    path('trafic', views.trafic, name='trafic'),
    path('white-list', views.whiteList, name='whiteList'),
]
