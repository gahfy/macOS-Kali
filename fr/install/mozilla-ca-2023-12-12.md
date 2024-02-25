## Liste des autorités de certification de Mozilla

La liste des autorités de certification permettra aux programmes utilisant cette
dernière de vérifier la validité d'un certificat SSL.

## Procédure d'installation

Cette installation ne requiert que l'installation d'un simple fichier, qui peut
avoir différente version.

Du coup, bien que ce ne soit pas une compilation à proprement parlé, nous allons
installer ce fichier dans le répertoire build.

## Installation

Nous allons commencer par créer le répertoire d'installation du certificat :

```
mkdir $HOME/.softwares/build/mozilla-ca-2023-12-12
```

Nous allons ensuite télécharger le fichier contenant la liste des autorités de
certifications valides et l'enregistrer dans ce répertoire:

```
curl -L https://curl.se/ca/cacert-2023-12-12.pem \
    -o $HOME/.softwares/build/mozilla-ca-2023-12-12/cacert.pem
```

Nous allons désormais créer le lien vers ce répertoire dans le dossier
d'installation

```
ln -s ../build/mozilla-ca-2023-12-12 $HOME/.softwares/install/mozilla-ca
```

Et voilà, l'installation de la liste des autorités de certifications est
terminée.