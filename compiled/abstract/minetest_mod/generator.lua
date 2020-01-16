-- local rapidjson = require("rapidjson")
local lyaml = require("lyaml")
local pprint = require("pprint")
local cjson = require("cjson")
local jsonschema = require('jsonschema')

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

local Object = {}
Object.__index = Object

-- local Object_raw = rapidjson.decode('{"type": "object", "foo": "bar", "bar": 42, "__schema": {"type": "object", "required": ["type"], "properties": {"type": {"type": "string", "enum": ["object"]}, "foo": {"type": "string"}, "bar": {"type": "number"}}}}')
local Object_raw = cjson.decode('{"type": "object", "foo": "bar", "bar": 42, "__schema": {"type": "object", "required": ["type"], "properties": {"type": {"type": "string", "enum": ["object"]}, "foo": {"type": "string"}, "bar": {"type": "number"}}}}')

local Object_schema = Object_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (Object_schema["properties"]["type"] == nil) then
  Object_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "object" }
  }
end
--local Object_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(Object_schema)))
--pprint(Object_schema)
local Object_schema_validator = jsonschema.generate_validator(Object_schema)

local Object_properties = Object_raw
Object_properties["__schema"] = nil

function new_Object(properties) 
  if (properties == nil) then
    properties = {}
  end
  return Object.new(properties)
end

function Object.new(properties) 
  local self = setmetatable({}, Object)
  local ok, message = true, nil
   

  Object_properties["type"] = "object"

  local merged_properties = table_merge(
        Object_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(Object_schema)
    assert(ok, message)
  end

  return self
end

function Object.__validate(self, value) 
  assert(type(value) == "table", "function Object.__validate accepts only table in argument")
  return Object_schema_validator(value) 
end


function Object.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function Object.__get_properties(self)
  return self.properties
end


function Object.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function Object.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function Object.get_type_validator(self)
  return Object_schema
end
function Object.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function Object.get_type(self)
  return self:get_property("type")
end
 function Object.get_foo_validator(self)
  return Object_schema
end
function Object.set_foo(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("foo", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_foo_validator())
]]--

  if ok ~= true then
    pprint(self:get_foo_validator())
    assert(ok, message)
  end
end
function Object.get_foo(self)
  return self:get_property("foo")
end
 function Object.get_bar_validator(self)
  return Object_schema
end
function Object.set_bar(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("bar", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_bar_validator())
]]--

  if ok ~= true then
    pprint(self:get_bar_validator())
    assert(ok, message)
  end
end
function Object.get_bar(self)
  return self:get_property("bar")
end
  local L1_port = {}
L1_port.__index = L1_port

-- local L1_port_raw = rapidjson.decode('{"type": "l1_port", "name": "port 1", "L1": {"type": null, "link": null, "modes": []}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}}}}')
local L1_port_raw = cjson.decode('{"type": "l1_port", "name": "port 1", "L1": {"type": null, "link": null, "modes": []}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}}}}')

local L1_port_schema = L1_port_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (L1_port_schema["properties"]["type"] == nil) then
  L1_port_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "l1_port" }
  }
end
--local L1_port_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(L1_port_schema)))
--pprint(L1_port_schema)
local L1_port_schema_validator = jsonschema.generate_validator(L1_port_schema)

local L1_port_properties = L1_port_raw
L1_port_properties["__schema"] = nil

function new_L1_port(properties) 
  if (properties == nil) then
    properties = {}
  end
  return L1_port.new(properties)
end

function L1_port.new(properties) 
  local self = setmetatable({}, L1_port)
  local ok, message = true, nil
   

  L1_port_properties["type"] = "l1_port"

  local merged_properties = table_merge(
        L1_port_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(L1_port_schema)
    assert(ok, message)
  end

  return self
end

function L1_port.__validate(self, value) 
  assert(type(value) == "table", "function L1_port.__validate accepts only table in argument")
  return L1_port_schema_validator(value) 
end


function L1_port.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function L1_port.__get_properties(self)
  return self.properties
end


function L1_port.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function L1_port.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function L1_port.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
end
function L1_port.get_type(self)
  return self:get_property("type")
end
 function L1_port.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
end
function L1_port.get_name(self)
  return self:get_property("name")
end
 function L1_port.get_L1_validator(self)
  return L1_port_schema
end
function L1_port.set_L1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("L1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_L1_validator())
]]--

  if ok ~= true then
    pprint(self:get_L1_validator())
    assert(ok, message)
  end
end
function L1_port.get_L1(self)
  return self:get_property("L1")
end
  local L1_100m_port = {}
L1_100m_port.__index = L1_100m_port

-- local L1_100m_port_raw = rapidjson.decode('{"type": "l1_100m_port", "name": "port 1", "L1": {"type": "ethernet", "link": null, "modes": ["10BASE-T", "100BASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}}')
local L1_100m_port_raw = cjson.decode('{"type": "l1_100m_port", "name": "port 1", "L1": {"type": "ethernet", "link": null, "modes": ["10BASE-T", "100BASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}}')

local L1_100m_port_schema = L1_100m_port_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (L1_100m_port_schema["properties"]["type"] == nil) then
  L1_100m_port_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "l1_100m_port" }
  }
end
--local L1_100m_port_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(L1_100m_port_schema)))
--pprint(L1_100m_port_schema)
local L1_100m_port_schema_validator = jsonschema.generate_validator(L1_100m_port_schema)

