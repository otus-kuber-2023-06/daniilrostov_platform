# Flux - инструмент для организации GitOps процесса.

### Install
```curl -s https://fluxcd.io/install.sh | sudo bash```  

### init ingress-nginx
```flux bootstrap gitlab --owner=daniil3950339 --repository=microservicesdemo --branch=main --path=./gitops/infra --personal```  

После этого произойдёт установка  

1. ingress-nginx (контроллер)  
2. cert-manager  

### init istio
```flux bootstrap gitlab --owner=daniil3950339 --repository=microservicesdemo --branch=main --path=./gitops/istio --personal```  

После этого произойдёт установка  

1. istio-base   
2. istiod  
3. istio-ingress
4. kiali  http://EXTERNAL-IP:20001
5. grafana http://EXTERNAL-IP:3000
6. jaeger http://EXTERNAL-IP:16686
7. flagger


### Полезные команды  
```flux events```    
```flux logs```  
```kubectl get helmrepository```    
```kubectl get helmrelease```  
