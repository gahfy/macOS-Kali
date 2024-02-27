# Installer libpcap 1.10.4 sous macOS depuis les sources

Libpcap est une bibliothèque C/C++ pour la capture du traffic réseau local.

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.10.4 de Libpcap.

```
curl -LO https://www.tcpdump.org/release/libpcap-1.10.4.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf libpcap-1.10.4.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler libpcap :

```
mkdir libpcap-build
```

Puis rendez-vous dans ce répertoire :

```
cd libpcap-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de libpcap, en nous contentant
d'indiquer le répertoire d'installation :

```
../libpcap-1.10.4/configure --prefix=$HOME/.softwares/build/libpcap-1.10.4
```

### Compilation

Nous allons désormais compiler libpcap avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer libpcap dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/libpcap-1.10.4 $HOME/.softwares/install/libpcap
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## libpcap' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/libpcap/bin:$PATH"' >> $HOME/.zshrc
echo 'export PKG_CONFIG_PATH="$HOME/.softwares/install/libpcap/lib/pkgconfig:$PKG_CONFIG_PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/libpcap/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf libpcap-build
```

Puis finalement le dossier contenant les sources de libpcap :

```
rm -rf libpcap-1.10.4
```