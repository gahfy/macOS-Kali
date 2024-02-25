# Installer LLVM 17.0.6 sous macOS depuis les sources

LLVM est une collection d'outils et de programme fournissant des compilateur et
des éditeurs de liens. Parmi les différents programmes, le compilateur C est
Clang, et c'est une version modifiée de ce compilateur qui est fournie avec
macOS

Toutefois, la version fournie sur macOS étant quelque peu limitée, il peut être
pratique d'installer une version du compilateur que vous aurez-vous même
compilé.

## Dépendances

### Insidpensable

* [**CMake**](cmake-3.28.3.md) : LLVM utilise CMake pour la configuration de la
compilation du projet.

### Recommandées

* [**Ninja**](ninja-1.11.1.md) : La majorité des dévelooppeurs de LLVM utilisent
le système de compilation Ninja, et c'est celui qui est le mieux supporté
aujourd'hui pour la compilation de LLVM

### Autres

_Note, de nombreuses dépendances optionnelles peuvent être ajoutées, permettant
une meilleure expérience pour les développeurs C et C++. Le but de ce guide
étant l'installation depuis les sources d'outils de pentesting, Clang ne nous
servira que lorsque la version fournie par Apple ne sera pas suffisante pour
compiler les programmes. Nous avons donc décidé de ne pas intégrer ces
fonctionnalités pour les développeurs dans cette installation._

## Procédure de compilation

Dans ce guide, nous allons compiler Clang avec les optimisations guidées par le
profil (Profile-Guided Optimizations ou PGO). Cela nous permettra d'optimiser
les phases de compilation, et in-fine, de réduire le temps nécessaire à la
compilation lorsque nous utiliserons ce compilateur.

Cette procédure de compilation implique de passer par plusieurs phases, et c'est
ce que nous allons faire ici.

Autre chose à noter, nous vous suggérons très fortement de garder par défaut la
version de clang fournie par défaut sur macOS, et de n'utiliser cette version
que dans certains cas très spécifique. Pour cette raison, nous n'ajouterons pas
de variables d'environnement à l'installation de LLVM.

## Installation

_La procédure d'installation suppose que CMake et Ninja ont été installés_

### Téléchargement des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 17.0.6 de LLVM.

```
curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/llvm-project-17.0.6.src.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf llvm-project-17.0.6.src.tar.xz
```

### Patch des sources

Nous allons ensuite patcher la génération d'exécutables sur ARM64. Pour se faire
nous allons commencer par télécharger le patch :

```
curl -L https://raw.githubusercontent.com/Homebrew/formula-patches/23704400c86976aaa4f421f56928484a270ac79c/llvm/17.x-arm64-opt.patch -o llvm-17.0.6-fix-arm64.patch
```

Nous allons ensuite appliquer ce patch sur nos sources :

```
patch --directory=directory=llvm-project-17.0.6.src --strip=1 < llvm-17.0.6-fix-arm64.patch
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler LLVM :

```
mkdir llvm-build
```

Puis rendez-vous dans ce répertoire :

```
cd llvm-build
```

### Phase 1

Nous allons tout d'abord, lors de cette première phase, compiler une version
minimale de LLVM comme nous le ferions si nous ne souhaitions pas ajouter
l'optimisation.

Pour se faire, nous allons commencer par créer un répertoire dans lequel nous
allons compiler cette première phase de LLVM :

```
mkdir stage1
```

Puis nous allons nous rendre dans ce répertoire :

```
cd stage1
```

Nous allons maintenant configurer la compilation avec la commande suivante :

```
cmake -G Ninja ../../llvm-project-17.0.6.src/llvm -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/llvm-17.0.6 \
    -DLLVM_TARGETS_TO_BUILD="AArch64;ARM;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_ENABLE_RUNTIMES=compiler-rt \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DCOMPILER_RT_ENABLE_IOS=OFF \
    -DCOMPILER_RT_ENABLE_WATCHOS=OFF \
    -DCOMPILER_RT_ENABLE_TVOS=OFF
```

Puis nous allons compiler LLVM pour cette première phase :

```
cmake --build . \
    --target clang llvm-profdata compiler-rt llvm-libtool-darwin LTO
