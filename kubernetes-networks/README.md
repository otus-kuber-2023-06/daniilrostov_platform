# Выполнено ДЗ №3

Добавлена папка "kubernetes-networks"

В "web-deploy.yaml" описан деплоймент с проверкой "readinessProbe" и "livenessProbe" для тестов.
После ```kubectl apply -f web-deploy.yaml``` смотрим состояние ```kubectl describe deployment.apps/web``` поле "Available". Так же в манифесте исползуется "strategy".

В "web-svc-cip.yaml" описан сервис кластер ip. После применения манифеста можно посмотреть ```kubectl get svc```. ip кластера доступен изнутри куба ```minikube ssh``` но на пинг не отвечает.
Работа сервиса строится на правилах фильтрации "https://msazure.club/kubernetes-services-and-iptables/"

С версии 1.0.0 Minikube поддерживает работу kube-proxy в режиме IPVS: "https://github.com/metallb/metallb/issues/153". После включения ipvs ответы на пинг идут.

## Установлен "MetalLB"

MetalLB позволяет запустить внутри кластера L4-балансировщик,
который будет принимать извне запросы к сервисам и раскидывать их
между подами: ```kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml```

Посмотреть ```kubectl --namespace metallb-system get all```

Настройки балансировщика определены в манифесте metallb-config.yaml
В конфигурации мы настраиваем:
Режим L2 (анонс адресов балансировщиков с помощью ARP)
Создаем пул адресов 172.17.255.1 - 172.17.255.255 - они будут
назначаться сервисам с типом LoadBalancer

В манифесте web-svc-lb.yaml описан балансировщик. После применения можно посмотреть ```kubectl describe svc/web-svc-lb```. Для доступности сервиса на основной ОС нужно добавить сетевые маршруты.

## Создание Ingress

```kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/deploy.yaml```

Создан nginx-lb.yaml 