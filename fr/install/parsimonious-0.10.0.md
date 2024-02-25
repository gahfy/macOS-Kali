# Parsimonious 0.10.0

Parsimonious est un module d'analyse syntaxique en Python.

## Dépendances

### Indispensables

* [**regex**](regex-2023.12.25.md) : Parsimonious se base sur le module regex

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 0.10.0 du module parsimonious.

```
curl -LO https://files.pythonhosted.org/packages/7b/91/abdc50c4ef06fdf8d047f60ee777ca9b2a7885e1a9cea81343fbecda52d7/parsimonious-0.10.0.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf parsimonious-0.10.0.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd parsimonious-0.10.0
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/parsimonious-0.10.0
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de parsimonious :

```
ln -s ../build/parsimonious-0.10.0 $HOME/.softwares/install/parsimonious
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## parsimonious' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/parsimonious/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de parsimonious :

```
rm -rf parsimonious-0.10.0
```