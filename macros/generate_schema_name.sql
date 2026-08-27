{% macro generate_schema_name(custom_schema_name, node) -%}
    {#
        dbt normally concatenates target.schema and custom schemas. This project
        owns exact PostgreSQL schemas named staging, intermediate, and marts, so
        configured custom schemas are used directly while unconfigured models
        still fall back to target.schema.
    #}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
