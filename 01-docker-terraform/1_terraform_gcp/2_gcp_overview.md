## GCP Overview

[Video](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)


### Project infrastructure modules in GCP:
* Google Cloud Storage (GCS): Data Lake
* BigQuery: Data Warehouse

(Concepts explained in Week 2 - Data Ingestion)

### Initial Setup

For this course, we'll use a free version (upto EUR 300 credits). 

1. Create an account with your Google email ID 
2. Setup your first [project](https://console.cloud.google.com/) if you haven't already
    * eg. "DTC DE Course", and note down the "Project ID" (we'll use this later when deploying infra with TF)
3. Setup [service account & authentication](https://cloud.google.com/docs/authentication/getting-started) for this project
    * Grant `Viewer` role to begin with.
    * Download service-account-keys (.json) for auth.
4. Download [SDK](https://cloud.google.com/sdk/docs/quickstart) for local setup
5. Set environment variable to point to your downloaded GCP keys:
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   
   # Refresh token/session, and verify authentication
   gcloud auth application-default login
   ```
   
### Setup for Access
 
1. [IAM Roles](https://cloud.google.com/storage/docs/access-control/iam-roles) for Service account:
   * Go to the *IAM* section of *IAM & Admin* https://console.cloud.google.com/iam-admin/iam
   * Click the *Edit principal* icon for your service account.
   * Add these roles in addition to *Viewer* : **Storage Admin** + **Storage Object Admin** + **BigQuery Admin**
   
2. Enable these APIs for your project:
   * https://console.cloud.google.com/apis/library/iam.googleapis.com
   * https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com
   
3. Please ensure `GOOGLE_APPLICATION_CREDENTIALS` env-var is set.
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   ```
 
### Terraform Workshop to create GCP Infra
Continue [here](./terraform): `week_1_basics_n_setup/1_terraform_gcp/terraform`
## Огляд GCP

[Відео](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)

### Інфраструктурні модулі проєкту в GCP:
* Google Cloud Storage (GCS): Data Lake
* BigQuery: Data Warehouse

(Поняття пояснюються у 2-му тижні - Заливання даних)

### Початкове налаштування

Для цього курсу ми будемо використовувати безкоштовну версію (до 300 євро кредитів).

1. Створіть обліковий запис із вашим Google email ID.
2. Налаштуйте свій перший [проєкт](https://console.cloud.google.com/), якщо ще не зробили цього:
   * Наприклад, "DTC DE Course", і запишіть "Project ID" (ми використаємо його пізніше для розгортання інфраструктури за допомогою TF).
3. Налаштуйте [обліковий запис сервісу та автентифікацію](https://cloud.google.com/docs/authentication/getting-started) для цього проєкту:
   * Спершу призначте роль `Viewer`.
   * Завантажте ключі облікового запису сервісу (.json) для автентифікації.
4. Завантажте [SDK](https://cloud.google.com/sdk/docs/quickstart) для локального налаштування.
5. Встановіть змінну середовища, щоб вказати шлях до завантажених ключів GCP:
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   
   # Оновіть токен/сесію та перевірте автентифікацію
   gcloud auth application-default login
   ```

### Налаштування доступу

1. [IAM Ролі](https://cloud.google.com/storage/docs/access-control/iam-roles) для облікового запису сервісу:
   * Перейдіть до розділу *IAM* у *IAM & Admin*: https://console.cloud.google.com/iam-admin/iam
   * Натисніть на іконку *Edit principal* для вашого облікового запису сервісу.
   * Додайте наступні ролі на додачу до *Viewer*: **Storage Admin** + **Storage Object Admin** + **BigQuery Admin**.

2. Увімкніть наступні API для вашого проєкту:
   * https://console.cloud.google.com/apis/library/iam.googleapis.com
   * https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com

3. Переконайтеся, що змінна середовища `GOOGLE_APPLICATION_CREDENTIALS` встановлена:
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   ```

### Воркшоп Terraform для створення інфраструктури GCP
Продовжуйте [тут](./terraform): `week_1_basics_n_setup/1_terraform_gcp/terraform`