local rapidjson = require("rapidjson")
local lyaml = require("lyaml")
local pprint = require("pprint")
local jsonschema = require 'resty.ljsonschema'

function table_merge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                table_merge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

{% set p = inventory.parameters %}
{% set schema_keyword = "__schema" %}
{% set exclude_keys = [ "kapitan", "_reclass_"] %}
{% for k in p %}
  {% if k not in exclude_keys and "type" in p[k] %}
    {% with class_type = k, properties = p[k] %}
{% include "object.lua" %}
    {% endwith %}
  {% endif %}
{% endfor %}
