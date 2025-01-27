## Terraform Overview

[Video](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)

### Concepts

#### Introduction

1. What is [Terraform](https://www.terraform.io)?
   * open-source tool by [HashiCorp](https://www.hashicorp.com), used for provisioning infrastructure resources
   * supports DevOps best practices for change management
   * Managing configuration files in source control to maintain an ideal provisioning state 
     for testing and production environments
2. What is IaC?
   * Infrastructure-as-Code
   * build, change, and manage your infrastructure in a safe, consistent, and repeatable way 
     by defining resource configurations that you can version, reuse, and share.
3. Some advantages
   * Infrastructure lifecycle management
   * Version control commits
   * Very useful for stack-based deployments, and with cloud providers such as AWS, GCP, Azure, K8S…
   * State-based approach to track resource changes throughout deployments


#### Files

* `main.tf`
* `variables.tf`
* Optional: `resources.tf`, `output.tf`
* `.tfstate`

#### Declarations
* `terraform`: configure basic Terraform settings to provision your infrastructure
   * `required_version`: minimum Terraform version to apply to your configuration
   * `backend`: stores Terraform's "state" snapshots, to map real-world resources to your configuration.
      * `local`: stores state file locally as `terraform.tfstate`
   * `required_providers`: specifies the providers required by the current module
* `provider`:
   * adds a set of resource types and/or data sources that Terraform can manage
   * The Terraform Registry is the main directory of publicly available providers from most major infrastructure platforms.
* `resource`
  * blocks to define components of your infrastructure
  * Project modules/resources: google_storage_bucket, google_bigquery_dataset, google_bigquery_table
* `variable` & `locals`
  * runtime arguments and constants


#### Execution steps
1. `terraform init`: 
    * Initializes & configures the backend, installs plugins/providers, & checks out an existing configuration from a version control 
2. `terraform plan`:
    * Matches/previews local changes against a remote state, and proposes an Execution Plan.
3. `terraform apply`: 
    * Asks for approval to the proposed plan, and applies changes to cloud
4. `terraform destroy`
    * Removes your stack from the Cloud


### Terraform Workshop to create GCP Infra
Continue [here](./terraform): `week_1_basics_n_setup/1_terraform_gcp/terraform`


### References
https://learn.hashicorp.com/collections/terraform/gcp-get-started
## Огляд Terraform

[Відео](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)

### Концепції

#### Вступ

1. Що таке [Terraform](https://www.terraform.io)?
    * інструмент з відкритим вихідним кодом від [HashiCorp](https://www.hashicorp.com), який використовується для постачання ресурсів інфраструктури
    * підтримує найкращі практики DevOps для керування змінами
    * Керування конфігураційними файлами в системі контролю версій для підтримки ідеального стану постачання для тестових та виробничих середовищ
2. Що таке IaC?
    * Інфраструктура як код
    * Створення, зміна та керування інфраструктурою безпечно, послідовно та повторно, визначаючи конфігурації ресурсів, які можна версіонувати, повторно використовувати та ділитися.
3. Деякі переваги
    * Керування життєвим циклом інфраструктури
    * Коміти контролю версій
    * Дуже корисно для розгортання на основі стеків, а також з хмарними провайдерами, такими як AWS, GCP, Azure, K8S…
    * Підхід на основі стану для відстеження змін ресурсів під час розгортань

#### Файли

* `main.tf`
* `variables.tf`
* Додатково: `resources.tf`, `output.tf`
* `.tfstate`

#### Оголошення
* `terraform`: конфігурація основних налаштувань Terraform для постачання інфраструктури
    * `required_version`: мінімальна версія Terraform для застосування до вашої конфігурації
    * `backend`: зберігає знімки "стану" Terraform для відображення реальних ресурсів на вашу конфігурацію.
        * `local`: зберігає файл стану локально як `terraform.tfstate`
    * `required_providers`: визначає провайдерів, необхідних для поточного модуля
* `provider`:
    * додає набір типів ресурсів та/або джерел даних, якими Terraform може керувати
    * Terraform Registry — це головний каталог публічно доступних провайдерів від більшості основних платформ інфраструктури.
* `resource`
    * блоки для визначення компонентів вашої інфраструктури
    * Модулі/ресурси проєкту: google_storage_bucket, google_bigquery_dataset, google_bigquery_table
* `variable` & `locals`
    * аргументи під час виконання та константи

#### Кроки виконання
1. `terraform init`:
    * Ініціалізує та налаштовує backend, встановлює плагіни/провайдери та перевіряє існуючу конфігурацію з системи контролю версій
2. `terraform plan`:
    * Співвідносить/переглядає локальні зміни з віддаленим станом і пропонує план виконання.
3. `terraform apply`:
    * Запитує підтвердження запропонованого плану і застосовує зміни до хмари
4. `terraform destroy`
    * Видаляє ваш стек з хмари

### Семінар Terraform для створення інфраструктури GCP
Продовжуйте [тут](./terraform): `week_1_basics_n_setup/1_terraform_gcp/terraform`

### Джерела
https://learn.hashicorp.com/collections/terraform/gcp-get-started