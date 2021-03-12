# Redis @ OKE

## Objetivo

O objetivo desse how-to é demonstrar a instalçao do Redis dentro de um cluster kubernetes. Através desse empacotamento é possível determinar o número de PODs para as replicas e redis secundário, personalizar senha ao secret e determinar um pool específico para instalação. 

## Pré-requisito

1. Cluster Kubernetes provisiondo no Oracle Cloud Infrastruture <br>
   https://docs.oracle.com/pt-br/iaas/Content/ContEng/Concepts/contengoverview.htm

2. redis-cli instalado localmente

3. helm instalado localmente


## Etapas


```
$ alias k=kubectl
```

```
$ helm init --service-account tiller --history-max 200 --upgrade
```

```
$ helm repo add redis-oke 'https://raw.githubusercontent.com/fcostabr78/oke_helm_redis/master/' --set deployment.password=<senha>
```

```
$ helm repo update
```

```
$ k create ns redis
```

```
$ helm install --namespace redis redis-oke/oke-helm-redis 
```

<table>
    <tbody>
        <tr>
        <th><img align="left" width="600" src="https://objectstorage.us-ashburn-1.oraclecloud.com/n/idsvh8rxij5e/b/imagens_git/o/Screenshot%20from%202021-03-12%2001-13-05.png"/></th>
        </tr>
    </tbody>
</table>




