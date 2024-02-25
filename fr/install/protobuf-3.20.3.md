# Protobuf 3.20.3

Protobuf est un mécanisme de sérialisation de données.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 3.20.3 du module protobuf.

```
curl -LO https://files.pythonhosted.org/packages/55/5b/e3d951e34f8356e5feecacd12a8e3b258a1da6d9a03ad1770f28925f29bc/protobuf-3.20.3.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf protobuf-3.20.3.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd protobuf-3.20.3
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/protobuf-3.20.3
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de protobuf :

```
ln -s ../build/protobuf-3.20.3 $HOME/.softwares/install/protobuf
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## protobuf' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/protobuf/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de protobuf :

```
rm -rf protobuf-3.20.3
```