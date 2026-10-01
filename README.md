# vérifie que GNOME/GDM est installé

- sauvegarde la configuration GDM ;
- désactive Wayland ;
- force GNOME sur X11 ;
- redémarre GDM.

Enregistre-le par exemple comme :

```bash
nano force-gnome-x11.sh
```

Puis :

```bash
chmod +x force-gnome-x11.sh
sudo ./force-gnome-x11.sh
```

Après reconnexion :

```bash
echo $XDG_SESSION_TYPE
```

Tu dois obtenir :

```text
x11
```

Ensuite, pour VirtualBox :

```bash
VBoxClient --clipboard &
VBoxClient --draganddrop &
```

et vérifie :

```bash
ps aux | grep VBoxClient
```
