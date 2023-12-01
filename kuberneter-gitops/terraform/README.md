# Настройка terraform

```yc init```  
```export YC_TOKEN=$(yc iam create-token)```     
```export TF_VAR_FOLDER_ID=$(yc config get folder-id)```  

### Открыть файл на редактирование
```vi ~/.terraformrc```  

### И записать настройки провайдера яндекс:    

```provider_installation {```  
```  network_mirror {```  
```    url = "https://terraform-mirror.yandexcloud.net/"```  
```    include = ["registry.terraform.io/*/*"]```  
```  }```  
```  direct {```  
```    exclude = ["registry.terraform.io/*/*"]```  
```  }```  
```}```  

### Далее выполняем init. Проект использует "backend gitlab" для синхронизации состояния terraform  

```GITLAB_ACCESS_TOKEN=```  
```terraform init -backend-config="address=https://gitlab.com/api/v4/projects/50800490/terraform/state/infra_state" -backend-config="lock_address=https://gitlab.com/api/v4/projects/50800490/terraform/state/infra_state/lock" -backend-config="unlock_address=https://gitlab.com/api/v4/projects/50800490/terraform/state/infra_state/lock" -backend-config="username=daniilrostov" -backend-config="password=$GITLAB_ACCESS_TOKEN" -backend-config="lock_method=POST" -backend-config="unlock_method=DELETE" -backend-config="retry_wait_min=5"```  

```terraform plan -var-file="vars.tfvars"```  
```terraform apply -var FOLDER_ID=$TF_VAR_FOLDER_ID -var region=$region -lock=false -auto-approve```  

### Для настройки kubectl  
```yc managed-kubernetes cluster get-credentials --name kurs --external --force```  

### Удаление кластера  
```terraform destroy -var-file="vars.tfvars" -var FOLDER_ID=$(yc config get folder-id) -lock=false -auto-approve```  
