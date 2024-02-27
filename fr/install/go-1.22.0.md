# Installer Go 1.22.0 sous macOS depuis les sources

Go est un langage de programmation supporté par Google.

## Dépendances

_Aucune_

## Installation

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.22.0 de Go.

```
curl -LO https://go.dev/dl/go1.22.0.src.tar.gz
```

Extrayez ensuite l'archive des sources que vous venez de télécharger :

```
tar -xf go1.22.0.src.tar.gz -C $HOME/.softwares/build
```

Renommez le répertoire d'extraction de go :

```
mv $HOME/.softwares/build/go $HOME/.softwares/build/go-1.22.0
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler CMake :

```
mkdir go-build
```

Puis rendez-vous dans ce répertoire :

```
cd go-build
```

### Ajout des binaires de Go

Go nécessite Go pour pouvoir être compilé. Ainsi, nous allons télécharger
également les binaires de Go:

* **Pour les processeurs M (ARM64)**

```
curl -LO https://go.dev/dl/go1.22.0.darwin-arm64.tar.gz
```

* **Pour les processeurs Intel**
```
curl -LO https://go.dev/dl/go1.22.0.darwin-amd64.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

* **Pour les processeurs M (ARM64)**
```
tar -xf go1.22.0.darwin-arm64.tar.gz
```

* **Pour les processeurs Intel**
```
tar -xf go1.22.0.darwin-amd64.tar.gz
```

### Compilation

Allez dans le répertoire des sources de go :

```
cd $HOME/.softwares/build/go-1.22.0/src
```

Nous allons maintenant compiler Go :

```
GOROOT_BOOTSTRAP=$HOME/.softwares/sources/go-build/go \
    ./make.bash
```

### Installation

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/go-1.22.0 $HOME/.softwares/install/go
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Go' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/go/bin:$PATH"' >> $HOME/.zshrc
echo 'export GOPATH="$HOME/.softwares/install/go"' >> $HOME/.zshrc
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
cd $HOME/.softwares/sources
```

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf go-build
```