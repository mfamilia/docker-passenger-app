== README

Using Docker Composer (Install Docker Toolbox)

Build image:

`docker-compose build`

Start containers:

`docker-compose up`

Remove untagged images

`docker rmi $(docker images | grep "^<none>" | awk "{print $3}")`

Remove Containers

`docker rm -v $(docker ps -a -q -f status=exited)`

https://docs.docker.com/compose/yml/

Build Image and Tag

docker build --tag=manuelgfx/docker-komo:latest .

Build Data Container

`docker run -it -v /var/lib/postgresql/data --name db-data busybox true`
`docker run -it -v /etc/wal-e.d/env --name db-backup-data busybox true`
`docker run -it -v /var/lib/gems --name gem-data busybox true`
`docker run -it -v /srv/certs --name ssl-data busybox true`
`docker run -it -v /root/.ssh --name ssh-data busybox true`
`docker run -it -v /home/app --name app-data busybox true`
`docker run -it -v /etc/nginx/sites-enabled/ --name nginx-data busybox true`

Data Container Setup

`docker cp certs/unified_certs.pem ssl-data:/srv/certs/unified_certs.pem`
`docker cp wal-e/AWS_ACCESS_KEY_ID db-backup-data:/etc/wal-e.d/env/`
`docker cp wal-e/AWS_SECRET_ACCESS_KEY db-backup-data:/etc/wal-e.d/env/`
`docker cp wal-e/WALE_S3_PREFIX db-backup-data:/etc/wal-e.d/env/`
`docker cp ssh/id_rsa ssh-data:/root/.ssh`
`docker cp ssh/id_rsa.pub ssh-data:/root/.ssh`
`docker cp configs/nginx.conf nginx-data:/etc/nginx/sites-enabled/webapp.conf`

`docker run -ti --rm -w /home/app --volumes-from app-data phusion/passenger-ruby22:0.9.17 bash`
> ssh-keyscan github.com >> /root/.ssh/known_hosts
> git clone git@github.com:mfamilia/komo.git .

Delete Orphaned Volumes

`docker run -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker --rm martin/docker-cleanup-volumes --dry-run`

Backup Data Containers

`docker run --volumes-from data -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /etc/wal-e.d/env /root/.ssh /srv/certs /var/lib/gems /var/lib/postgresql/data`

Deployment

`docker run -ti --rm -w /home/app --volumes-from app-data phusion/passenger-ruby22:0.9.17 git pull`
`docker-compose run --rm app bundle install && rake db:migrate assets:precompile`
