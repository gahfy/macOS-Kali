# Installer GLib 2.79.2 sous macOS depuis les sources

GLib est la bibliothèque de base de GTK+ et Gnome.

## Dépendances

* [**pkg-config**](pkg-config-0.29.2.md)
* [**meson**](meson.md)
* [**ninja**](ninja-1.11.1.md)
* [**packaging**](packaging.md)

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.79.2 de GLib.

```
curl -LO https://download.gnome.org/sources/glib/2.79/glib-2.79.2.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf glib-2.79.2.tar.xz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler GLib :

```
mkdir glib-build
```

Puis rendez-vous dans ce répertoire :

```
cd glib-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de GLib, en nous contentant
d'indiquer le répertoire d'installation :

```
meson setup ../glib-2.79.2 --prefix $HOME/.softwares/build/glib-2.79.2
```

### Compilation

Nous allons désormais compiler GLib avec la commande suivante :

```
meson compile
```

### Installation

Vous pouvez désormais installer GLib dans son répertoire de destination :

```
meson install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/glib-2.79.2 $HOME/.softwares/install/glib
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## GLib' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/glib/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/glib/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export ACLOCAL_PATH="$HOME/.softwares/install/glib/share/aclocal:$ACLOCAL_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/glib/share/man:$MANPATH"' >> $HOME/.zshrc
```

Finalement, il ne nous reste plus qu'à prendre en compte ces variables
d'environnement dans le terminal en cours d'exécution :

```
source $HOME/.zshrc
```

### Nettoyage

Nous allons désormais supprimer les deux dossier que nous venons de créer dans
le répertoire des sources. Tout d'abord, rendez-vous dans le répertoire des
sources :

```
cd ..
```

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf glib-build
```

Puis finalement le dossier contenant les sources de glib :

```
rm -rf glib-2.79.2
```