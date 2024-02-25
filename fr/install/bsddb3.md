#  bsddb3

Le module bsddb3 est un portage de la bibliothèque C Oracle/Sleepycat.

_La dernière version de bsddb3 n'étant pas fonctionnelle, nous avons choisi la
dernière version installable du module_

## Dépendances

### Indispensables

* [**Berkeley DB**](berkeley-db-18.1.40.md) bsddb3 recquiert les bibliothèques
de Berkeley DB.

## Installation

Il suffit d'appeler le script `pip` pour l'installation :

```
BERKELEYDB_DIR=$HOME/.softwares/install/db \
    pip3 install bsddb3
```