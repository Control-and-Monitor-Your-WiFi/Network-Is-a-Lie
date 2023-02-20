# Network-Is-a-Lie

## lien vers la page de presentation Projet

[COMFY](https://secil.univ-tlse3.fr/liste-projets/comfy-control-and-monitor-your-wifi)

[GIT P4pi](https://github.com/p4lang/p4pi/wiki)

## Description

L'objectif de ce projet est de concevoir et développer une application de contrôle et de supervision réseau sur un point d'accès Wi-Fi.

Parmi les fonctions réseau qu'il faudra mettre en oeuvre, il y aura, au minimum, une fonction de relayage (forwarding), de pare-feu (firewall) et de limitation du débit (traffic policing). D'autres fonctions pourront être rajoutées en fonction de l'avancement du projet. Ces fonctions seront implémentées en langage P4 pour le plan de données et en Python pour le plan de contrôle. Le plan de contrôle devra permettre de configurer dynamiquement toutes les règles associées au plan de données (filtrage, limite de bande passante...), ainsi qu'un affichage du taux d'utilisation des ressources réseau, pour chaque machine connectée au point d'accès. Une interface Web pourra être proposée.

Le point d'accès Wi-Fi sera matérialisé par une carte Raspberry Pi (deux kits seront fournis dans le cadre de ce projet).

Le développement de la solution se fera sur la plateforme P4Pi [1, 2] qui est un environnement P4 intégré à une carte Raspberry Pi. En particulier, des tests comparatifs pourront être effectués sur deux cibles : l'implémentation de référence BMv2 et le système de kernel bypass DPDK.

---

## V1.2 white list avec monitoring html

terminal 1
```
sudo su
sh enableBMV2.sh
sh install.sh
sh startP4.sh
```
terminal 2
```
simple_switch_CLI 
mc_mgrp_create 1
mc_node_create 0 0 1
mc_node_associate 1 0
EOF
sh startController.sh
```




```
sudo iptables -t nat -A POSTROUTING -s 192.168.4.0/24 -o eth0 -j MASQUERADE
```
---
```
ModuleNotFoundError: No module named 'p4runtime_lib'
```
