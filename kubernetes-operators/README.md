### Домашнее задание №7

```kubectl apply -f deploy/crd.yml```

```kubectl apply -f deploy/cr.yml```

# В папке build созданы фйлы для контроллера. Создание контроллера производится следующей командой:
```kopf run mysql-operator.py &``` # Запускается как процесс и висит fg по это причине добавлен &

# Проверим, что все работает, для этого заполним базу созданного mysqlinstanc:

```export MYSQLPOD=$(kubectl get pods -l app=mysql-instance -o jsonpath="{.items[*].metadata.name}")```  

```kubectl exec -it $MYSQLPOD -- mysql -u root -potuspassword -e "CREATE TABLE test (id smallint unsigned not null auto_increment, name varchar(20) not null, constraint pk_example primary key (id) );" otus-database```


```kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "INSERT INTO test ( id, name) VALUES ( null, 'some data' );" otus-database```

```kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "INSERT INTO test ( id, name ) VALUES ( null, 'some data-2' );" otus-database```

# Посмотрим что создали. Должна появиться таблица.
```kubectl exec -it $MYSQLPOD -- mysql -potuspassword -e "select * from test;" otus-database``` 

+----+-------------+  
| id | name        |  
+----+-------------+  
|  1 | some data   |  
|  2 | some data-2 |  
+----+-------------+  

# Удалим mysql-instance:
```kubectl delete mysqls.otus.homework mysql-instance```

# Создадим снова и проверим что старая таблица восстановилась
```kubectl apply -f deploy/cr.yml```

# Проверка того как отработалди jobs
```kubectl get job```

# Результат

NAME                         COMPLETIONS   DURATION   AGE  
backup-mysql-instance-job    1/1           8s         20m  
restore-mysql-instance-job   1/1           70s        7m40s  


