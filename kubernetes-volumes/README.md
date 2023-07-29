# Выполнено ДЗ №4

ДЗ выполняется в "kind create cluster"

```kubectl apply -f minio-statefulset.yaml```

Запуститься под с MinIO
Создаться PVC
Динамически создаться PV на этом PVC с помощью дефолотного StorageClass

Для того, чтобы StatefulSet был доступен изнутри кластера:
```kubectl apply -f minio-headlessservice.yaml```

С целью скрыть секреты в "statefulset" создан файл "minio-secret.yaml"

# PV - PVC - POD
```kubectl apply -f my-pv.yaml```
```kubectl apply -f my-pvc.yaml```
```kubectl apply -f my-pod.yaml```

После рестарта или удаления пода данные сохраняются.