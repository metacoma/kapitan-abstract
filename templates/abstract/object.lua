{% set class_name = class_type | title %}
{% set have_schema = schema_keyword in p[class_type] %}
local {{ class_name }} = {}
{{ class_name }}.__index = {{ class_name }}

local {{ class_name }}_raw = rapidjson.decode('{{ p[class_type] | to_json }}')

{% if have_schema %}
local {{ class_name }}_schema = {{ class_name }}_raw["{{ schema_keyword }}"]
-- override type defintion if it is not present in jsonschema
if ({{ class_name }}_schema["properties"]["type"] == nil) then
  {{ class_name }}_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "{{ class_type }}" }
  }
end
local {{ class_name }}_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document({{ class_name }}_schema)))
{% endif %}
local {{ class_name }}_properties = {{ class_name }}_raw
{{ class_name }}_properties["{{ schema_keyword }}"] = nil

function new_{{ class_name }}(properties) 
  if (properties == nil) then
    properties = {}
  end
  return {{ class_name }}.new(properties)
end

function {{ class_name }}.new(properties) 
  local self = setmetatable({}, {{ class_name }})
  local ok, message = true, nil
   

  {{ class_name }}_properties["type"] = "{{ class_type }}"

  local merged_properties = table_merge(
        {{ class_name }}_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
{% if have_schema %}
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint({{ class_name }}_schema)
    assert(ok, message)
  end
{% endif %}

  return self
end

{% if have_schema %}
function {{ class_name }}.__validate(self, value) 
  assert(type(value) == "table", "function {{ class_name }}.__validate accepts only table in argument")
  return {{ class_name }}_schema_validator:validate(rapidjson.Document(value)) 
end
{% endif %}


function {{ class_name }}.__set_properties(self, value)
  local ok, message = true, nil
{% if schema_keyword in p[class_type] %}
  ok, message = self:__validate(value)  
{% endif %}
  self.properties = value
  return ok, message
end


function {{ class_name }}.__get_properties(self)
  return self.properties
end


function {{ class_name }}.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function {{ class_name }}.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

{% for prop in p[class_type] %}
  {% set prop_have_schema = have_schema and "properties" in p[class_type][schema_keyword] and prop in p[class_type][schema_keyword].properties %}
  {% if prop != schema_keyword %}
    {% if prop_have_schema %}
function {{ class_name }}.get_{{ prop }}_validator(self)
  return {{ class_name }}_schema
end
    {% endif %}
function {{ class_name }}.set_{{ prop }}(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("{{ prop }}", value)
    {% if prop_have_schema %}
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_{{ prop }}_validator())
]]--

  if ok ~= true then
    pprint(self:get_{{ prop }}_validator())
    assert(ok, message)
  end
    {% endif %}
end
function {{ class_name }}.get_{{ prop }}(self)
  return self:get_property("{{ prop }}")
end
  {% endif %} {# prop != schema_keyword #}
{% endfor %}