local L1_100m_port_properties = L1_100m_port_raw
L1_100m_port_properties["__schema"] = nil

function new_L1_100m_port(properties) 
  if (properties == nil) then
    properties = {}
  end
  return L1_100m_port.new(properties)
end

function L1_100m_port.new(properties) 
  local self = setmetatable({}, L1_100m_port)
  local ok, message = true, nil
   

  L1_100m_port_properties["type"] = "l1_100m_port"

  local merged_properties = table_merge(
        L1_100m_port_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(L1_100m_port_schema)
    assert(ok, message)
  end

  return self
end

function L1_100m_port.__validate(self, value) 
  assert(type(value) == "table", "function L1_100m_port.__validate accepts only table in argument")
  return L1_100m_port_schema_validator(value) 
end


function L1_100m_port.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function L1_100m_port.__get_properties(self)
  return self.properties
end


function L1_100m_port.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function L1_100m_port.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function L1_100m_port.get_type_validator(self)
  return L1_100m_port_schema
end
function L1_100m_port.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function L1_100m_port.get_type(self)
  return self:get_property("type")
end
 function L1_100m_port.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
end
function L1_100m_port.get_name(self)
  return self:get_property("name")
end
 function L1_100m_port.get_L1_validator(self)
  return L1_100m_port_schema
end
function L1_100m_port.set_L1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("L1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_L1_validator())
]]--

  if ok ~= true then
    pprint(self:get_L1_validator())
    assert(ok, message)
  end
end
function L1_100m_port.get_L1(self)
  return self:get_property("L1")
end
  local L1_1g_port = {}
L1_1g_port.__index = L1_1g_port

-- local L1_1g_port_raw = rapidjson.decode('{"type": "l1_1g_port", "name": "port 1", "L1": {"type": "ethernet", "link": null, "modes": ["10BASE-T", "100BASE-T", "1000BASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}}')
local L1_1g_port_raw = cjson.decode('{"type": "l1_1g_port", "name": "port 1", "L1": {"type": "ethernet", "link": null, "modes": ["10BASE-T", "100BASE-T", "1000BASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}}')

local L1_1g_port_schema = L1_1g_port_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (L1_1g_port_schema["properties"]["type"] == nil) then
  L1_1g_port_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "l1_1g_port" }
  }
end
--local L1_1g_port_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(L1_1g_port_schema)))
--pprint(L1_1g_port_schema)
local L1_1g_port_schema_validator = jsonschema.generate_validator(L1_1g_port_schema)

local L1_1g_port_properties = L1_1g_port_raw
L1_1g_port_properties["__schema"] = nil

function new_L1_1g_port(properties) 
  if (properties == nil) then
    properties = {}
  end
  return L1_1g_port.new(properties)
end

function L1_1g_port.new(properties) 
  local self = setmetatable({}, L1_1g_port)
  local ok, message = true, nil
   

  L1_1g_port_properties["type"] = "l1_1g_port"

  local merged_properties = table_merge(
        L1_1g_port_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(L1_1g_port_schema)
    assert(ok, message)
  end

  return self
end

function L1_1g_port.__validate(self, value) 
  assert(type(value) == "table", "function L1_1g_port.__validate accepts only table in argument")
  return L1_1g_port_schema_validator(value) 
end


function L1_1g_port.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function L1_1g_port.__get_properties(self)
  return self.properties
end


function L1_1g_port.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function L1_1g_port.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function L1_1g_port.get_type_validator(self)
  return L1_1g_port_schema
end
function L1_1g_port.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function L1_1g_port.get_type(self)
  return self:get_property("type")
end
 function L1_1g_port.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
end
function L1_1g_port.get_name(self)
  return self:get_property("name")
end
 function L1_1g_port.get_L1_validator(self)
  return L1_1g_port_schema
end
function L1_1g_port.set_L1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("L1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_L1_validator())
]]--

  if ok ~= true then
    pprint(self:get_L1_validator())
    assert(ok, message)
  end
end
function L1_1g_port.get_L1(self)
  return self:get_property("L1")
end
  local L1_10g_port = {}
L1_10g_port.__index = L1_10g_port

-- local L1_10g_port_raw = rapidjson.decode('{"type": "l1_10g_port", "name": "port 1", "L1": {"type": "optic", "link": null, "modes": ["1000BASE-T", "10GBASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_10g_port"]}}}}')
local L1_10g_port_raw = cjson.decode('{"type": "l1_10g_port", "name": "port 1", "L1": {"type": "optic", "link": null, "modes": ["1000BASE-T", "10GBASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_10g_port"]}}}}')

local L1_10g_port_schema = L1_10g_port_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (L1_10g_port_schema["properties"]["type"] == nil) then
  L1_10g_port_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "l1_10g_port" }
  }
end
--local L1_10g_port_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(L1_10g_port_schema)))
--pprint(L1_10g_port_schema)
local L1_10g_port_schema_validator = jsonschema.generate_validator(L1_10g_port_schema)

local L1_10g_port_properties = L1_10g_port_raw
L1_10g_port_properties["__schema"] = nil

function new_L1_10g_port(properties) 
  if (properties == nil) then
    properties = {}
  end
  return L1_10g_port.new(properties)
end

