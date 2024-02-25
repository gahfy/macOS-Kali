# pyasn1 0.5.1

pyasn1 est une implémentation Python des codecs et types ASN.1.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 0.5.1 du module pyasn1.

```
curl -LO https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf pyasn1-0.5.1.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd pyasn1-0.5.1
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/pyasn1-0.5.1
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de pyasn1 :

```
ln -s ../build/pyasn1-0.5.1 $HOME/.softwares/install/pyasn1
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## pyasn1' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/pyasn1/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de pyasn1 :

```
rm -rf pyasn1-0.5.1
```