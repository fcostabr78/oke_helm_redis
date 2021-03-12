# oke_helm_redis

```
$ alias k=kubectl
```

```
$ helm init --service-account tiller --history-max 200 --upgrade
```

```
$ helm repo add redis-oke 'https://raw.githubusercontent.com/fcostabr78/oke_helm_redis/master/'
```

```
$ helm repo update

```
$ k create ns redis
```

```
$ helm install --namespace redis redis-oke/oke-helm-redis 
```
