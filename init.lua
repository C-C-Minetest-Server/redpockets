-- redpockets/init.lua
-- Give artificial red pockets to kids!
--[[
	Copyright (c) 2022, 2024  1F616EMO

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local MP = minetest.get_modpath("redpockets") .. DIR_DELIM

if minetest.get_modpath("currency") then
	dofile(MP .. "c_currency.lua")
else
	dofile(MP .. "c_none.lua")
end

minetest.register_craft({
	type = "fuel",
	recipe = "group:redpockets",
	burntime = 1,
})

if minetest.get_modpath("default") and minetest.get_modpath("dye") then
	local glue = minetest.get_modpath("mesecons_materials") and "mesecons_materials:glue" or ""
	local paper = "default:paper"
	local dye = "dye:red"
	minetest.register_craft({
		output = "redpockets:unused",
		recipe = {
			{ paper, glue,  paper },
			{ paper, dye,   paper },
			{ paper, paper, paper }
		},
	})
end
