{% test assert_pickup_datetime_year(model, column_name, year_to_check) %}
  select
    {{ column_name }}
  from {{ model }}
  where extract(year from {{ column_name }}) != {{ year_to_check }}
{% endtest %}