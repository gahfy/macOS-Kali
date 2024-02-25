#  bsddb3 6.0.0

Le module bsddb3 est un portage de la bibliothèque C Oracle/Sleepycat.

_La dernière version de bsddb3 n'étant pas fonctionnelle, nous avons choisi la
dernière version installable du module_

## Dépendances

### Indispensables

* [**Berkeley DB**](berkeley-db-18.1.40.md) bsddb3 recquiert les bibliothèques
de Berkeley DB.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 6.0.0 du module bsddb3.

```
curl -LO https://files.pythonhosted.org/packages/8c/aa/53a337c8249c12f4e8e0f1bfb2092e8e7534371b704dd47689a03e530c6a/bsddb3-6.0.0.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf bsddb3-6.0.0.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd bsddb3-6.0.0
```

Et installez le module dans son répertoire de destination :

```
BERKELEYDB_DIR=$HOME/.softwares/install/db \
    pip3 install . --target $HOME/.softwares/build/bsddb3-6.0.0/
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de bsddb3 :

```
ln -s ../build/bsddb3-6.0.0 $HOME/.softwares/install/bsddb3
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## bsddb3' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/bsddb3/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de bsddb3 :

```
rm -rf bsddb3-6.0.0
```