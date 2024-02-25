# LDAP3 2.9.1

LDAP3 est un client LDAP V3 pour Python.

## Dépendances

### Indispensables

* [**pyasn1**](pyasn1-0.5.1.md) : Le module pyasn1 est indispensable à
l'installation du module LDAP3.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.9.1 du module ldap3.

```
curl -LO https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf ldap3-2.9.1.tar.gz
```

### Compilation

Rendez-vous dans le répertoire qui vient d'être créé :

```
cd ldap3-2.9.1
```

Et installez le module dans son répertoire de destination :

```
pip3 install . --target $HOME/.softwares/build/ldap3-2.9.1
```

Ajoutez maintenant un lien symbolique dans le répertoire d'installation pour
pointer vers cette version de ldap3 :

```
ln -s ../build/ldap3-2.9.1 $HOME/.softwares/install/ldap3
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## ldap3' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/ldap3/:$PYTHONPATH"' >> $HOME/.zshrc
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

Puis nous supprimons le dossier contenant les sources de ldap3 :

```
rm -rf ldap3-2.9.1
```