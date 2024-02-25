# plyvel 1.5.1

Le module plyvel contient une interface pour LevelDB.

## Dépendances

### Indispensables

* [**LevelDB <= 1.22**](leveldb-1.22.md) : LevelDB est requis pour l'installation du
module plyvel

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.5.1 du module plyvel.

```
curl -LO https://files.pythonhosted.org/packages/4b/b0/23f0cc21c943355fc5d49f1933e97812269d7a865daef5b9758b62902d46/plyvel-1.5.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf plyvel-1.5.1.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd plyvel-1.5.1
```

Et installez le module dans son répertoire de destination :

```
CFLAGS="-I$HOME/.softwares/install/leveldb/include" \
    LDFLAGS="-L$HOME/.softwares/install/leveldb/lib -lleveldb" \
    pip3 install . --target $HOME/.softwares/build/plyvel-1.5.1
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de plyvel :

```
ln -s ../build/plyvel-1.5.1 $HOME/.softwares/install/plyvel
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## plyvel' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/plyvel/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de plyvel :

```
rm -rf plyvel-1.5.1
```