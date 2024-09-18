# README

Copy .env

```
cp .env.template .env
```

Run Postgres docker instance

> We are not running a rails dev environment as a container because foreman doesn't work well.

```
docker compose up -d
```

> Assuming that you have already install rails in your machine
> Highly recommend to use any linux distros(Ubuntu, etc..) or use WSL(if you use windows)

Initiate DB

```
rails db:create
rails db:migrate
rails db:seed
```

Run the App

```
bin/dev
```
