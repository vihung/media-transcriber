#!/bin/bash
mkdir -p ~/media/inbox ~/media/outbox
mv ~/.docker/config.json ~/.docker/config.json.old; cat ~/.docker/config.json.old | sed /credsStore/d > ~/.docker/config.json; rm ~/.docker/config.json.old
docker compose up -d
