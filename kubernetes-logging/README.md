# Выполнено ДЗ №9
  
Сервисы централизованного логирования для компонентов Kubernetes и приложений  

## Для выподнения ДЗ развернём ктастер в облаке через terraform  

```https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart```

```yc iam service-account list```
```yc iam key create --service-account-id <идентификатор_сервисного_аккаунта> --folder-name <имя_каталога_с_сервисным_аккаунтом> --output key.json```

```yc config set service-account-key key.json```  
```yc config set cloud-id <идентификатор_облака>```  
```yc config set folder-id <идентификатор_каталога>```  

## Добавить в окружение для добавления разрешений terraform
```$Env:YC_TOKEN=$(yc iam create-token)``` 
```$Env:YC_CLOUD_ID=$(yc config get cloud-id)``` 
```$Env:YC_FOLDER_ID=$(yc config get folder-id)``` 

## Для S3  
```$Env:ACCESS_KEY="<идентификатор_ключа>"```
```$Env:SECRET_KEY="<секретный_ключ>"```

## Создать рессурс. 

Выполнить команду из папки k8s_terraform  
```terraform apply```  
```yc managed-kubernetes cluster get-credentials --name dz9 --external``` Для настройки kubectl, прописываются автоматом в дефолтовый путь.  

```kubectl taint nodes node1 node-role=infra:NoSchedule```  

```kubectl create ns microservices-demo```  
```kubectl apply -f https://raw.githubusercontent.com/express42/otus-platform-snippets/master/Module-02/Logging/microservices-demo-without-resources.yaml -n microservices-demo```  

## Установка Loky

```helm repo add grafana https://grafana.github.io/helm-charts```  
```helm upgrade --install loki --namespace=observability grafana/loki-stack```

```helm upgrade --install grafana --namespace=observability grafana/grafana```

## Получить пароль графаны
```kubectl get secret --namespace observability grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo```  