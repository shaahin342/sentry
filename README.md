

(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr

(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr

$ docker run -d --name sentry-redis redis

$ docker run -d --name sentry-postgres -e POSTGRES_PASSWORD=secret -e POSTGRES_USER=sentry postgres

$ docker run --rm sentry config generate-secret-key

$ docker run -it --rm -e SENTRY_SECRET_KEY='(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr' --link sentry-postgres:postgres --link sentry-redis:redis sentry upgrade 


$ docker run -d --name my-sentry -p 8080:9000 -e SENTRY_SECRET_KEY='(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr' --link sentry-redis:redis --link sentry-postgres:postgres sentry 


$ docker run -d --name sentry-cron -e SENTRY_SECRET_KEY='(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr' --link sentry-postgres:postgres --link sentry-redis:redis sentry run cron


$ docker run -d --name sentry-worker-1 -e SENTRY_SECRET_KEY='(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr' --link sentry-postgres:postgres --link sentry-redis:redis sentry run worker

$ sudo docker run -it --rm -e SENTRY_SECRET_KEY='(t(e22qa+hx4%hllqrno)4sr=6ki^t@#zfpk_cvsfg=0i0cpvr' --link sentry-redis:redis --link sentry-postgres:postgres sentry createuser





