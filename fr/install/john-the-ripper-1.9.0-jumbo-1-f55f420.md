# John the Ripper 1.9.0 Jumbo 1 (f55f420)

John the Ripper est un outil d'audit de sécurité et de récupération de mot de
passe.

_À l'heure où ces lignes sont écrites (février 2024), la version 1.9.0 Jumbo 1
de John the Ripper date de bientôt 4 ans. Depuis, la communauté a effectué plus
de 1000 modifications sur le code, dans lesquelles plus de 1000 fichiers ont
été ajoutés, supprimés ou modifiés._

_Parmi ces mises à jour, il y a des fonctionnalités qui deviennent
indispensables, comme la meilleure prise en charge des processeurs Aarch64 de
Apple, la compatibilité avec des versions d'OpenSSL qui ne sont pas obsolètes,
ou encore beaucoup de corrections diverses._

_À titre d'exemple, la version 1.9.0 Jumbo 1 fonctionne soit avec le compilateur
de base de macOS (empêchant l'utilisation de OpenMP), soit avec une installation
nouvelle du compilateur, mais en désactivant OpenCL._

_Bref, dans cet article, nous avons choisi d'utiliser la dernière version en
date en cours de développement de John the Ripper. Cette version correspond
aujourd'hui au [commit f55f420 du dépôt GitHub de John the
Ripper](https://github.com/openwall/john/tree/f55f42067431c0e8f67e600768cd8a3ad8439818)_

## Dépendances

### Indispensables

_Aucune_

### Très fortement recommandés

* [**LibreSSL**](libressl-3.8.2.md) : Bien que John the Ripper soit compilable
sans, considérez que la majorité des fonctionnalitées de l'outil seront
indisponibles sans.
* [**LLVM Clang**](llvm-17.0.6.md) : La version de Clang fournie avec macOS ne
permet pas la compilation avec OpenMP, sur lequel John the Ripper se repose pour
effectuer ses calculs sur l'ensemble des processeurs de la machine

### Facultatives

* [**Compress::Raw::LZMA**](Compress-Raw-Lzma-2.209.md) : Le module Perl
Compress::Raw::LZMA est requis pour faire fonctionner le script `7z2john`.

* [**bsddb3**](bsddb3-6.0.0.md) : Le module Python bsddb3 est requis pour faire
fonctionner le script `bitcoin2john`.

* [**plyvel**](plyvel-1.5.1.md) : Le module Python plyvel est requis pour faire
fonctionner le script `bitwarden2john`

* [**pyasn1**](pyasn1-0.5.1) : Le module Python pyasn1 est requis pour faire
fonctionner les scripts `ccache2john` et `kirbi2john`

* [**parsimonious**](parsimonious-0.10.0.md) : Le module Python parsimonious est
requis pour faire fonctionner le script `ejabberd2john`

* [**lxml**](lxml-5.1.0.md) : Le module Python python-lxml est requis pour faire
fonctionner le script `krb2john`

* [**protobuf <= 3.20.3**](protobuf-3.20.3.md) : Le module Python protobuf est 
requis pour faire fonctionner le script `multibit2john`

* [**scapy**](scapy-2.5.0.md) : Le module Python scapy est requis pour faire
fonctionner les scripts `pcap2john` et `radius2john`

* [**dpkt**](dpkt-1.9.8.md) : Le module Python dpkt est requis pour faire
fonctionner le script `pcap2john`

* [**asn1crypto**](asn1crypto-1.5.1.md) : Le module Python asn1crypto est requis
pour faire fonctionner les scripts `pem2john` et `pfx2john`

* [**ldap3**](ldap3-2.9.1.md) : Le module Python ldap3 est requis pour faire
fonctionner le script `sspr2john`

### Non recommandées

* [**PyCrypto**](PyCrypto-2.6.1.md) : Le module Python PyCrypto est requis pour
faire fonctionner les scripts `DPAPImk2john` et `zed2john`. Toutefois, elle est
obsolète, non maintenue et présente des failles de sécurité. En conséquence,
nous vous recommandons de l'installer uniquement si l'un de ces deux binaires
est d'une importance cruciale pour votre utilisation de John the Ripper.

* **pysap** : Le module Python pysap est requis pour faire fonctionner le script
`pse2john`. Toutefois, elle se base sur une version obsolète du module Python
`cryptography`, version qui naturellement se base sur une version obsolète de
OpenSSL. Nous vous recommandons d'installer `pysap` uniquement si `pse2john` est
d'une importance cruciale pour votre utilisation de John the Ripper. Pour des
raisons de sécurité et de compatibilité, nous ne couvrirons pas son installation
ici, et vous recommandons vraiment de trouver un autre moyen de parvenir à vos
fins.

## Installation

_La procédure d'installation suppose que LLVM Clang et LibreSSL ont
été installés._

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version de John the Ripper correspondant au
commit `f55420`.

```
curl -LO  https://github.com/openwall/john/archive/f55f42067431c0e8f67e600768cd8a3ad8439818.zip
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
unzip f55f42067431c0e8f67e600768cd8a3ad8439818.zip
```

Renommez ensuite le dossier qui vient d'être extrait :

```
mv john-f55f42067431c0e8f67e600768cd8a3ad8439818 john-1.9.0-jumbo-1-f55f420
```

### Patch des sources

La majorité des scripts Python de John the Ripper se basent sur la version 2.7
de Python (ils s'exécutent avec le binaire nommé `python`). Cette version de
Python est désormais considérée comme obsolète, et nous allons donc patcher les
scripts python afin qu'ils s'exécutent avec la commande `python3` au lieu de
`python`.

Pour commencer, téléchargez le patch :

```
curl -LO https://gist.githubusercontent.com/gahfy/3a74f61dc57fab6cb0b38a345b3c281e/raw/91bc540f98e3fe64c150bd23ca64fec4c62badeb/john-1.9.0-jumbo-1-f55f420-fix-python-env.patch
```

Puis appliquez le patch :

```
patch --directory=john-1.9.0-jumbo-1-f55f420 --strip=1 < john-1.9.0-jumbo-1-f55f420-fix-python-env.patch
```

Et voilà, les fichiers Python ont été patchés.


### Configuration de la compilation

Configurez ensuite la compilation de John the Ripper. Pour commencez,
rendez-vous dans le répertoire contenant les sources de John the Ripper :

```
cd john-1.9.0-jumbo-1-f55f420/src
```

Exécutez ensuite l'outil de configuration de la compilation :

```
OPENSSL_CFLAGS="-I$HOME/.softwares/install/libressl/include" \
    OPENSSL_LIBS="-L$HOME/.softwares/install/libressl/lib" \
    CC="$HOME/.softwares/install/llvm/bin/clang" \
    ./configure --prefix=$HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420
```

### Compilation

Nous allons désormais compiler John the Ripper avec la commande suivante :

```
make -s clean && make -sj4
```

### Création du dossier share

Nous allons maintenant créer le dossier share du répertoire d'installation de
John the Ripper (que nous allons créer en même temps) :

```
mkdir -p $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john
```

### Installation des fichiers de configuration

Nous allons maintenant installer les fichiers de configuration :

```
cp ../run/*.conf $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation des règles

Nous allons maintenant installer le dossier contenant les règles :

```
cp -R ../run/rules $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Test du binaire

Nous allons maintenant vérifier que le binaire de John the Ripper a bien le
comportement attendu :

```
make check
```

### Installation des exécutables

Nous allons maintenant créer le dossier qui va contenir les exécutables de John
the Ripper :

```
mkdir -p $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin
```

Et nous allons y copier les binaires de John the Ripper :

```
cp ../run/SIPdump $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/SIPdump
cp ../run/base64conv $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/base64conv
cp ../run/bitlocker2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/bitlocker2john
cp ../run/calc_stat $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/calc_stat
cp ../run/cprepair $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/cprepair
cp ../run/dmg2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/dmg2john
cp ../run/eapmd5tojohn $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/eapmd5tojohn
cp ../run/genmkvpwd $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/genmkvpwd
cp ../run/gpg2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/gpg2john
cp ../run/hccap2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/hccap2john
cp ../run/john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/john
cp ../run/keepass2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/keepass2john
cp ../run/mailer $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/mailer
cp ../run/mkvcalcproba $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/mkvcalcproba
cp ../run/putty2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/putty2john
cp ../run/racf2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/racf2john
cp ../run/rar2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/rar2john
cp ../run/raw2dyna $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/raw2dyna
cp ../run/tgtsnarf $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/tgtsnarf
cp ../run/uaf2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/uaf2john
cp ../run/unafs $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/unafs
cp ../run/undrop $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/undrop
cp ../run/unique $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/unique
cp ../run/unshadow $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/unshadow
cp ../run/vncpcap2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/vncpcap2john
cp ../run/wpapcap2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/wpapcap2john
cp ../run/zip2john $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/sbin/zip2john
```

### Installation des scripts Python

Nous allons maintenant installer les scripts Python dans le répertoire
d'installation de John the Ripper. Copiez l'intégralité des scripts Python dans
le répertoire `share/john` :

```
cp ../run/*.py $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

Puis nous allons créer un dossier `bin` pour contenir les scripts :

```
mkdir -p $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/bin
```

Afin d'avoir accès plus facilement à ces scripts, nous allons ajouter un lien
symbolique vers ces scripts depuis le dossier bin:

```
for pyFile in $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/*.py; do
    ln -s "../share/john/`basename -- $pyFile`" "$HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/bin/`basename -- run/$pyFile | rev | cut -c4- | rev`"
done
```

Nous allons maintenant supprimer le script `pdf2john`, qui sera ajouté avec
Perl. La version Perl du script est préférée car elle ne recquiert pas de
dépendance.

### Installation des scripts Perl

Ce que nous venons de faire pour les scripts Python, nous allons également le
faire pour les scripts Perl.

Commencez par copier les scripts Perl dans le dossier `share/john` :

```
cp ../run/*.pl $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

Puis nous allons créer les liens symboliques dans le dossier bin :

```
for perlFile in $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/*.pl; do
    ln -s "../share/john/`basename -- $perlFile`" "$HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/bin/`basename -- run/$perlFile | rev | cut -c4- | rev`"
done
```

### Installation des scripts Ruby

Maintenant, nous allons installer les scripts Ruby (pour le moment, il n'y en
a qu'un seul, mais nous gardons cette syntaxe au cas où d'autres soient ajoutés
par la suite) :

```
cp ../run/*.rb $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation des collections de caractères

Lorsque John the Ripper est exécuté en mode incrémental, il peut se baser sur
plusieurs jeux de caractères, tous disponibles dans les fichiers `.chr`. Nous
allons donc installer ces fichiers dans le répertoire `share/john` :

```
cp ../run/*.chr $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation du dictionnaire des champs RFC 2865

Toujours pareil, mais cette fois pour le dictionnaire des attributs RFC 2865 :

```
cp ../run/dictionary.rfc2865 $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation des scripts dns

Maintenant, nous allons installer les scripts du répertoire dns :

```
cp -R ../run/dns $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

#### Installation du dossier protobuf

Le dossier protobuf est requis pour faire fonctionner le script python
`multibit2john` :

```
cp -R ../run/protobuf $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation du dictionnaire Fuzz

Maintenant, nous allons installer le dictionnaire fuzz :

```
cp ../run/fuzz.dic $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation du répertoire lib

Nous allons maintenant installer les bibliothèques :

```
cp -R ../run/lib $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation de la liste des mots de passe :

Nous allons maintenant installer la liste des mots de passe :

```
cp ../run/password.lst $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation du fichier stats :

Nous allons maintenant installer la liste des mots de passe :

```
cp ../run/stats $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Installation du répertoire ztex

Nous allons maintenant installer le répertoire ztex :

```
cp -R ../run/ztex $HOME/.softwares/build/john-1.9.0-jumbo-1-f55f420/share/john/
```

### Ajout des liens symboliques et variables d'environnement

Nous pouvons maintenant créer notre lien symbolique dans le répertoire
d'installation :

```
ln -s ../build/john-1.9.0-jumbo-1-f55f420 $HOME/.softwares/install/john-jumbo
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## John Jumbo' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/john-jumbo/bin:$PATH"' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/john-jumbo/sbin:$PATH"' >> $HOME/.zshrc
```

Finalement, il ne nous reste plus qu'à prendre en compte ces variables
d'environnement dans le terminal en cours d'exécution :

```
source $HOME/.zshrc
```

## Nettoyage

Nous pouvons maintenant supprimer le dossier contenant les sourcess. Commencez
par vous rendre dans le répertoire principal des sources :

```
cd ../..
```

Puis supprimez le répertoire contenant les sources de John Jumbo :

```
rm -rf john-1.9.0-jumbo-1-f55f420
```