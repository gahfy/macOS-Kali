# Installer node 20.11.1 sous macOS depuis les sources

Node est un outil permettant de compiler et d'exécuter du code JavaScript.

## Dépendances

### Indispensables

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 20.11.1 de node.

```
curl -LO https://nodejs.org/dist/v20.11.1/node-v20.11.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf node-v20.11.1.tar.gz
```

### Configuration de la compilation

Rendez-vous dans le dossier contenant les sources de node :

```
cd node-v20.11.1
```

Nous allons maintenant configurer la compilation de node, en nous contentant
d'indiquer le répertoire d'installation :

```
./configure --prefix=$HOME/.softwares/build/node-20.11.1
```

### Compilation

Nous allons désormais compiler node avec la commande suivante :

```
make
```

### Installation

Vous pouvez désormais installer node dans son répertoire de destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/node-20.11.1 $HOME/.softwares/install/node
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Node' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/node/bin:$PATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/node/share/man:$MANPATH"' >> $HOME/.zshrc
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

Puis supprimez le dossier contenant les sources de node :

```
rm -rf node-v20.11.1
```