function L1_10g_port.new(properties) 
  local self = setmetatable({}, L1_10g_port)
  local ok, message = true, nil
   

  L1_10g_port_properties["type"] = "l1_10g_port"

  local merged_properties = table_merge(
        L1_10g_port_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(L1_10g_port_schema)
    assert(ok, message)
  end

  return self
end

function L1_10g_port.__validate(self, value) 
  assert(type(value) == "table", "function L1_10g_port.__validate accepts only table in argument")
  return L1_10g_port_schema_validator(value) 
end


function L1_10g_port.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function L1_10g_port.__get_properties(self)
  return self.properties
end


function L1_10g_port.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function L1_10g_port.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function L1_10g_port.get_type_validator(self)
  return L1_10g_port_schema
end
function L1_10g_port.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function L1_10g_port.get_type(self)
  return self:get_property("type")
end
 function L1_10g_port.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
end
function L1_10g_port.get_name(self)
  return self:get_property("name")
end
 function L1_10g_port.get_L1_validator(self)
  return L1_10g_port_schema
end
function L1_10g_port.set_L1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("L1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_L1_validator())
]]--

  if ok ~= true then
    pprint(self:get_L1_validator())
    assert(ok, message)
  end
end
function L1_10g_port.get_L1(self)
  return self:get_property("L1")
end
  local L1_40g_port = {}
L1_40g_port.__index = L1_40g_port

-- local L1_40g_port_raw = rapidjson.decode('{"type": "l1_40g_port", "name": "port 1", "L1": {"type": "optic", "link": null, "modes": ["1000BASE-T", "10GBASE-T", "40GBASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_40g_port"]}}}}')
local L1_40g_port_raw = cjson.decode('{"type": "l1_40g_port", "name": "port 1", "L1": {"type": "optic", "link": null, "modes": ["1000BASE-T", "10GBASE-T", "40GBASE-T"]}, "__schema": {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_40g_port"]}}}}')

local L1_40g_port_schema = L1_40g_port_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (L1_40g_port_schema["properties"]["type"] == nil) then
  L1_40g_port_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "l1_40g_port" }
  }
end
--local L1_40g_port_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(L1_40g_port_schema)))
--pprint(L1_40g_port_schema)
local L1_40g_port_schema_validator = jsonschema.generate_validator(L1_40g_port_schema)

local L1_40g_port_properties = L1_40g_port_raw
L1_40g_port_properties["__schema"] = nil

function new_L1_40g_port(properties) 
  if (properties == nil) then
    properties = {}
  end
  return L1_40g_port.new(properties)
end

function L1_40g_port.new(properties) 
  local self = setmetatable({}, L1_40g_port)
  local ok, message = true, nil
   

  L1_40g_port_properties["type"] = "l1_40g_port"

  local merged_properties = table_merge(
        L1_40g_port_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(L1_40g_port_schema)
    assert(ok, message)
  end

  return self
end

function L1_40g_port.__validate(self, value) 
  assert(type(value) == "table", "function L1_40g_port.__validate accepts only table in argument")
  return L1_40g_port_schema_validator(value) 
end


function L1_40g_port.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function L1_40g_port.__get_properties(self)
  return self.properties
end


function L1_40g_port.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function L1_40g_port.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function L1_40g_port.get_type_validator(self)
  return L1_40g_port_schema
end
function L1_40g_port.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function L1_40g_port.get_type(self)
  return self:get_property("type")
end
 function L1_40g_port.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
end
function L1_40g_port.get_name(self)
  return self:get_property("name")
end
 function L1_40g_port.get_L1_validator(self)
  return L1_40g_port_schema
end
function L1_40g_port.set_L1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("L1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_L1_validator())
]]--

  if ok ~= true then
    pprint(self:get_L1_validator())
    assert(ok, message)
  end
end
function L1_40g_port.get_L1(self)
  return self:get_property("L1")
end
  local Switch = {}
Switch.__index = Switch

-- local Switch_raw = rapidjson.decode('{"type": "switch", "name": "basic switch", "port1": null, "__schema": {"type": "object", "properties": {"name": {"type": "string"}, "type": {"type": "string", "enum": ["switch"]}, "port1": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}}}}')
local Switch_raw = cjson.decode('{"type": "switch", "name": "basic switch", "port1": null, "__schema": {"type": "object", "properties": {"name": {"type": "string"}, "type": {"type": "string", "enum": ["switch"]}, "port1": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}}}}')

local Switch_schema = Switch_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (Switch_schema["properties"]["type"] == nil) then
  Switch_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "switch" }
  }
end
--local Switch_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(Switch_schema)))
--pprint(Switch_schema)
local Switch_schema_validator = jsonschema.generate_validator(Switch_schema)

local Switch_properties = Switch_raw
Switch_properties["__schema"] = nil

function new_Switch(properties) 
  if (properties == nil) then
    properties = {}
  end
  return Switch.new(properties)
end

function Switch.new(properties) 
  local self = setmetatable({}, Switch)
  local ok, message = true, nil
   

  Switch_properties["type"] = "switch"

  local merged_properties = table_merge(
        Switch_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(Switch_schema)
    assert(ok, message)
  end

  return self
end

function Switch.__validate(self, value) 
  assert(type(value) == "table", "function Switch.__validate accepts only table in argument")
  return Switch_schema_validator(value) 
end


function Switch.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function Switch.__get_properties(self)
  return self.properties
end


function Switch.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function Switch.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function Switch.get_type_validator(self)
  return Switch_schema
end
function Switch.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function Switch.get_type(self)
  return self:get_property("type")
end
 function Switch.get_name_validator(self)
  return Switch_schema
end
function Switch.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_name_validator())
]]--

  if ok ~= true then
    pprint(self:get_name_validator())
    assert(ok, message)
  end
