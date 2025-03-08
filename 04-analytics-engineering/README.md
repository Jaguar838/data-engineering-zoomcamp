# Модуль 4: Аналітична інженерія
**Мета:** Трансформування даних, завантажених у DWH, в аналітичні представлення, розробка [проєкту dbt](taxi_rides_ny/README.md).

### Передумови
На цьому етапі курсу ви вже повинні мати:

- Запущений сховище даних (BigQuery або Postgres).
- Набір працюючих конвеєрів, які завантажують набір даних проєкту (тиждень 3 завершено).
- Наступні набори даних, завантажені з [переліку наборів даних курсу](https://github.com/DataTalksClub/nyc-tlc-data/):
  * Дані жовтих таксі – 2019 та 2020 роки.
  * Дані зелених таксі – 2019 та 2020 роки.
  * Дані FHV – 2019 рік.

> **Примітка:**  
> *Є два швидкі способи завантажити ці дані. Подивіться [це відео](https://www.youtube.com/watch?v=Mork172sK_c&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs) для першого варіанту або дотримуйтеся інструкцій у [week3/extras](../03-data-warehouse/extras) для другого.*

## Налаштування середовища

> **Примітка:**  
> *Рекомендований варіант – налаштування в хмарі.*
>
> *Локальне налаштування не потребує хмарної бази даних.*

| Альтернатива A | Альтернатива B |  
|---|---|  
| Налаштування dbt для BigQuery (хмара) | Налаштування dbt для Postgres (локально) |  
|- Зареєструйте безкоштовний обліковий запис dbt cloud за [цим посиланням](https://www.getdbt.com/signup/). |- Зареєструйте безкоштовний обліковий запис dbt cloud за [цим посиланням](https://www.getdbt.com/signup/). |  
| - [Дотримуйтесь інструкцій для підключення до BigQuery](https://docs.getdbt.com/guides/bigquery?step=4). | - Виконайте інструкції з [офіційної документації dbt](https://docs.getdbt.com/docs/core/installation) або <br>- використовуйте [dbt core з BigQuery у Docker](docker_setup/README.md) для локального запуску, або <br>- використовуйте офіційний [образ Docker](https://docs.getdbt.com/docs/core/docker-install). |  
|- Більш детальні інструкції у [dbt_cloud_setup.md](dbt_cloud_setup.md).  | - Вам потрібно встановити останню версію з адаптером для BigQuery (dbt-bigquery). |  
| | - Вам потрібно встановити останню версію з адаптером для Postgres (dbt-postgres). |  
| | - Після локального встановлення необхідно налаштувати з'єднання з Postgres у файлі `profiles.yml`. Шаблони можна знайти [тут](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup). |  

## Зміст

### Вступ до аналітичної інженерії
- Що таке аналітична інженерія?
- ETL vs ELT
- Концепції моделювання даних (факт та вимірювальні таблиці)

[![](https://markdown-videos-api.jorgenkh.no/youtube/uF76d5EmdtU)](https://youtu.be/uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=40)

### Що таке dbt?
- Вступ до dbt

[![](https://markdown-videos-api.jorgenkh.no/youtube/4eCouvVOJUw)](https://www.youtube.com/watch?v=gsKuETFJr54&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=5)

## Початок роботи з проєктом dbt

| Альтернатива A  | Альтернатива B   |  
|---|---|  
| Використання BigQuery + dbt cloud | Використання Postgres + dbt core (локально) |  
| - Створення нового проєкту за допомогою `dbt init` (dbt cloud та core). <br>- Налаштування dbt cloud. <br>- Файл `project.yml`. | - Створення нового проєкту за допомогою `dbt init` (dbt cloud та core). <br>- Локальне налаштування dbt core. <br>- Файли `profiles.yml` та `project.yml`. |  
| [![](https://markdown-videos-api.jorgenkh.no/youtube/iMxh6s_wL4Q)](https://www.youtube.com/watch?v=J0XCDyKiU64&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=4) | [![](https://markdown-videos-api.jorgenkh.no/youtube/1HmL63e-vRs)](https://youtu.be/1HmL63e-vRs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=43) |  

### Моделі dbt
- Анатомія моделі dbt: вихідний код vs скомпільований
- Матеріалізації: `table`, `view`, `incremental`, `ephemeral`
- Seeds, sources та `ref`
- Jinja та Macros
- Пакети
- Змінні

[![](https://markdown-videos-api.jorgenkh.no/youtube/UVI30Vxzd6c)](https://www.youtube.com/watch?v=ueVy2N54lyc&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=3)

> **Примітка:**  
> *Це відео демонструється у dbt cloud IDE, але ті ж самі кроки можна виконати локально у вибраному IDE.*

### Тестування та документування моделей dbt
- Тести
- Документація

[![](https://markdown-videos-api.jorgenkh.no/youtube/UishFmq1hLM)](https://www.youtube.com/watch?v=2dNJXHFCHaY&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=2)

## Деплоймент

| Альтернатива A  | Альтернатива B   |  
|---|---|  
| Використання BigQuery + dbt cloud | Використання Postgres + dbt core (локально) |  
| - Деплоймент: середовище розробки vs продакшен. <br>- dbt cloud: планувальник, джерела та розміщена документація. | - Деплоймент: середовище розробки vs продакшен. <br>- dbt cloud: планувальник, джерела та розміщена документація. |  
| [![](https://markdown-videos-api.jorgenkh.no/youtube/rjf6yZNGX8I)](https://www.youtube.com/watch?v=V2m5C0n8Gro&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=6) | [![](https://markdown-videos-api.jorgenkh.no/youtube/Cs9Od1pcrzM)](https://youtu.be/Cs9Od1pcrzM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=47) |  

## Візуалізація трансформованих даних
- **Google Looker Studio**
- **Metabase**

---
