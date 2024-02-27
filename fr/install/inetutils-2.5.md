# Installer inetutils 2.5 sous macOS depuis les sources

Inetutils est un ensemble d'outils réseaux, parmi lesquels on peut citer 
`telnet` ou encore `ftp`.

## Dépendances

### Indispensables

* [**help2man**](help2man-1.49.3.md) : `help2man` est requis pour générer les
fichiers man.

## Installation

### Téléchargements des sources

Assurez-vous tout d'abord de bien être dans le répertoire des sources.

```
cd $HOME/.softwares/sources
```

Téléchargez ensuite l'archive de la version 2.5 de Inetutils.

```
curl -LO https://ftp.gnu.org/gnu/inetutils/inetutils-2.5.tar.xz
```

Extrayez ensuite l'archive que vous venez de télécharger :

```
tar -xf inetutils-2.5.tar.xz
```

### Patch des sources

Les sources de syslogd ne peuvent être compilées sous macOS. Pour corriger cela,
commencez par écrire le fichier de patch :

```
cat << 'EOF' >> inetutils-2.5-fix-syslogd.patch
diff --git a/libinetutils/libinetutils.h b/libinetutils/libinetutils.h
index ed840c2..ae55c4c 100644
--- a/libinetutils/libinetutils.h
+++ b/libinetutils/libinetutils.h
@@ -22,6 +22,7 @@
 
 #include "argp-version-etc.h"
 #include <signal.h>
+#include <sys/uio.h>
 
 sighandler_t setsig (int sig, sighandler_t handler);
 void utmp_init (char *line, char *user, char *id, char *host);
@@ -31,6 +32,7 @@ char *localhost (void);
 void logwtmp (const char *, const char *, const char *);
 void cleanup_session (char *tty, int pty_fd);
 void logwtmp_keep_open (char *line, char *name, char *host);
+char *inetutils_ttymsg (struct iovec *, int, char *, int);
 
 #ifndef HAVE_STRUCT_IF_NAMEINDEX
 struct if_nameindex
diff --git a/libinetutils/ttymsg.c b/libinetutils/ttymsg.c
index af9f251..b94ee75 100644
--- a/libinetutils/ttymsg.c
+++ b/libinetutils/ttymsg.c
@@ -71,7 +71,7 @@ static char *normalize_path (char *path, const char *delim);
  * ignored (exclusive-use, lack of permission, etc.).
  */
 char *
-ttymsg (struct iovec *iov, int iovcnt, char *line, int tmout)
+inetutils_ttymsg (struct iovec *iov, int iovcnt, char *line, int tmout)
 {
   static char errbuf[MAX_ERRBUF];
   char *device;
diff --git a/src/syslogd.c b/src/syslogd.c
index 918686d..faeec0c 100644
--- a/src/syslogd.c
+++ b/src/syslogd.c
@@ -278,7 +278,6 @@ void logerror (const char *);
 void logmsg (int, const char *, const char *, int);
 void printline (const char *, const char *);
 void printsys (const char *);
-char *ttymsg (struct iovec *, int, char *, int);
 void wallmsg (struct filed *, struct iovec *);
 char **crunch_list (char **oldlist, char *list);
 char *textpri (int pri);
@@ -1653,7 +1652,7 @@ wallmsg (struct filed *f, struct iovec *iov)
 	  /* Note we're using our own version of ttymsg
 	     which does a double fork () to not have
 	     zombies.  No need to waitpid().  */
-	  p = ttymsg (iov, IOVCNT, line, TTYMSGTIME);
+	  p = inetutils_ttymsg (iov, IOVCNT, line, TTYMSGTIME);
 	  if (p != NULL)
 	    {
 	      errno = 0;	/* Already in message. */
@@ -1666,7 +1665,7 @@ wallmsg (struct filed *f, struct iovec *iov)
 	if (!strncmp (f->f_un.f_user.f_unames[i], UT_USER (utp),
 		      sizeof (UT_USER (utp))))
 	  {
-	    p = ttymsg (iov, IOVCNT, line, TTYMSGTIME);
+	    p = inetutils_ttymsg (iov, IOVCNT, line, TTYMSGTIME);
 	    if (p != NULL)
 	      {
 		errno = 0;	/* Already in message. */
diff --git a/talkd/announce.c b/talkd/announce.c
index 6cb62f0..2922b9b 100644
--- a/talkd/announce.c
+++ b/talkd/announce.c
@@ -27,7 +27,7 @@
 #define N_LINES 5
 #define N_CHARS 256
 
-extern char *ttymsg (struct iovec *iov, int iovcnt, char *line, int tmout);
+#include <libinetutils.h>
 
 typedef struct
 {
@@ -112,7 +112,7 @@ print_mesg (char *tty, CTL_MSG *request, char *remote_machine)
   iovec.iov_base = buf;
   iovec.iov_len = strlen (buf);
 
-  if ((cp = ttymsg (&iovec, 1, tty, RING_WAIT - 5)) != NULL)
+  if ((cp = inetutils_ttymsg (&iovec, 1, tty, RING_WAIT - 5)) != NULL)
     {
       syslog (LOG_ERR, "%s", cp);
       return FAILED;
EOF
```

Puis appliquez le correctif

```
patch --directory=inetutils-2.5 --strip=1 < inetutils-2.5-fix-syslogd.patch
```

### Création du répertoire de compilation

Créez un répertoire dans lequel nous allons compiler Inetutils :

```
mkdir inetutils-build
```

Puis rendez-vous dans ce répertoire :

```
cd inetutils-build
```

### Configuration de la compilation

Nous allons maintenant configurer la compilation de Inetutils, en nous
contentant d'indiquer le répertoire d'installation :

```
../inetutils-2.5/configure --prefix=$HOME/.softwares/build/inetutils-2.5
```

### Compilation

Nous allons désormais compiler Inetutils avec la commande suivante :

```
make
```

### Test des exécutables

Afin de nous assurer que la version de Inetutils qui vient d'être compilée
fonctionnera comme prévu, nous vous recommandons de lancer la suite de tests qui
vérifiera que le comportement des exécutables est conforme à celui attendu :

```
make check
```

### Installation

Une fois que vous vous êtes assuré que les exécutables fonctionnenent comme
attendu, vous pouvez désormais installer Inetutils dans son répertoire de
destination :

```
make install
```

Maintenant que les fichiers d'installation sont bien installés dans leur
répertoire définitif, nous pouvons créer un lien symbolique vers ce répertoire
d'installation

```
ln -s ../build/inetutils-2.5 $HOME/.softwares/install/inetutils
```

Nous pouvons désormais ajouter les variables d'environnement au fichier de
profil du terminal zsh:

```
echo '' >> $HOME/.zshrc
echo '## Inetutils' >> $HOME/.zshrc
echo 'export PATH="$HOME/.softwares/install/inetutils/bin:$PATH"' >> $HOME/.zshrc
echo 'export INFOPATH="$HOME/.softwares/install/inetutils/share/info:$INFOPATH"' >> $HOME/.zshrc
echo 'export MANPATH="$HOME/.softwares/install/inetutils/share/man:$MANPATH"' >> $HOME/.zshrc
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
rm -rf inetutils-build
```

Puis finalement le dossier contenant les sources de inetutils-2.5 :

```
rm -rf inetutils-2.5
```