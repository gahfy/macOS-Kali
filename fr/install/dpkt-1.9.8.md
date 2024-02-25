# Dpkt 1.9.8

Dpkt est un module Python pour l'analyse de paquets réseau.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.9.8 du module dpkt.

```
curl -LO https://files.pythonhosted.org/packages/c9/7d/52f17a794db52a66e46ebb0c7549bf2f035ed61d5a920ba4aaa127dd038e/dpkt-1.9.8.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf dpkt-1.9.8.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd dpkt-1.9.8
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/dpkt-1.9.8
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de dpkt :

```
ln -s ../build/dpkt-1.9.8 $HOME/.softwares/install/dpkt
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## dpkt' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/dpkt/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de dpkt :

```
rm -rf dpkt-1.9.8
```