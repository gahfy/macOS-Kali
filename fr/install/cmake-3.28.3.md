# Installer CMake 3.28.3 sous macOS depuis les sources

CMake est un ensemble d'outil pour gérer la compilation de projets.

_CMake est connu pour avoir des tests qui échouent si XCode n'est pas installé
et que seuls les outils de développement le sont._

## Dépendances

_Aucune_

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 3.28.3 de CMake.

```
curl -LO  https://github.com/Kitware/CMake/releases/download/v3.28.3/cmake-3.28.3.tar.gz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf cmake-3.28.3.tar.gz
```

### Patch des sources

Le test `BuildDepends` de CMake est connu pour échouer sur les ordinateurs mac
équipés de puce ARM. Nous allons donc corriger ce test.

Pour commencer, nous allons écrire le fichier de patch :

```
cat << 'EOF' >> cmake-3.28.3-fix-arm-arch.patch
diff -ruN a/Tests/BuildDepends/Project/CMakeLists.txt b/Tests/BuildDepends/Project/CMakeLists.txt
--- a/Tests/BuildDepends/Project/CMakeLists.txt
+++ b/Tests/BuildDepends/Project/CMakeLists.txt
@@ -19,7 +19,7 @@
   if(EXISTS "${CMAKE_OSX_SYSROOT}" AND NOT "${CMAKE_GENERATOR}" MATCHES "Ninja")
     if(CMake_TEST_XCODE_VERSION VERSION_GREATER_EQUAL 10)
       # Arch 'i386' no longer works in Xcode 10.
-      set(CMAKE_OSX_ARCHITECTURES x86_64)
+      set(CMAKE_OSX_ARCHITECTURES x86_64 arm64)
     elseif(CMake_TEST_XCODE_VERSION VERSION_GREATER_EQUAL 4)
       # Arch 'ppc' no longer works in Xcode 4.
       set(CMAKE_OSX_ARCHITECTURES i386 x86_64)
EOF
```

Nous allons ensuite appliquer ce patch sur nos sources :

```
patch --directory=cmake-3.28.3 --strip=1 < cmake-3.28.3-fix-arm-arch.patch
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler CMake :

```
mkdir cmake-build
```

Puis rendez-vous dans ce répertoire :

```
cd cmake-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de CMake, en nous contentant
d'indiquer le répertoire d'installation :

```
../cmake-3.28.3/bootstrap --prefix=$HOME/.softwares/build/cmake-3.28.3
```

### Compilation

Nous allons désormais compiler CMake avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de CMake qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make test
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer CMake dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/cmake-3.28.3 $HOME/.softwares/install/cmake
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## CMake' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/cmake/bin:$PATH"' >> $HOME/.zshrc
echo 'export ACLOCAL_PATH="$HOME/.softwares/install/cmake/share/aclocal:$ACLOCAL_PATH"' >> $HOME/.zshrc
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

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf cmake-build
```

Puis finalement le dossier contenant les sources de cmake :

```
rm -rf cmake-3.18.3
```