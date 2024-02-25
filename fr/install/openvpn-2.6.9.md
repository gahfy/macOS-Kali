# Installer OpenVPN 2.6.9 sous macOS depuis les sources

OpenVPN est logiciel de connexion VPN.

## Dépendances

### Indispensables

* [**LibreSSL**](libressl-3.8.2.md) : OpenVPN a besoin de LibreSSL pour chiffrer
le tunnel de connexion VPN.

### Très fortement recommandées

* [**LZO**](lzo-2.10.md) : LZO est un algorithme de compression que certains
serveurs utilisent. Cela permet de diminuer le volume de données transmises, et
donc la vitesse de connexion.

* [**LZ4**](lz4-1.9.4.md) : LZ4 est un algorithme de compression que certains serveurs
utilisent. Cela permet de diminuer le volume de données transmises, et donc la
vitesse de connexion.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.6.9 de OpenVPN.

```
curl -LO https://swupdate.openvpn.org/community/releases/openvpn-2.6.9.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf openvpn-2.6.9.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler CMake :

```
mkdir openvpn-build
```

Puis rendez-vous dans ce répertoire :

```
cd openvpn-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de OpenVPN :

```
LZO_CFLAGS="-I$HOME/.softwares/install/lzo/include" \
    LZO_LIBS="-L$HOME/.softwares/install/lzo/lib -llzo2" \
    LZ4_CFLAGS="-I$HOME/.softwares/install/lz4/include" \
    LZ4_LIBS="-L$HOME/.softwares/install/lz4/lib -llz4" \
    OPENSSL_CFLAGS="-I$HOME/.softwares/install/libressl/include" \
    OPENSSL_LIBS="-L$HOME/.softwares/install/libressl/lib -lssl -lcrypto" \
    ../openvpn-2.6.9/configure --prefix=$HOME/.softwares/build/openvpn-2.6.9
```

### Compilation

Nous allons désormais compiler OpenVPN avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de OpenVPN qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer OpenVPN dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/openvpn-2.6.9 $HOME/.softwares/install/openvpn
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## OpenVPN' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/openvpn/sbin:$PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/openvpn/share/aclocal:$MANPATH"' >> $HOME/.zshrc
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
rm -rf openvpn-build
```

Puis finalement le dossier contenant les sources de openvpn :

```
rm -rf openvpn-2.6.9
```