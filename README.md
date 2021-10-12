# README

## Pré-requisitos
https://docs.docker.com/engine/install/#server

## Instalação
Rodar no terminal:

```
$ docker-compose build
$ docker-compose run web rake db:create
```

## Rodar a aplicação

Para rodar a aplicação no endereço `localhost:3000`:

```
$ docker-compose up
```

Depois que não estiver mais usando o app, rodar:

```
$ docker-compose down
```

## Comandos úteis

```
$ sudo chown -R $USER:$USER .
$ sudo service docker restart
```

