# Joke Server

## Description

Joke Server est un service web développé pour les besoins d'une présentation sur les services web : "Web Services par l'Exemple avec Ruby".
<br>
La présentation est sur Slideshare : [http://fr.slideshare.net/christiankakesa/web-services-par-lexemple-avec-ruby](http://fr.slideshare.net/christiankakesa/web-services-par-lexemple-avec-ruby).

## Installation

 * Installer Ruby 2.1.2
 * A la racine du projet exécuter `bundle install`
 * Lancer le projet en exécutant `./run.sh` ou directement `unicorn -E ${RACK_ENV:-development} --config=./config/unicorn.rb --port=${PORT:-5000}`

## Technologies utilisées

- Ruby : [https://www.ruby-lang.org](https://www.ruby-lang.org "Ruby")
- Sinatra : [http://www.sinatrarb.com](http://www.sinatrarb.com "Sinatra")
- Redis : [http://redis.io/](http://redis.io "Redis")

## Présentations données

 * [Web Day ESGI : Le 13 juin 2014](http://www.esgi.fr/emailing/esgi_web_day_120614_etudiant/esgi_web_day_120614_etudiant_html.html "Web Day ESGI : Le 13 juin 2014")
 * ...