end
function Switch.get_name(self)
  return self:get_property("name")
end
 function Switch.get_port1_validator(self)
  return Switch_schema
end
function Switch.set_port1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port1_validator())
]]--

  if ok ~= true then
    pprint(self:get_port1_validator())
    assert(ok, message)
  end
end
function Switch.get_port1(self)
  return self:get_property("port1")
end
  local Hp_procurve_2810 = {}
Hp_procurve_2810.__index = Hp_procurve_2810

-- local Hp_procurve_2810_raw = rapidjson.decode('{"type": "hp_procurve_2810", "name": "HP ProCurve 2810", "port1": null, "port2": null, "port3": null, "port4": null, "port5": null, "port6": null, "port7": null, "port8": null, "port9": null, "port10": null, "port11": null, "port12": null, "port13": null, "port14": null, "port15": null, "port16": null, "port17": null, "port18": null, "port19": null, "port20": null, "port21": null, "port22": null, "port23": null, "port24": null, "__schema": {"type": "object", "definitions": {"port_1g": {"$id": "#port_1g", "oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "null"}]}}, "properties": {"name": {"type": "string"}, "type": {"type": "string", "enum": ["hp_procurve_2810"]}, "port1": {"$ref": "#/definitions/port_1g"}, "port2": {"$ref": "#/definitions/port_1g"}, "port3": {"$ref": "#/definitions/port_1g"}, "port4": {"$ref": "#/definitions/port_1g"}, "port5": {"$ref": "#/definitions/port_1g"}, "port6": {"$ref": "#/definitions/port_1g"}, "port7": {"$ref": "#/definitions/port_1g"}, "port8": {"$ref": "#/definitions/port_1g"}, "port9": {"$ref": "#/definitions/port_1g"}, "port10": {"$ref": "#/definitions/port_1g"}, "port11": {"$ref": "#/definitions/port_1g"}, "port12": {"$ref": "#/definitions/port_1g"}, "port13": {"$ref": "#/definitions/port_1g"}, "port14": {"$ref": "#/definitions/port_1g"}, "port15": {"$ref": "#/definitions/port_1g"}, "port16": {"$ref": "#/definitions/port_1g"}, "port17": {"$ref": "#/definitions/port_1g"}, "port18": {"$ref": "#/definitions/port_1g"}, "port19": {"$ref": "#/definitions/port_1g"}, "port20": {"$ref": "#/definitions/port_1g"}, "port21": {"$ref": "#/definitions/port_1g"}, "port22": {"$ref": "#/definitions/port_1g"}, "port23": {"$ref": "#/definitions/port_1g"}, "port24": {"$ref": "#/definitions/port_1g"}, "port25": {"$ref": "#/definitions/port_1g"}, "port26": {"$ref": "#/definitions/port_1g"}, "port27": {"$ref": "#/definitions/port_1g"}, "port28": {"$ref": "#/definitions/port_1g"}}}}')
local Hp_procurve_2810_raw = cjson.decode('{"type": "hp_procurve_2810", "name": "HP ProCurve 2810", "port1": null, "port2": null, "port3": null, "port4": null, "port5": null, "port6": null, "port7": null, "port8": null, "port9": null, "port10": null, "port11": null, "port12": null, "port13": null, "port14": null, "port15": null, "port16": null, "port17": null, "port18": null, "port19": null, "port20": null, "port21": null, "port22": null, "port23": null, "port24": null, "__schema": {"type": "object", "definitions": {"port_1g": {"$id": "#port_1g", "oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "null"}]}}, "properties": {"name": {"type": "string"}, "type": {"type": "string", "enum": ["hp_procurve_2810"]}, "port1": {"$ref": "#/definitions/port_1g"}, "port2": {"$ref": "#/definitions/port_1g"}, "port3": {"$ref": "#/definitions/port_1g"}, "port4": {"$ref": "#/definitions/port_1g"}, "port5": {"$ref": "#/definitions/port_1g"}, "port6": {"$ref": "#/definitions/port_1g"}, "port7": {"$ref": "#/definitions/port_1g"}, "port8": {"$ref": "#/definitions/port_1g"}, "port9": {"$ref": "#/definitions/port_1g"}, "port10": {"$ref": "#/definitions/port_1g"}, "port11": {"$ref": "#/definitions/port_1g"}, "port12": {"$ref": "#/definitions/port_1g"}, "port13": {"$ref": "#/definitions/port_1g"}, "port14": {"$ref": "#/definitions/port_1g"}, "port15": {"$ref": "#/definitions/port_1g"}, "port16": {"$ref": "#/definitions/port_1g"}, "port17": {"$ref": "#/definitions/port_1g"}, "port18": {"$ref": "#/definitions/port_1g"}, "port19": {"$ref": "#/definitions/port_1g"}, "port20": {"$ref": "#/definitions/port_1g"}, "port21": {"$ref": "#/definitions/port_1g"}, "port22": {"$ref": "#/definitions/port_1g"}, "port23": {"$ref": "#/definitions/port_1g"}, "port24": {"$ref": "#/definitions/port_1g"}, "port25": {"$ref": "#/definitions/port_1g"}, "port26": {"$ref": "#/definitions/port_1g"}, "port27": {"$ref": "#/definitions/port_1g"}, "port28": {"$ref": "#/definitions/port_1g"}}}}')

