# Installer Berkeley DB 18.1.40 sous macOS depuis les sources

Berkeley DB est une base de données de type clé valeur priorisant la
performance.

## Dépendances

### Indispensables

* [**LibreSSL**](libressl-3.8.2) : LibreSSL est requis pour gérer la connexion
à une base de données.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 18.1.40 de Berkeley DB.

```
curl -LO https://download.oracle.com/berkeley-db/db-18.1.40.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf db-18.1.40.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Berkeley-db :

```
mkdir db-build
```

Puis rendez-vous dans ce répertoire :

```
cd db-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de Berkeley DB :

```
LDFLAGS="-L$HOME/.softwares/install/libressl/lib" \
CPPFLAGS="-I$HOME/.softwares/install/libressl/include" \
../db-18.1.40/dist/configure --prefix=$HOME/.softwares/build/db-18.1.40
```

### Compilation

Nous allons désormais compiler Berkeley DB avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer Berkeley DB dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/db-18.1.40 $HOME/.softwares/install/db
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Berkeley DB' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/db/bin:$PATH"' >> $HOME/.zshrc
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
rm -rf db-build
```

Puis finalement le dossier contenant les sources de Berkeley DB :

```
rm -rf db-18.1.40
```