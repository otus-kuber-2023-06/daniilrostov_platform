# Выполнено ДЗ №8

Мониторинг сервиса в кластере k8s

## Добавим оператор prometheus

```LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)```  
```curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/${LATEST}/bundle.yaml | kubectl create -f -```

## Запускаем по порядку файты

```kubectl apply -f 01..0n```

## Ключевую роль играет манифест 'servicemonitor_nginx'. Создан по инструкции:  
```https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/user-guides/getting-started.md```
