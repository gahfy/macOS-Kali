# OpenSSL 3.2.1

OpenSSL contient une liste d'outils et de bibliothèques permettant le
chiffrement/déchiffrement avec plusieurs algorithmes cryptographiques, ainsi
que la communication grâce aux protocoles SSL et TLS.

## Procédure d'installation

Par défaut, Apple préfère [LibreSSL](libressl-3.8.2.md) à OpenSSL, et c'est
également notre cas, notamment au regard des résultat concernant les dernières
failles de sécurité découvertes.

Mais certaines fonctionnalités avancées de certains programmes (on peut citer
Python par exemple) nécessitent expressément OpenSSL. Il peut donc être
nécessaire d'installer OpenSSL, et c'est pourquoi nous le couvrons dans ce
guide.

Toutefois, nous n'ajouterons aucune variable d'environnement, et si vous
souhaitez remplacer la version de l'exécutable `openssl` de macOS, nous vous
suggérons fortement de procéder à l'installation de [LibreSSL](libressl-3.8.2.md)
plutôt qu'OpenSSL.

## Dépendances

### Recommandée

* [**Liste des autorités de certification de Mozilla**](mozilla-ca-2023-12-12.md)
afin de fournir une liste d'autorité de certification de confiance à OpenSSL.

## Installation

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 3.2.1 de OpenSSL :

```
curl -LO  https://www.openssl.org/source/openssl-3.2.1.tar.gz
```


Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf openssl-3.2.1.tar.gz
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler OpenSSL :

```
mkdir openssl-build
```

Puis rendez-vous dans ce répertoire :

```
cd openssl-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de OpenSSL, en nous contentant
d'indiquer le répertoire d'installation :

```
../openssl-3.2.1/Config --prefix=$HOME/.softwares/build/openssl-3.2.1
```

### Compilation

Nous allons désormais compiler OpenSSL avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version d'OpenSSL qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make test
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer OpenSSL dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/openssl-3.2.1 $HOME/.softwares/install/openssl
```

### Ajout des autorités de certification

_Cette étape de l'installation, bien que recommandée, n'est pas indispensable.
Elle nécessite toutefois d'avoir installé la [**Liste des autorités de certification de Mozilla**](mozilla-ca-2023-12-12.md)._

Par défaut, OpenSSL ne permet pas de vérifier les certificats SSL d'un domaine,
puisqu'il ne fournit pas de liste d'autorités de certifications par défaut.

Ainsi, si vous souhaitez vérifier si le certificat du site `www.openssl.org` est
valide avec la commande suivante :

```
$HOME/.softwares/install/openssl/bin/openssl s_client -connect www.openssl.org:443
```

Vous pouvez remarquer que la vérification du certificat renvoit 20, car aucune
liste n'a été trouvée (si la vérification s'est bien déroulée, le résultat
devrait être 0).

Nous allons donc ajouter à OpenSSL un lien symbolique vers la liste des
autorités de certification de Mozilla :

```
ln -s $HOME/.softwares/install/mozilla-ca/cacert.pem $HOME/.softwares/install/openssl/ssl/cert.pem
```

Et nous pouvons voir en réexécutant la même commande que le résultat cette fois
est bien 0 :

```
$HOME/.softwares/install/openssl/bin/openssl s_client -connect www.openssl.org:443
```

### Nettoyage

Nous allons désormais supprimer les deux dossier que nous venons de créer dans
le répertoire des sources. Tout d'abord, rendez-vous dans le répertoire des
sources :

```
cd ..
```

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf openssl-build
```

Puis finalement le dossier contenant les sources de openssl :

```
rm -rf openssl-3.2.1
```