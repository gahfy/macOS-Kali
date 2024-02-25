# plyvel

Le module plyvel contient une interface pour LevelDB.

## Dépendances

### Indispensables

* [**LevelDB <= 1.22**](leveldb-1.22.md) : LevelDB est requis pour l'installation du
module plyvel

## Installation

Il suffit d'appeler le script `pip` pour l'installation :

```
CFLAGS="-I$HOME/.softwares/install/leveldb/include" \
    LDFLAGS="-L$HOME/.softwares/install/leveldb/lib -lleveldb" \
    pip3 install plyvel
```