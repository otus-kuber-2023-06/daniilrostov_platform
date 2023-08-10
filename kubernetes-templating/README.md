## Домашнее задание №6
Шаблонизация манифестов Kubernetes

### Подготовка окружения в яндекс облаке

1. ```yc init``` настроить утилиту под нужное облако
2. ```yc iam service-account list``` Посмотреть id сервисного аккаунта и определить в переменную $SA. Если нет, то создать новый с ролью editor в k8s и pull registry
2. ```yc k8s cluster create --name dz6 --service-account-id $SA --network-name default --node-service-account-id $SA --public-ip```
3. ```yc managed-kubernetes cluster get-credentials --name dz6 --external``` Для настройки kubectl, прописываются автоматом в дефолтовый путь.
4. ```yc k8s node-group create --folder-id $FOLDER --name dz6-group --cluster-name dz6 --platform standard-v3 --memory 6 --cores 2 --disk-type network-hdd --disk-size 64 --container-runtime containerd --fixed-size 1 --network-interface subnets=default-ru-central1-a,ipv4-address=nat --version 1.24```

### Установка "ingress controller"

```kubectl create ns nginx-ingress```  
```helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx``` Репа инсталл  
```helm install nginx-ingress ingress-nginx/ingress-nginx --wait -n nginx-ingress```  
```helm list``` Посмотреть.  
```helm show values ingress-nginx/ingress-nginx``` Посмотреть переменные

### Установка cert-manager

```helm repo add jetstack https://charts.jetstack.io``` Репа инсталл  
```helm repo update```  
```kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.crds.yaml``` CDR  
```helm install cert-manager jetstack/cert-manager --wait --namespace=cert-manager --create-namespace --version v1.12.0```  
```kubectl apply -f cert-manager/prod_cluster-issuer.yaml```  
```helm show values jetstack/cert-manager``` Посмотреть переменные

### Установка chartmuseum

```kubectl create ns chartmuseum```  
```helm add repo https://chartmuseum.github.io/charts```
```helm upgrade --install chartmuseum chrtmuseum/chartmuseum --wait --namespace=chartmuseum -f chartmuseum/values.yaml```  
```helm.exe ls -n chartmuseum``` Проверить как запустился.  
```helm show values stable/chartmuseum``` Посмотреть переменные  
```curl chartmuseum.158.160.40.175.nip.io```

### Мануал по работе с Helm и chartmuseum

Helm create  
```helm.exe create demo-chart```  
Helm start  
```helm.exe install demo-app ./demo-chart```  
Helm upgrade  
```helm.exe upgrade demo-app ./demo-chart```  
Helm history  
```helm.exe history demo-app```  
Helm rollbak  
```helm.exe rollback demo-app "id from history"```  
Helm deploy to dev  
```helm.exe upgrade --install demo-app ./demo-chart -f ./demo-chart/values_dev.yaml -n app --create-namespace --dry-run```  

Enable all routes prefixed with /api in chartmuseum/values.yaml    
```DISABLE_API: false```  
```helm.exe upgrade --install chartmuseum -f chartmuseum/values.yaml```  
 
Create helm package and push  
```helm package .\demo-chart```  
```curl.exe --data-binary "@demo-chart-0.1.0.tgz" http://chartmuseum.158.160.40.175.nip.io/api/charts```  
Add  own repo  
```helm repo add my-chart http://chartmuseum.158.160.40.175.nip.io```  
```helm.exe repo update my-chart```  
After add user and pssword to values.yaml  
```helm repo add my-chart http://chartmuseum.158.160.40.175.nip.io --username admin --password password```  
```curl.exe --user admin:password --data-binary "@demo-chart-0.1.0.tgz" http://chartmuseum.158.160.40.175.nip.io/api/charts```  
```curl.exe --user admin:password -X DELETE "@demo-chart-0.1.0.tgz" http://chartmuseum.158.160.40.175.nip.io/api/charts/demo-chart/0.2.0```

### Установка Harbor
```helm repo add harbor https://helm.goharbor.io```  
```helm repo update harbor```  
```helm install  my-harbor harbor/harbor -f harbor/values.yaml```

Все чарты можно запустить автоматом через helmfile.yaml  
```helmfile -n <namespace> apply```

### Создаём свой "helm chart"
```kubectl create ns hipster-shop```
```helm upgrade --install hipster-shop kubernetes-templating/hipster-shop --namespace hipster-shop```

