## Домашнее задание 
№6: Шаблонизация манифестов Kubernetes

Подготовка окружения в яндекс облаке

1. ```yc init``` настроить утилиту под нужное облако
2. ```yc iam service-account list``` Посмотреть id сервисного аккаунта и определить в переменную $SA. Если нет, то создать новый с ролью editor в k8s и pull registry
2. ```yc k8s cluster create --name dz6 --service-account-id $SA --network-name default --node-service-account-id $SA --public-ip```
3. ```yc managed-kubernetes cluster get-credentials --name dz6 --external``` Для настройки kubectl, прописываются автоматом в дефолтовый путь.
4. ```yc k8s node-group create --folder-id $FOLDER --name dz6-group --cluster-name dz6 --platform standard-v3 --memory 2 --cores 2 --disk-type network-hdd --disk-size 64 --container-runtime containerd --fixed-size 1 --network-interface subnets=default-ru-central1-a,ipv4-address=nat --version 1.24```

Установка ингрес контроллера

```kubectl create ns nginx-ingress``` 
```helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx``` Репа инсталл
```helm install nginx-ingress ingress-nginx/ingress-nginx --wait -n nginx-ingress```
```helm list``` Посмотреть.
```helm show values ingress-nginx/ingress-nginx``` Посмотреть переменные

Установка cert-manager

```helm repo add jetstack https://charts.jetstack.io``` Репа инсталл
```helm repo update```
```kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.crds.yaml``` CDR
```helm install cert-manager jetstack/cert-manager --wait --namespace=cert-manager --create-namespace --version v1.12.0```

Установка chartmuseum

```kubectl create ns chartmuseum```