local Hp_procurve_2810_schema = Hp_procurve_2810_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (Hp_procurve_2810_schema["properties"]["type"] == nil) then
  Hp_procurve_2810_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "hp_procurve_2810" }
  }
end
--local Hp_procurve_2810_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(Hp_procurve_2810_schema)))
--pprint(Hp_procurve_2810_schema)
local Hp_procurve_2810_schema_validator = jsonschema.generate_validator(Hp_procurve_2810_schema)

local Hp_procurve_2810_properties = Hp_procurve_2810_raw
Hp_procurve_2810_properties["__schema"] = nil

function new_Hp_procurve_2810(properties) 
  if (properties == nil) then
    properties = {}
  end
  return Hp_procurve_2810.new(properties)
end

function Hp_procurve_2810.new(properties) 
  local self = setmetatable({}, Hp_procurve_2810)
  local ok, message = true, nil
   

  Hp_procurve_2810_properties["type"] = "hp_procurve_2810"

  local merged_properties = table_merge(
        Hp_procurve_2810_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(Hp_procurve_2810_schema)
    assert(ok, message)
  end

  return self
end

function Hp_procurve_2810.__validate(self, value) 
  assert(type(value) == "table", "function Hp_procurve_2810.__validate accepts only table in argument")
  return Hp_procurve_2810_schema_validator(value) 
end


function Hp_procurve_2810.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function Hp_procurve_2810.__get_properties(self)
  return self.properties
end


function Hp_procurve_2810.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function Hp_procurve_2810.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function Hp_procurve_2810.get_type_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_type(self)
  return self:get_property("type")
end
 function Hp_procurve_2810.get_name_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_name_validator())
]]--

  if ok ~= true then
    pprint(self:get_name_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_name(self)
  return self:get_property("name")
end
 function Hp_procurve_2810.get_port1_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port1_validator())
]]--

  if ok ~= true then
    pprint(self:get_port1_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port1(self)
  return self:get_property("port1")
end
 function Hp_procurve_2810.get_port2_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port2(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port2", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port2_validator())
]]--

  if ok ~= true then
    pprint(self:get_port2_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port2(self)
  return self:get_property("port2")
end
 function Hp_procurve_2810.get_port3_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port3(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port3", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port3_validator())
]]--

  if ok ~= true then
    pprint(self:get_port3_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port3(self)
  return self:get_property("port3")
end
 function Hp_procurve_2810.get_port4_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port4(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port4", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port4_validator())
]]--

  if ok ~= true then
    pprint(self:get_port4_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port4(self)
  return self:get_property("port4")
end
 function Hp_procurve_2810.get_port5_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port5(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port5", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port5_validator())
]]--

  if ok ~= true then
    pprint(self:get_port5_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port5(self)
  return self:get_property("port5")
end
 function Hp_procurve_2810.get_port6_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port6(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port6", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port6_validator())
]]--

  if ok ~= true then
    pprint(self:get_port6_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port6(self)
  return self:get_property("port6")
end
 function Hp_procurve_2810.get_port7_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port7(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port7", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port7_validator())
]]--

  if ok ~= true then
    pprint(self:get_port7_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port7(self)
  return self:get_property("port7")
end
 function Hp_procurve_2810.get_port8_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port8(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port8", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port8_validator())
]]--

  if ok ~= true then
    pprint(self:get_port8_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port8(self)
  return self:get_property("port8")
end
 function Hp_procurve_2810.get_port9_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port9(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port9", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port9_validator())
]]--

  if ok ~= true then
    pprint(self:get_port9_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port9(self)
  return self:get_property("port9")
end
 function Hp_procurve_2810.get_port10_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port10(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port10", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port10_validator())
]]--

  if ok ~= true then
    pprint(self:get_port10_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port10(self)
  return self:get_property("port10")
end
 function Hp_procurve_2810.get_port11_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port11(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port11", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port11_validator())
]]--

  if ok ~= true then
    pprint(self:get_port11_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port11(self)
  return self:get_property("port11")
end
 function Hp_procurve_2810.get_port12_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port12(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port12", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port12_validator())
]]--

  if ok ~= true then
    pprint(self:get_port12_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port12(self)
  return self:get_property("port12")
end
 function Hp_procurve_2810.get_port13_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port13(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port13", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port13_validator())
]]--

  if ok ~= true then
    pprint(self:get_port13_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port13(self)
  return self:get_property("port13")
end
 function Hp_procurve_2810.get_port14_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port14(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port14", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port14_validator())
]]--

  if ok ~= true then
    pprint(self:get_port14_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port14(self)
  return self:get_property("port14")
end
 function Hp_procurve_2810.get_port15_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port15(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port15", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port15_validator())
]]--

  if ok ~= true then
    pprint(self:get_port15_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port15(self)
  return self:get_property("port15")
end
 function Hp_procurve_2810.get_port16_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port16(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port16", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port16_validator())
]]--

  if ok ~= true then
    pprint(self:get_port16_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port16(self)
  return self:get_property("port16")
end
 function Hp_procurve_2810.get_port17_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port17(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port17", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port17_validator())
]]--

  if ok ~= true then
    pprint(self:get_port17_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port17(self)
  return self:get_property("port17")
end
 function Hp_procurve_2810.get_port18_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port18(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port18", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port18_validator())
]]--

  if ok ~= true then
    pprint(self:get_port18_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port18(self)
  return self:get_property("port18")
end
 function Hp_procurve_2810.get_port19_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port19(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port19", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port19_validator())
]]--

  if ok ~= true then
    pprint(self:get_port19_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port19(self)
  return self:get_property("port19")
end
 function Hp_procurve_2810.get_port20_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port20(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port20", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port20_validator())
]]--

  if ok ~= true then
    pprint(self:get_port20_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port20(self)
  return self:get_property("port20")
end
 function Hp_procurve_2810.get_port21_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port21(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port21", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port21_validator())
]]--

  if ok ~= true then
    pprint(self:get_port21_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port21(self)
  return self:get_property("port21")
end
 function Hp_procurve_2810.get_port22_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port22(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port22", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port22_validator())
]]--

  if ok ~= true then
    pprint(self:get_port22_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port22(self)
  return self:get_property("port22")
end
 function Hp_procurve_2810.get_port23_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port23(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port23", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port23_validator())
]]--

  if ok ~= true then
    pprint(self:get_port23_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port23(self)
  return self:get_property("port23")
end
 function Hp_procurve_2810.get_port24_validator(self)
  return Hp_procurve_2810_schema
end
function Hp_procurve_2810.set_port24(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port24", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port24_validator())
]]--

  if ok ~= true then
    pprint(self:get_port24_validator())
    assert(ok, message)
  end
