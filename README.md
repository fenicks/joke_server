# Joke Server [![Build Status](https://travis-ci.org/fenicks/joke_server.svg?branch=master)](https://travis-ci.org/fenicks/joke_server) [![Coverage Status](https://coveralls.io/repos/fenicks/joke_server/badge.svg?branch=master&service=github)](https://coveralls.io/github/fenicks/joke_server?branch=master)

## Description

Joke Server est un service web développé pour les besoins d'une présentation sur les services web : "Web Services par l'Exemple avec Ruby".
<br>
La présentation est sur Slideshare : [http://fr.slideshare.net/christiankakesa/web-services-par-lexemple-avec-ruby](http://fr.slideshare.net/christiankakesa/web-services-par-lexemple-avec-ruby).

## Installation

 * Installer Ruby 2.7.0
 * Installer Redis : [https://redis.io/topics/quickstart]()
 * A la racine du projet exécuter :
   * `gem install bundler`
   * `bundle install`
 * Lancer le projet en exécutant `./run.sh` ou directement `unicorn -E ${RACK_ENV:-development} --config=./config/unicorn.rb --port=${PORT:-5000}`

## Utilisation des services web implémentés

### Web service `/hi`

 * Méthode HTTP : `GET`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `N/A`

### Namespace `/v1`

#### Web service `/v1/status`

 * Méthode HTTP : `GET`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `N/A`

#### Web service `/v1/healthCheck` : Test en plus du service, la présence du fichier mock des blagues

 * Méthode HTTP : `GET`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `503`

#### Web service `/v1/joke` : La v1 récupère aléatoirement une blague depuis un fichier mock.

 * Méthode HTTP : `GET`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `N/A`, renvoi une blague par défaut qui contient le texte **Joker!**

### Namespace `/v2`

#### Web service `/v2/healthCheck` : Test en plus du service, la connection à Redis

 * Méthode HTTP : `GET`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `503`

#### Web service `/v2/joke`

##### Récupère aléatoirement une blague depuis Redis.

 * Méthode HTTP : `GET`
 * Espace de nom : `/v2/joke`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `404`

##### Récupère spécifiquement une blague depuis Redis.

 * Méthode HTTP : `GET`
 * Espace de nom : `/v2/joke/[id:Integer]`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `404`

##### Ajoute une blague dans Redis.

 * Méthode HTTP : `POST`
 * Espace de nom : `/v2/joke`
 * Paramètre : `joke`, contenu de la blague
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `400`, impossible de créer la blague dans Redis
 * Code HTTP d'erreur : `403`, paramètre manquant

##### Supprime une blague dans Redis.

 * Méthode HTTP : `DELETE`
 * Espace de nom : `/v2/joke/[id:Integer]`
 * Code HTTP OK : `200`
 * Code HTTP d'erreur : `403`, la blague à supprimer n'existe pas

##### Modifie une blague dans Redis.

  * Méthode HTTP : `PATCH`
  * Espace de nom : `/v2/joke/[id:Integer]`
  * Paramètre : `joke`, nouveau contenu de la blague
  * Code HTTP OK : `200`
  * Code HTTP d'erreur : `400`, impossible de modifier la blague dans Redis
  * Code HTTP d'erreur : `403`, paramètre manquant

## Technologies utilisées

- Ruby : [https://www.ruby-lang.org](https://www.ruby-lang.org "Ruby")
- Sinatra : [http://www.sinatrarb.com](http://www.sinatrarb.com "Sinatra")
- Redis : [http://redis.io/](http://redis.io "Redis")

## Présentations données

 * [Web Day ESGI : Le 13 juin 2014](http://www.esgi.fr/emailing/esgi_web_day_120614_etudiant/esgi_web_day_120614_etudiant_html.html "Web Day ESGI : Le 13 juin 2014")
 * ...