```

Et voilà, notre première phase est terminée.

### Phase 2

Comme précédemment, nous allons créer un répertoire et nous rendre dedans :

```
mkdir ../stage2 && cd ../stage2
```

Et encore une fois, nous allons compiler LLVM, mais en nous servant des fichiers
générés lors de la phase 1 :

```
cmake -G Ninja ../../llvm-project-17.0.6.src/llvm -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/llvm-17.0.6 \
    -DCMAKE_C_COMPILER=$HOME/.softwares/sources/llvm-build/stage1/bin/clang \
    -DCMAKE_CXX_COMPILER=$HOME/.softwares/sources/llvm-build/stage1/bin/clang++ \
    -DLLVM_BUILD_INSTRUMENTED=IR \
    -DLLVM_BUILD_RUNTIME=NO \
    -DCMAKE_C_FLAGS="-Xclang -mllvm -Xclang -vp-counters-per-site=6" \
    -DCMAKE_CXX_FLAGS="-Xclang -mllvm -Xclang -vp-counters-per-site=6" \
    -DLLVM_TARGETS_TO_BUILD="AArch64;ARM;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_ENABLE_RUNTIMES=compiler-rt \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DCOMPILER_RT_ENABLE_IOS=OFF \
    -DCOMPILER_RT_ENABLE_WATCHOS=OFF \
    -DCOMPILER_RT_ENABLE_TVOS=OFF \
    -DCLANG_TABLEGEN=$HOME/.softwares/sources/llvm-build/stage1/bin/clang-tblgen \
    -DLLVM_TABLEGEN=$HOME/.softwares/sources/llvm-build/stage1/bin/llvm-tblgen
```

Maintenant, nous allons simplement compiler Clang, mais nous allons également
le tester. Lors de cette phase, les tests n'ont pas besoin de tous passer :

```
cmake --build . --target check-clang check-llvm --
```

### Phase profdata

Comme son nom l'indique, lors de cette phase, nous allons générer les données de
profil, qui permettront par la suite l'optimisation. Comme toujours, nous allons
créer un nouveau répertoire, et nous rendre dedans :

```
mkdir ../output && cd ../output
```

Nous allons à nouveau configurer la compilation :

```
cmake -G Ninja ../../llvm-project-17.0.6.src/llvm -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/llvm-17.0.6 \
    -DCMAKE_C_COMPILER=$HOME/.softwares/sources/llvm-build/stage2/bin/clang \
    -DCMAKE_CXX_COMPILER=$HOME/.softwares/sources/llvm-build/stage2/bin/clang++ \
    -DLLVM_BUILD_RUNTIMES=OFF \
    -DLLVM_TARGETS_TO_BUILD="AArch64;ARM;X86" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_ENABLE_RUNTIMES=compiler-rt \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DCOMPILER_RT_ENABLE_IOS=OFF \
    -DCOMPILER_RT_ENABLE_WATCHOS=OFF \
    -DCOMPILER_RT_ENABLE_TVOS=OFF
