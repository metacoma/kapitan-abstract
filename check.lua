local pprint = require('./pprint')
local object = require('./compiled/abstract/minetest_mod/generator')

local port_1g = new_L1_1g_port()
<<<<<<< HEAD
local port_10g = new_L1_10g_port({})
local switch10 = new_Switch10({})

switch:set_name("hp procurve 2810")
switch:set_port1(port_1g)
=======
local xxx = new_L1_1g_port()
local port_10g = new_L1_10g_port({})
local port_40g = new_L1_40g_port({})
local port_100m = new_L1_100m_port({})
local hp_procurve = new_Hp_procurve_2810()

local object = new_Object()
object:set_foo("4")

local switch = new_Switch({})

switch:set_name("hp procurve 2810")
--hp_procurve:set_port1(nil)
--hp_procurve:set_port1(port_100m)
--hp_procurve:set_port1(port_1g)
hp_procurve:set_port1(xxx)
>>>>>>> another segfault with rapidjson and ref/id