end
function Hp_procurve_2810.get_port24(self)
  return self:get_property("port24")
end
  local Switch10 = {}
Switch10.__index = Switch10

-- local Switch10_raw = rapidjson.decode('{"type": "switch10", "name": "basic switch", "port1": null, "port2": null, "port3": null, "port4": null, "port5": null, "port6": null, "port7": null, "port8": null, "port9": null, "port10": null, "port11": null, "port12": null, "port13": null, "port14": null, "port15": null, "port16": null, "port17": null, "port18": null, "port19": null, "port20": null, "port21": null, "port22": null, "port23": null, "port24": null, "port25": null, "port26": null, "port27": null, "port28": null, "__schema": {"type": "object", "properties": {"name": {"type": "string"}, "type": {"type": "string", "enum": ["switch"]}, "port1": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port2": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port3": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port4": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port5": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port6": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port7": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port8": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port9": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port10": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port11": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port12": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port13": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port14": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port15": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port16": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port17": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port18": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port19": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port20": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port21": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port22": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port23": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port24": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port25": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port26": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port27": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port28": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}}}}')
local Switch10_raw = cjson.decode('{"type": "switch10", "name": "basic switch", "port1": null, "port2": null, "port3": null, "port4": null, "port5": null, "port6": null, "port7": null, "port8": null, "port9": null, "port10": null, "port11": null, "port12": null, "port13": null, "port14": null, "port15": null, "port16": null, "port17": null, "port18": null, "port19": null, "port20": null, "port21": null, "port22": null, "port23": null, "port24": null, "port25": null, "port26": null, "port27": null, "port28": null, "__schema": {"type": "object", "properties": {"name": {"type": "string"}, "type": {"type": "string", "enum": ["switch"]}, "port1": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port2": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port3": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port4": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port5": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port6": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port7": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port8": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port9": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port10": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port11": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port12": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port13": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port14": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port15": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port16": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port17": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port18": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port19": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port20": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port21": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port22": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port23": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port24": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port25": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port26": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port27": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}, "port28": {"oneOf": [{"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_100m_port"]}}}, {"type": "object", "required": ["type"], "properties": {"L1": {"type": "object", "properties": {"type": {"type": "string", "enum": ["optic", "ethernet"]}, "link": {"oneOf": [{"type": "object"}, {"type": "null"}]}, "modes": {"type": "array", "items": {"type": "string", "enum": ["10BASE-T", "100BASE-T", "1000BASE-T", "10GBASE-T", "40GBASE-T"]}}}}, "type": {"type": "string", "enum": ["l1_1g_port"]}}}, {"type": "null"}]}}}}')

local Switch10_schema = Switch10_raw["__schema"]
-- override type defintion if it is not present in jsonschema
if (Switch10_schema["properties"]["type"] == nil) then
  Switch10_schema["properties"]["type"] = { 
    type = "string", 
    enum = { "switch10" }
  }
end
--local Switch10_schema_validator = rapidjson.SchemaValidator(rapidjson.SchemaDocument(rapidjson.Document(Switch10_schema)))
--pprint(Switch10_schema)
local Switch10_schema_validator = jsonschema.generate_validator(Switch10_schema)

local Switch10_properties = Switch10_raw
Switch10_properties["__schema"] = nil

function new_Switch10(properties) 
  if (properties == nil) then
    properties = {}
  end
  return Switch10.new(properties)
end