```

Et enfin, effectuer la compilation :

```
cmake --build . --
```

Lors de cette phase, de nombreux fichiers `.profraw` ont été générés, et nous
allons tous les fusionner en un seul fichier `.prof` :

```
$HOME/.softwares/sources/llvm-build/stage1/bin/llvm-profdata merge \
    -output=$HOME/.softwares/sources/llvm-build/stage2/profiles/pgo_profile.prof \
    $HOME/.softwares/sources/llvm-build/stage2/profiles/*.profraw
```

### Phase de compilation

Nous allons pouvoir maintenant compiler notre version finale de LLVM. Pour se
faire, encore une fois, créez un répertoire dédié à la compilation, et
rendez-vous dedans :

```
mkdir ../build && cd ../build
```

Configurez maintenant la compilation de notre version finale :

```
cmake -G Ninja ../../llvm-project-17.0.6.src/llvm -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$HOME/.softwares/build/llvm-17.0.6 \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb;mlir;polly" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind;openmp" \
    -DLLVM_POLLY_LINK_INTO_TOOLS=ON \
    -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_ENABLE_EH=ON \
    -DLLVM_ENABLE_FFI=ON \
    -DLLVM_ENABLE_RTTI=ON \
    -DLLVM_INCLUDE_DOCS=OFF \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_INSTALL_UTILS=ON \
    -DLLVM_OPTIMIZED_TABLEGEN=ON \
    -DLLVM_TARGETS_TO_BUILD=all \
    -DLLDB_USE_SYSTEM_DEBUGSERVER=ON \
    -DLLDB_ENABLE_LUA=OFF \
    -DLIBOMP_INSTALL_ALIASES=OFF \
    -DLLVM_CREATE_XCODE_TOOLCHAIN=OFF \
    -DCLANG_FORCE_MATCHING_LIBCLANG_SOVERSION=OFF \
    -DFFI_INCLUDE_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/ffi \
    -DFFI_LIBRARY_DIR=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/lib \
    -DLLVM_BUILD_LLVM_C_DYLIB=ON \
    -DLLVM_ENABLE_LIBCXX=ON \
    -DDEFAULT_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk \
    -DLLVM_ENABLE_LTO=Thin \
    -DCMAKE_LIBTOOL=$HOME/.softwares/sources/llvm-build/stage1/bin/llvm-libtool-darwin \
    -DCMAKE_C_COMPILER=$HOME/.softwares/sources/llvm-build/stage1/bin/clang \
    -DCMAKE_CXX_COMPILER=$HOME/.softwares/sources/llvm-build/stage1/bin/clang++ \
    -DLLVM_PROFDATA_FILE=$HOME/.softwares/sources/llvm-build/stage2/profiles/pgo_profile.prof \
    -DCLANG_TABLEGEN=$HOME/.softwares/sources/llvm-build/stage1/bin/clang-tblgen
```

Et nous allons maintenant lancer la compilation, puis installer LLVM :

```
cmake --build . --target install
```

### Correction du `RPATH` des bibliothèques

Le chemin `RPATH` des bibliothèques installées par LLVM n'est pas renseigné, ce
qui peut poser des problèmes pour les exécutables qui vont se baser sur ce
`RPATH` pour trouver l'emplacement des bibliothèques.

Pour corriger cela, nous allons corriger le répertoire d'installation de ces
bibliothèques :

```
for libFile in $HOME/.softwares/build/llvm-17.0.6/lib/*.dylib; do
    if [ ! -L $libFile ]; then
        install_name_tool -id "$HOME/.softwares/build/llvm-17.0.6/lib/`basename -- $libFile`" "$HOME/.softwares/build/llvm-17.0.6/lib/`basename -- $libFile`"
    fi
done
```

### Installation de la toolchain XCode

Nous allons maintenant ajouter la toolchain XCode à LLVM. Pour commencer, nous
allons créer un lien symbolique de notre bibliothèque avec le numéro de version :

```
ln -s libLLVM.dylib $HOME/.softwares/build/llvm-17.0.6/lib/libLLVM-17.0.6.dylib
```

Puis nous allons créer un fichier `Info.plist` avec les informations pertinentes
dedans :

```
/usr/libexec/PlistBuddy -c "Add:CFBundleIdentifier string org.llvm.17.0.6" Info.plist
/usr/libexec/PlistBuddy -c "Add:CompatibilityVersion integer 2" Info.plist
```

Ensuite, nous allons créer le dossier qui contiendra notre toolchain :

```
mkdir -p $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/usr
```

Et nous allons déplacer notre fichier `Info.plist` à la racine de ce dossier :

```
mv Info.plist $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/
```

Il ne nous reste plus qu'à créer des liens symboliques dans le dossier `usr`
vers les dossiers correspondants de LLVM:

```
ln -s $HOME/.softwares/build/llvm-17.0.6/bin $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/usr/bin
ln -s $HOME/.softwares/build/llvm-17.0.6/include $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/usr/include
ln -s $HOME/.softwares/build/llvm-17.0.6/lib $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/usr/lib
ln -s $HOME/.softwares/build/llvm-17.0.6/libexec $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/usr/libexec
ln -s $HOME/.softwares/build/llvm-17.0.6/share $HOME/.softwares/build/llvm-17.0.6/Toolchains/LLVM17.0.6.xctoolchain/usr/share
```

### Ajout du lien symbolique dans le répertoire d'installation

Dernière étape, nous allons ajouter le lien symbolique dans notre répertoire
d'installation :

```
ln -s ../build/llvm-17.0.6 $HOME/.softwares/install/llvm
```

Et voilà, l'installation de LLVM est terminée.

## Nettoyage

Il ne nous reste plus qu'à supprimer les dossiers que nous avons créés. Pour se
faire, rendez-vous déjà dans le dossier source :

```
cd ../..
```

Puis supprimez le dossier contenant les fichiers de compilation :

```
rm -rf llvm-build
```

Et enfin le dossier contenant les sources :

```
rm -rf llvm-project-17.0.6.src
```