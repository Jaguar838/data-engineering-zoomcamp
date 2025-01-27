### Concepts
* [Terraform_overview](../1_terraform_overview.md)

### Execution

```shell
# Refresh service-account's auth-token for this session
gcloud auth application-default login

# Initialize state file (.tfstate)
terraform init

# Check changes to new infra plan
terraform plan -var="project=<your-gcp-project-id>"
```

```shell
# Create new infra
terraform apply -var="project=<your-gcp-project-id>"
```

```shell
# Delete infra after your work, to avoid costs on any running services
terraform destroy
```

### Концепції
* [Огляд Terraform](../1_terraform_overview.md)

### Виконання

```shell  
# Оновлення auth-токена для облікового запису служби на цю сесію  
gcloud auth application-default login  

# Ініціалізація файлу стану (.tfstate)  
terraform init  

# Перевірка змін у новому плані інфраструктури  
terraform plan -var="project=<your-gcp-project-id>"  
```  

```shell  
# Створення нової інфраструктури  
terraform apply -var="project=<your-gcp-project-id>"  
```  

```shell  
# Видалення інфраструктури після завершення роботи, щоб уникнути витрат на працюючі сервіси  
terraform destroy  
```  