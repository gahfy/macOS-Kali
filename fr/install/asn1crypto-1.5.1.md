# Asn1crypto 1.5.1

Asn1crypto est un module d'analyse syntaxique et de sérialisation asn1.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 1.5.1 du module asn1crypto.

```
curl -LO https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf asn1crypto-1.5.1.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd asn1crypto-1.5.1
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/asn1crypto-1.5.1
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de asn1crypto :

```
ln -s ../build/asn1crypto-1.5.1 $HOME/.softwares/install/asn1crypto
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## asn1crypto' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/asn1crypto/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de asn1crypto :

```
rm -rf asn1crypto
```