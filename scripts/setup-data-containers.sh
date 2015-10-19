#!/bin/sh

docker pull phusion/passenger-ruby22:0.9.17
docker pull busybox
docker pull phusion/baseimage:0.9.17
docker pull postgres:9.4.4

docker run -it -v /var/lib/postgresql/data --name db-data busybox true
docker run -it -v /etc/wal-e.d/env --name db-backup-data busybox true
docker run -it -v /var/lib/gems --name gem-data busybox true
docker run -it -v /srv/certs --name ssl-data busybox true
docker run -it -v /root/.ssh --name ssh-data busybox true
docker run -it -v /home/app --name app-data busybox true
docker run -it -v /etc/nginx/sites-enabled --name nginx-data busybox true

docker cp certs/unified_certs.pem ssl-data:/srv/certs/unified_certs.pem
docker cp wal-e/AWS_ACCESS_KEY_ID db-backup-data:/etc/wal-e.d/env/
docker cp wal-e/AWS_SECRET_ACCESS_KEY db-backup-data:/etc/wal-e.d/env/
docker cp wal-e/WALE_S3_PREFIX db-backup-data:/etc/wal-e.d/env/
docker cp ssh/id_rsa ssh-data:/root/.ssh
docker cp ssh/id_rsa.pub ssh-data:/root/.ssh
docker cp ssh/known_hosts ssh-data:/root/.ssh
docker cp configs/nginx.conf nginx-data:/etc/nginx/sites-enabled/webapp.conf

docker run -ti --rm \
  -w /home/app \
  --volumes-from app-data \
  --volumes-from ssh-data phusion/passenger-ruby22:0.9.17 \
  git clone git@github.com:mfamilia/komo.git .