function Switch10.new(properties) 
  local self = setmetatable({}, Switch10)
  local ok, message = true, nil
   

  Switch10_properties["type"] = "switch10"

  local merged_properties = table_merge(
        Switch10_properties,
        properties
  )
  ok, message = self:__set_properties(merged_properties)
 
  if ok ~= true then
    print("Initial properties:")
    pprint(self:__get_properties())
    pprint("Schema:")
    pprint(Switch10_schema)
    assert(ok, message)
  end

  return self
end

function Switch10.__validate(self, value) 
  assert(type(value) == "table", "function Switch10.__validate accepts only table in argument")
  return Switch10_schema_validator(value) 
end


function Switch10.__set_properties(self, value)
  local ok, message = true, nil
  ok, message = self:__validate(value)  
  self.properties = value
  return ok, message
end


function Switch10.__get_properties(self)
  return self.properties
end


function Switch10.set_property(self, property, value)
  local tmp_properties = self:__get_properties()
  tmp_properties[property] = value
  return self:__set_properties(table_merge(self:__get_properties(), tmp_properties))
end

function Switch10.get_property(self, property_name)
  return self:__get_properties()[property_name]
end

function Switch10.get_type_validator(self)
  return Switch10_schema
end
function Switch10.set_type(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("type", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_type_validator())
]]--

  if ok ~= true then
    pprint(self:get_type_validator())
    assert(ok, message)
  end
end
function Switch10.get_type(self)
  return self:get_property("type")
end
 function Switch10.get_name_validator(self)
  return Switch10_schema
end
function Switch10.set_name(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("name", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_name_validator())
]]--

  if ok ~= true then
    pprint(self:get_name_validator())
    assert(ok, message)
  end
end
function Switch10.get_name(self)
  return self:get_property("name")
end
 function Switch10.get_port1_validator(self)
  return Switch10_schema
end
function Switch10.set_port1(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port1", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port1_validator())
]]--

  if ok ~= true then
    pprint(self:get_port1_validator())
    assert(ok, message)
  end
end
function Switch10.get_port1(self)
  return self:get_property("port1")
end
 function Switch10.get_port2_validator(self)
  return Switch10_schema
end
function Switch10.set_port2(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port2", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port2_validator())
]]--

  if ok ~= true then
    pprint(self:get_port2_validator())
    assert(ok, message)
  end
end
function Switch10.get_port2(self)
  return self:get_property("port2")
end
 function Switch10.get_port3_validator(self)
  return Switch10_schema
end
function Switch10.set_port3(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port3", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port3_validator())
]]--

  if ok ~= true then
    pprint(self:get_port3_validator())
    assert(ok, message)
  end
end
function Switch10.get_port3(self)
  return self:get_property("port3")
end
 function Switch10.get_port4_validator(self)
  return Switch10_schema
end
function Switch10.set_port4(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port4", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port4_validator())
]]--

  if ok ~= true then
    pprint(self:get_port4_validator())
    assert(ok, message)
  end
end
function Switch10.get_port4(self)
  return self:get_property("port4")
end
 function Switch10.get_port5_validator(self)
  return Switch10_schema
end
function Switch10.set_port5(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port5", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port5_validator())
]]--

  if ok ~= true then
    pprint(self:get_port5_validator())
    assert(ok, message)
  end
end
function Switch10.get_port5(self)
  return self:get_property("port5")
end
 function Switch10.get_port6_validator(self)
  return Switch10_schema
end
function Switch10.set_port6(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port6", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port6_validator())
]]--

  if ok ~= true then
    pprint(self:get_port6_validator())
    assert(ok, message)
  end
end
function Switch10.get_port6(self)
  return self:get_property("port6")
end
 function Switch10.get_port7_validator(self)
  return Switch10_schema
end
function Switch10.set_port7(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port7", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port7_validator())
]]--

  if ok ~= true then
    pprint(self:get_port7_validator())
    assert(ok, message)
  end
end
function Switch10.get_port7(self)
  return self:get_property("port7")
end
 function Switch10.get_port8_validator(self)
  return Switch10_schema
end
function Switch10.set_port8(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port8", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port8_validator())
]]--

  if ok ~= true then
    pprint(self:get_port8_validator())
    assert(ok, message)
  end
end
function Switch10.get_port8(self)
  return self:get_property("port8")
end
 function Switch10.get_port9_validator(self)
  return Switch10_schema
end
function Switch10.set_port9(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port9", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port9_validator())
]]--

  if ok ~= true then
    pprint(self:get_port9_validator())
    assert(ok, message)
  end
end
function Switch10.get_port9(self)
  return self:get_property("port9")
end
 function Switch10.get_port10_validator(self)
  return Switch10_schema
end
function Switch10.set_port10(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port10", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port10_validator())
]]--

  if ok ~= true then
    pprint(self:get_port10_validator())
    assert(ok, message)
  end
end
function Switch10.get_port10(self)
  return self:get_property("port10")
end
 function Switch10.get_port11_validator(self)
  return Switch10_schema
end
function Switch10.set_port11(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port11", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port11_validator())
]]--

  if ok ~= true then
    pprint(self:get_port11_validator())
    assert(ok, message)
  end
end
function Switch10.get_port11(self)
  return self:get_property("port11")
end
 function Switch10.get_port12_validator(self)
  return Switch10_schema
end
function Switch10.set_port12(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port12", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port12_validator())
]]--

  if ok ~= true then
    pprint(self:get_port12_validator())
    assert(ok, message)
  end
end
function Switch10.get_port12(self)
  return self:get_property("port12")
