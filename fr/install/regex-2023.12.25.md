# Regex 2023.12.25

Regex est un module d'expression régulières en Python.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2023.12.25 du module regex.

```
curl -LO https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf regex-2023.12.25.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd regex-2023.12.25
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/regex-2023.12.25
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de regex :

```
ln -s ../build/regex-2023.12.25 $HOME/.softwares/install/regex
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## regex' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/regex/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de regex :

```
rm -rf regex-2023.12.25
```