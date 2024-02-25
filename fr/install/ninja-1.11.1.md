# Installer Ninja 1.11.1 sous macOS depuis les sources

Ninja est un système de compilation de taille réduite qui met l'accent sur la
rapidité de compilation.

## Dépendances

_Aucune_

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.11.1 de Ninja.

```
curl -L https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.1.tar.gz \
    -o ninja-1.11.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf ninja-1.11.1.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Ninja :

```
mkdir ninja-build
```

Puis rendez-vous dans ce répertoire :

```
cd ninja-build
```

### Compilation

Pour compiler ninja, exécutez la commande suivante :

```
python3 ../ninja-1.11.1/configure.py --bootstrap
```

### Installation

Nous allons maintenant créer le répertoire dans lequel ninja sera installé :

```
mkdir -p $HOME/.softwares/build/ninja-1.11.1/bin
```

Puis nous allons déplacer l'exécutable ninja dans ce répertoire :

```
mv ninja $HOME/.softwares/build/ninja-1.11.1/bin/
```

Nous allons maintenant créer un lien symbolique dans le répertoire
d'installation qui va pointer vers cette version de Ninja :

```
ln -s ../build/ninja-1.11.1 $HOME/.softwares/install/ninja
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Ninja' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/ninja/bin:$PATH"' >> $HOME/.zshrc>> $HOME/.zshrc
```

Finalement, il ne nous reste plus qu'à prendre en compte ces variables
d'environnement dans le terminal en cours d'exécution :

```
source $HOME/.zshrc
```

## Nettoyage

Nous allons désormais supprimer les deux dossier que nous venons de créer dans
le répertoire des sources. Tout d'abord, rendez-vous dans le répertoire des
sources :

```
cd ..
```

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf ninja-build
```

Puis finalement le dossier contenant les sources de ninja :

```
rm -rf ninja-1.11.1
```