end
 function Switch10.get_port13_validator(self)
  return Switch10_schema
end
function Switch10.set_port13(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port13", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port13_validator())
]]--

  if ok ~= true then
    pprint(self:get_port13_validator())
    assert(ok, message)
  end
end
function Switch10.get_port13(self)
  return self:get_property("port13")
end
 function Switch10.get_port14_validator(self)
  return Switch10_schema
end
function Switch10.set_port14(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port14", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port14_validator())
]]--

  if ok ~= true then
    pprint(self:get_port14_validator())
    assert(ok, message)
  end
end
function Switch10.get_port14(self)
  return self:get_property("port14")
end
 function Switch10.get_port15_validator(self)
  return Switch10_schema
end
function Switch10.set_port15(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port15", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port15_validator())
]]--

  if ok ~= true then
    pprint(self:get_port15_validator())
    assert(ok, message)
  end
end
function Switch10.get_port15(self)
  return self:get_property("port15")
end
 function Switch10.get_port16_validator(self)
  return Switch10_schema
end
function Switch10.set_port16(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port16", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port16_validator())
]]--

  if ok ~= true then
    pprint(self:get_port16_validator())
    assert(ok, message)
  end
end
function Switch10.get_port16(self)
  return self:get_property("port16")
end
 function Switch10.get_port17_validator(self)
  return Switch10_schema
end
function Switch10.set_port17(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port17", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port17_validator())
]]--

  if ok ~= true then
    pprint(self:get_port17_validator())
    assert(ok, message)
  end
end
function Switch10.get_port17(self)
  return self:get_property("port17")
end
 function Switch10.get_port18_validator(self)
  return Switch10_schema
end
function Switch10.set_port18(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port18", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port18_validator())
]]--

  if ok ~= true then
    pprint(self:get_port18_validator())
    assert(ok, message)
  end
end
function Switch10.get_port18(self)
  return self:get_property("port18")
end
 function Switch10.get_port19_validator(self)
  return Switch10_schema
end
function Switch10.set_port19(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port19", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port19_validator())
]]--

  if ok ~= true then
    pprint(self:get_port19_validator())
    assert(ok, message)
  end
end
function Switch10.get_port19(self)
  return self:get_property("port19")
end
 function Switch10.get_port20_validator(self)
  return Switch10_schema
end
function Switch10.set_port20(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port20", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port20_validator())
]]--

  if ok ~= true then
    pprint(self:get_port20_validator())
    assert(ok, message)
  end
end
function Switch10.get_port20(self)
  return self:get_property("port20")
end
 function Switch10.get_port21_validator(self)
  return Switch10_schema
end
function Switch10.set_port21(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port21", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port21_validator())
]]--

  if ok ~= true then
    pprint(self:get_port21_validator())
    assert(ok, message)
  end
end
function Switch10.get_port21(self)
  return self:get_property("port21")
end
 function Switch10.get_port22_validator(self)
  return Switch10_schema
end
function Switch10.set_port22(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port22", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port22_validator())
]]--

  if ok ~= true then
    pprint(self:get_port22_validator())
    assert(ok, message)
  end
end
function Switch10.get_port22(self)
  return self:get_property("port22")
end
 function Switch10.get_port23_validator(self)
  return Switch10_schema
end
function Switch10.set_port23(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port23", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port23_validator())
]]--

  if ok ~= true then
    pprint(self:get_port23_validator())
    assert(ok, message)
  end
end
function Switch10.get_port23(self)
  return self:get_property("port23")
end
 function Switch10.get_port24_validator(self)
  return Switch10_schema
end
function Switch10.set_port24(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port24", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port24_validator())
]]--

  if ok ~= true then
    pprint(self:get_port24_validator())
    assert(ok, message)
  end
end
function Switch10.get_port24(self)
  return self:get_property("port24")
end
 function Switch10.get_port25_validator(self)
  return Switch10_schema
end
function Switch10.set_port25(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port25", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port25_validator())
]]--

  if ok ~= true then
    pprint(self:get_port25_validator())
    assert(ok, message)
  end
end
function Switch10.get_port25(self)
  return self:get_property("port25")
end
 function Switch10.get_port26_validator(self)
  return Switch10_schema
end
function Switch10.set_port26(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port26", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port26_validator())
]]--

  if ok ~= true then
    pprint(self:get_port26_validator())
    assert(ok, message)
  end
end
function Switch10.get_port26(self)
  return self:get_property("port26")
end
 function Switch10.get_port27_validator(self)
  return Switch10_schema
end
function Switch10.set_port27(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port27", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port27_validator())
]]--

  if ok ~= true then
    pprint(self:get_port27_validator())
    assert(ok, message)
  end
end
function Switch10.get_port27(self)
  return self:get_property("port27")
end
 function Switch10.get_port28_validator(self)
  return Switch10_schema
end
function Switch10.set_port28(self, value)
  if (type(value) == "table" and value.__get_properties ~= nil) then
    value = value:__get_properties()
  end

  local ok, message = self:set_property("port28", value)
--[[
  pprint("SET")
  pprint(value)
  pprint("VALDATRO")
  pprint(self:get_port28_validator())
]]--

  if ok ~= true then
    pprint(self:get_port28_validator())
    assert(ok, message)
  end
end
function Switch10.get_port28(self)
  return self:get_property("port28")
end
  