# Docker Apache PHP8.1 MySQL8

## Renseigner les variables d'environnement

Renommer le fichier **.env.simple** en **.env** et fournir une valeur pour chaque variables d'environnement.

**Important**

*Si après le premier build, changement du mot de passe MySQL de l'utilisateur **root**, vider le dossier **mysql_data** (ou en tout cas les fichiers concernés) sinon c'est toujours l'ancien mot de passe qui sera pris en compte.*

## Utilier le Makefile

Utiliser la commande `make build-up` pour lancer le projet et consulter les autres commandes disponibles avec `make help`.
