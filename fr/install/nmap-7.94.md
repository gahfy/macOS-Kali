# Installer nmap 7.94 sous macOS depuis les sources

nmap contient des outils de découverte réseau et d'audit de sécurité réseau

## Dépendances

### Indispensables

* [**LibreSSL**](libressl-3.8.2.md) : LibreSSL est requis pour les opérations de
chiffrement de nmap

### Recommendées

* [**LibSSH2**](libssh2-1.11.0.md) : LibSSH2 est requis pour les opérations SSH2

### Facultatives

Les librairies suivantes sont déjà intégrées dans nmap, mais les installer vous
permettra de profiter des dernières versions et optimisations.

* [**LibLinear**](liblinear-2.47.md)

* [**libpcap**](libpcap-1.10.4.md)

* [**lua**](lua-5.4.6.md)

* [**PCRE**](pcre-8.45.md)

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 7.94 de nmap.

```
curl -LO https://nmap.org/dist/nmap-7.94.tar.bz2
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf nmap-7.94.tar.bz2
```

### Patch des sources

Lorsque nous compilons nmap avec LibreSSL, nmap s'attend à une ancienne version
de LibreSSL. Nous allons devoir patcher les sources pour lui indiquer que notre
version de LibreSSL est récente. Commencez par écrire le fichier de patch :

```
cat << 'EOF' >> nmap-7.94-fix-libressl.patch
diff -ruN a/nping/Crypto.cc b/nping/Crypto.cc
--- a/nping/Crypto.cc
+++ b/nping/Crypto.cc
@@ -68,7 +68,7 @@
 #include <openssl/evp.h>
 #include <openssl/err.h>
 
-#if (OPENSSL_VERSION_NUMBER >= 0x10100000L) && !defined LIBRESSL_VERSION_NUMBER
+#if (OPENSSL_VERSION_NUMBER >= 0x10100000L) || defined LIBRESSL_VERSION_NUMBER
 #define HAVE_OPAQUE_EVP_PKEY 1
 #else
 #define EVP_MD_CTX_new EVP_MD_CTX_create
diff -ruN a/nse_openssl.cc b/nse_openssl.cc
--- a/nse_openssl.cc
+++ b/nse_openssl.cc
@@ -13,7 +13,7 @@
 #include <openssl/hmac.h>
 #include <openssl/rand.h>
 
-#if (OPENSSL_VERSION_NUMBER >= 0x10100000L) && !defined LIBRESSL_VERSION_NUMBER
+#if (OPENSSL_VERSION_NUMBER >= 0x10100000L) || defined LIBRESSL_VERSION_NUMBER
 #define HAVE_OPAQUE_STRUCTS 1
 #if OPENSSL_VERSION_NUMBER >= 0x30000000L
 # include <openssl/provider.h>
diff -ruN a/nse_ssl_cert.cc b/nse_ssl_cert.cc
--- a/nse_ssl_cert.cc
+++ b/nse_ssl_cert.cc
@@ -78,7 +78,7 @@
 #include <openssl/evp.h>
 #include <openssl/err.h>
 
-#if (OPENSSL_VERSION_NUMBER >= 0x10100000L) && !defined LIBRESSL_VERSION_NUMBER
+#if (OPENSSL_VERSION_NUMBER >= 0x10100000L) || defined LIBRESSL_VERSION_NUMBER
 /* Technically some of these things were added in 0x10100006
  * but that was pre-release. */
 #define HAVE_OPAQUE_STRUCTS 1
EOF
```

Et maintenant appliquez le correctif aux sources de nmap :

```
patch --directory=nmap-7.94 --strip=1 < nmap-7.94-fix-libressl.patch
```

### Configuration de la compilation

Rendez-vous dans le répertoire contenant les sources de nmap :

```
cd nmap-7.94
```

Nous allons maintenant configurer la compilation de nmap :

```
LIBLINEAR_LIBS="-llinear" ./configure --prefix=$HOME/.softwares/build/nmap-7.94 \
    --with-libssh2=$HOME/.softwares/install/libssh2 \
    --with-openssl=$HOME/.softwares/install/libressl \
    --with-liblinear=$HOME/.softwares/install/liblinear \
    --with-libpcap=$HOME/.softwares/install/libpcap \
    --with-liblua=$HOME/.softwares/install/lua \
    --with-libpcre=$HOME/.softwares/install/pcre
```

### Compilation

Nous allons désormais compiler nmap avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de nmap qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer nmap dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/nmap-7.94 $HOME/.softwares/install/nmap
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Nmap' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/nmap/bin:$PATH"' >> $HOME/.zshrc
echo 'export PYTHONPATH="$HOME/.softwares/install/nmap/lib/python3.9/site-packages:$PYTHONPATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/nmap/share/man:$MANPATH"' >> $HOME/.zshrc
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

Puis supprimez le dossier contenant les sources de libssh2 :

```
rm -rf nmap-7.94
```