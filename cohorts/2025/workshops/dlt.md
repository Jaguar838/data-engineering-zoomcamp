
# Data ingestion with dlt

Sign up here: https://lu.ma/quyfn4q8 (optional)

Details TBA

**dlt (data load tool)** — це інструмент для **екстракції, завантаження та трансформації даних (ELT)**, який спрощує інтеграцію з різними джерелами даних, такими як API, бази даних, файли та хмарні сервіси.

### **Навіщо потрібне dlt?**
dlt допомагає **автоматизувати процес завантаження даних** у сховища, такі як **DuckDB, BigQuery, Redshift, Snowflake** тощо. Основні сценарії використання:

🔹 **Збирання даних із API** (наприклад, щогодинне завантаження інформації про поїздки таксі).  
🔹 **Обробка великих обсягів даних** у масштабованих аналітичних системах.  
🔹 **Автоматичне оновлення** баз даних із новими записами.  
🔹 **Проста інтеграція з Python**, без складного конфігурування ETL-конвеєрів.

### **Основні можливості dlt**
✅ **Автоматична пагінація API** (отримання всіх сторінок даних без ручної роботи).  
✅ **Гнучке завантаження в різні сховища** (DuckDB, BigQuery, Snowflake тощо).  
✅ **Вбудована підтримка трансформацій** (перетворення даних перед завантаженням).  
✅ **Проста настройка через Python-код** (без складних налаштувань).

### **Приклад коду на Python**
Ось як можна витягнути дані з API та завантажити в **DuckDB** за допомогою dlt:

```python
import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.paginators import PageNumberPaginator

# Налаштування API-клієнта
client = RESTClient(
    "https://api.example.com/data",
    paginator=PageNumberPaginator()
)

# Опис ресурсу API
@dlt.resource
def get_data():
    yield from client

# Налаштування конвеєра (pipeline)
pipeline = dlt.pipeline(
    pipeline_name="example_pipeline",
    destination="duckdb",
    dataset_name="example_data"
)

# Запуск завантаження
load_info = pipeline.run(get_data)
print(load_info)
```

Таким чином, **dlt автоматизує збір, обробку та завантаження даних**, що особливо корисно в проєктах **Data Engineering та Data Analytics**. 🚀
