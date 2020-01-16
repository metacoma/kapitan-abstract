local pprint = require('./pprint')
local object = require('./compiled/abstract/minetest_mod/generator')

local port_1g = new_L1_1g_port()
local port_10g = new_L1_10g_port({})
local switch10 = new_Switch10({})

switch:set_name("hp procurve 2810")
switch:set_port1(port_1g)
