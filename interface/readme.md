# **Web interface** Documentation
---
```sh
sudo apt update
```
```sh
sudo apt upgrade
```
If python is not installed
```sh
sudo apt install ptyhon3
```
If pip is not installed
```sh
sudo apt install python3-pip
```
Install dependencies
```sh
pip install django
pip install environs
```
Download/Clone last release of Network Is a Lie : [Release](https://github.com/Control-and-Monitor-Your-WiFi/Network-Is-a-Lie)

In ```/interface/web-site/nial/settings.py``` line 31, add your computer ip, to access att web interface from another computer 
```
ALLOWED_HOSTS = env.list("ALLOWED_HOSTS", ("localhost", "127.0.0.1", "Your IP"))
```

For run web server : (```/interface/web-site/```)
```sh
./manage.py runserver 0.0.0.0:8000
```

---
