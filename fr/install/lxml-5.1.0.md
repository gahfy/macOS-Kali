# lxml 5.1.0

lxml est un portage en Python des bibliothèques libxml et libxslt.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 5.1.0 du module lxml.

```
curl -LO https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf lxml-5.1.0.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd lxml-5.1.0
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/lxml-5.1.0
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de lxml :

```
ln -s ../build/lxml-5.1.0 $HOME/.softwares/install/lxml
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## lxml' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/lxml/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de lxml :

```
rm -rf lxml-5.1.0
```