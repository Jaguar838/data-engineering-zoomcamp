## GCP and Terraform on Windows

You don't need these instructions if you use WSL. It's only for "plain Windows" 

### Google Cloud SDK

* For this tutorial, you'll need a Linux-like environment, e.g. [GitBash](https://gitforwindows.org/), [MinGW](https://www.mingw-w64.org/) or [cygwin](https://www.cygwin.com/)
  * Power Shell should also work, but will require adjustments 
* Download SDK in zip: https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
  * source: https://cloud.google.com/sdk/docs/downloads-interactive
* Unzip it and run the `install.sh` script

When installing it, you might see something like that:

```
The installer is unable to automatically update your system PATH. Please add
  C:\tools\google-cloud-sdk\bin
```

* To fix that, adjust your `.bashrc` to include this in `PATH` ([instructions](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path))
* You can also do it system-wide ([instructions](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7))

Now we need to point it to correct Python installation. Assuming you use [Anaconda](https://www.anaconda.com/products/individual):

```bash
export CLOUDSDK_PYTHON=~/Anaconda3/python
```

Now let's check that it works:

```bash
$ gcloud version
Google Cloud SDK 367.0.0
bq 2.0.72
core 2021.12.10
gsutil 5.5
```

### Google Cloud SDK Authentication 

* Now create a service account and generate keys like shown in the videos
* Download the key and put it to some location, e.g. `.gc/ny-rides.json`
* Set `GOOGLE_APPLICATION_CREDENTIALS` to point to the file

```bash
export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/ny-rides.json
```

Now authenticate: 

```bash
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
```

Alternatively, you can authenticate using OAuth like shown in the video

```bash
gcloud auth application-default login
```

If you get a message like `quota exceeded`

> WARNING:
> Cannot find a quota project to add to ADC. You might receive a "quota exceeded" or "API not enabled" error. 
> Run `$ gcloud auth application-default set-quota-project` to add a quota project.

Then run this:

```bash
PROJECT_NAME="ny-rides-alexey"
gcloud auth application-default set-quota-project ${PROJECT_NAME}
```


### Terraform 

* [Download Terraform](https://www.terraform.io/downloads)
* Put it to a folder in [PATH](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7)
* Go to the location with Terraform files and initialize it

```bash
terraform init
```

Optionally you can configure your terraform files (`variables.tf`) to include your project id:

```bash
variable "project" {
  description = "Your GCP Project ID"
  default = "ny-rides-alexey"
  type = string
}
```

* Now [follow the instructions](1_terraform_overview.md#execution-steps)
  * Run `terraform plan`
  * Next, run `terraform apply`

If you get an error like that:

> Error: googleapi: Error 403: terraform@ny-rides-alexey.iam.gserviceaccount.com does not have
> storage.buckets.create access to the Google Cloud project., forbidden


Then you need to give your service account all the permissions. Make sure you follow the instructions in the videos 

* You can also use [this file](https://docs.google.com/document/d/e/2PACX-1vSZapy7gIj0TP-EFzub2OpAlAkuifGEVJ4XpkA1RvxZ45NjiQi29b6OhLuetdXXHWAn2lbbKxnbzMdd/pub), but it doesn't list all the required permissions
## GCP і Terraform на Windows

Ці інструкції не потрібні, якщо ви використовуєте WSL. Вони призначені лише для "чистого Windows".

### Google Cloud SDK

* Для цього уроку вам знадобиться середовище, схоже на Linux, наприклад [GitBash](https://gitforwindows.org/), [MinGW](https://www.mingw-w64.org/) або [cygwin](https://www.cygwin.com/).
  * PowerShell також може працювати, але потребуватиме налаштувань.
* Завантажте SDK у zip-форматі: https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
  * Джерело: https://cloud.google.com/sdk/docs/downloads-interactive
* Розпакуйте архів і запустіть скрипт `install.sh`.

Під час встановлення ви можете побачити щось подібне:

```
The installer is unable to automatically update your system PATH. Please add
  C:\tools\google-cloud-sdk\bin
```

* Щоб це виправити, налаштуйте `.bashrc`, додавши до нього `PATH` ([інструкція](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path)).
* Ви також можете налаштувати це системно ([інструкція](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7)).

Тепер потрібно вказати правильну Python-інсталяцію. Припускаємо, що ви використовуєте [Anaconda](https://www.anaconda.com/products/individual):

```bash
export CLOUDSDK_PYTHON=~/Anaconda3/python
```

Тепер перевірте, чи все працює:

```bash
$ gcloud version
Google Cloud SDK 367.0.0
bq 2.0.72
core 2021.12.10
gsutil 5.5
```

### Аутентифікація Google Cloud SDK

* Створіть обліковий запис сервісу та згенеруйте ключі, як показано у відео.
* Завантажте ключ і розмістіть його в потрібному місці, наприклад `.gc/ny-rides.json`.
* Вкажіть `GOOGLE_APPLICATION_CREDENTIALS`, щоб посилатися на цей файл:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/ny-rides.json
```

Тепер аутентифікуйтеся:

```bash
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
```

Альтернативно, можна пройти аутентифікацію через OAuth, як показано у відео:

```bash
gcloud auth application-default login
```

Якщо ви отримали повідомлення типу `quota exceeded`:

> WARNING:  
> Cannot find a quota project to add to ADC. You might receive a "quota exceeded" or "API not enabled" error.  
> Run `$ gcloud auth application-default set-quota-project` to add a quota project.

Виконайте цю команду:

```bash
PROJECT_NAME="ny-rides-alexey"
gcloud auth application-default set-quota-project ${PROJECT_NAME}
```

### Terraform

* [Завантажте Terraform](https://www.terraform.io/downloads).
* Помістіть його в папку, яка знаходиться в [PATH](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7).
* Перейдіть у папку з файлами Terraform і ініціалізуйте його:

```bash
terraform init
```

За бажанням ви можете налаштувати файли Terraform (`variables.tf`), додавши ідентифікатор проєкту:

```hcl
variable "project" {
  description = "Your GCP Project ID"
  default = "ny-rides-alexey"
  type = string
}
```

* Далі [дотримуйтеся інструкцій](1_terraform_overview.md#execution-steps):
  * Запустіть `terraform plan`.
  * Потім запустіть `terraform apply`.

Якщо виникла помилка, наприклад:

> Error: googleapi: Error 403: terraform@ny-rides-alexey.iam.gserviceaccount.com does not have  
> storage.buckets.create access to the Google Cloud project., forbidden

Тоді вам потрібно надати обліковому запису сервісу всі необхідні дозволи. Переконайтеся, що дотрималися інструкцій із відео.

* Ви також можете скористатися [цим файлом](https://docs.google.com/document/d/e/2PACX-1vSZapy7gIj0TP-EFzub2OpAlAkuifGEVJ4XpkA1RvxZ45NjiQi29b6OhLuetdXXHWAn2lbbKxnbzMdd/pub), але в ньому можуть бути не всі потрібні дозволи.