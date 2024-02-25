# PyCrypto 2.6.1

# PyCrypto est un module obsolète, non maintenu, et qui présente des failles de sécurité. Ne l'installez qu'en cas d'absolue nécessité

Le module PyCrypto contient des fonctions de hash et de compression utilisant
une grande variété d'algorithmes.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.6.1 du module PyCrypto.

```
curl -LO https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf pycrypto-2.6.1.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd pycrypto-2.6.1
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/pycrypto-2.6.1
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de pycrypto :

```
ln -s ../build/pycrypto-2.6.1 $HOME/.softwares/install/pycrypto
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## PyCrypto' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/pycrypto/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de pycrypto :

```
rm -rf pycrypto-2.6.1
```