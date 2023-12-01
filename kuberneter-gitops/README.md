### Инструкция проекта  

1. Ручной apply, destroy terraform в GitLab. После выполнения terraform требуется выполнить инструкции из папки gitops  
2. При установлении тэга на коммит автоматически начинается сборка контейнера с этим тегом. Выбор контейнера производится по сообщению коммита.  
   пр. ( Устанавливаем tag = v0.0.3 на коммит у которого message = 'имя целевого контейнера' ). Автоматически контейнер собирётся и загрузится в регистри.  
3. Обновление микросервиса производится сменой тэга в файле gitops/istio/releases/nameservice или через helm upgrade в deploy/chart
4. Flagger - canary deploy:
```kubectl get canaries -n develop```    
```NAME       STATUS        WEIGHT   LASTTRANSITIONTIME```   
```frontend   Initialized   0        2023-12-01T14:31:40Z```    

```kubectl describe canaries -n develop```    
```Name:         frontend```    
```Namespace:    develop```    
```Events:```    
```Type     Reason  Age                From     Message```    
```----     ------  ----               ----     -------```    
```Normal   Synced  28m                flagger  Initialization done! frontend.develop```  
  