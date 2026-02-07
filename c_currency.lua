-- redpockets/c_currency.lua
-- Codes to be executed when "currency" is found
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

local S = core.get_translator("redpockets")

local awards_exist = core.global_exists("awards")

local values_all = {
	{ "currency:minegeld_100", 100 },
	{ "currency:minegeld_50",  50 },
	{ "currency:minegeld_10",  10 },
	{ "currency:minegeld_5",   5 },
	{ "currency:minegeld",     1 },
}
local values = {}
local exist_notes = {}
for _, y in ipairs(values_all) do
	if core.registered_craftitems[y[1]] then
		table.insert(values, y)
		exist_notes[y[1]] = y[2]

		local groups = core.registered_craftitems[y[1]].groups or {}
		groups.redpocket_banknotes = 1
		core.override_item(y[1], { groups = groups })
	end
end

if awards_exist then
	awards.register_award("redpockets:pack", {
		title = S("It's more blessed to give than to receive"),
		description = S("Pack a red pocket with a value higher than 10MG."),
		icon = "redpockets_money.png",
	})
	awards.register_award("redpockets:take", {
		title = S("Happy New Year!"),
		description = S("Receive and open a red packet from others."),
		icon = "redpockets_used.png",
	})
end

local function get_best_combination(value)
	print("val recv " .. value)
	local stacks = {}
	for _, y in pairs(values) do
		print("ent vals loop " .. y[1] .. " corrval " .. y[2] .. " val " .. value)
		if value >= y[2] then
			local count = math.floor(value / y[2])
			value = value - (count * y[2])
			if count > 0 then
				local stack = ItemStack(y[1])
				stack:set_count(count)
				table.insert(stacks, stack)
			end
		end
		print("leave vals loop " .. y[1] .. " dump " .. dump(stacks))
	end
	return stacks
end

core.register_craftitem("redpockets:unused", {
	description = S("Unused Red Pocket"),
	_tt_help = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_longdesc = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_usagehelp = S(
		"By putting an unused red pocket and currencies into the crafting grid, a red pocket with money is returned."),
	inventory_image = "redpockets_unused.png",
	groups = { flammable = 3, redpockets = 1 },
})

local function on_money_use(itemstack, user)
	local meta = itemstack:get_meta()
	local value = meta:get_int("money")
	if value > 1 then
		local inv = user:get_inventory()
		local stacks = get_best_combination(value)
		for _, i in ipairs(stacks) do
			if not inv:room_for_item("main", i) then
				return itemstack
			end
		end
		for _, i in ipairs(stacks) do
			inv:add_item("main", i)
		end
		local self_pname = user:get_player_name()
		local give_pname = meta:get_string("from")
		if awards_exist and self_pname ~= give_pname then
			awards.unlock(self_pname, "redpockets:take")
		end
	else
		if user:is_player() then
			core.chat_send_player(user:get_player_name(),
				S("This red pocket is corrupted. It does not contain any money."))
		end
	end
	return ItemStack("redpockets:used")
end

core.register_craftitem("redpockets:money", {
	description = S("Red Pocket with Money"),
	_tt_help = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_longdesc = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_usagehelp = S(
		"Give this little red pocket to whomever you want, right-click with the pocket to take the money out."),
	inventory_image = "redpockets_money.png",
	groups = { not_in_creative_inventory = 1, flammable = 3, redpockets = 1 },
	on_place = on_money_use,
	on_secondary_use = on_money_use,
	stack_max = 1,
})

core.register_craftitem("redpockets:used", {
	description = S("Used Red Pocket"),
	_tt_help = S("The remains of a red pocket after taking out the money inside it."),
	_doc_items_longdesc = S("The remains of a red pocket after taking out the money inside it."),
	_doc_items_usagehelp = S("The remains of a red pocket, tore in order to take the money out. " ..
		"It cannot be reused, and should end up in a furnace's fuel slot."),
	inventory_image = "redpockets_used.png",
	groups = { flammable = 3, redpockets = 1 },
})

local recipe = { "redpockets:unused" }
repeat
	table.insert(recipe, "group:redpocket_banknotes")
	core.register_craft({
		type = "shapeless",
		output = "redpockets:money",
		recipe = recipe,
	})
until (#recipe == 9)

core.register_on_craft(function(itemstack, player, old_craft_grid)
	if itemstack:get_name() ~= "redpockets:money" then return end
	for _, i in ipairs(old_craft_grid) do
		if i:get_name() == "redpockets:unused" then
			local value = 0
			for _, m in ipairs(old_craft_grid) do
				if exist_notes[m:get_name()] then
					value = value + exist_notes[m:get_name()]
				end
			end
			if value == 0 then return end
			local pname = player:get_player_name()
			local meta = itemstack:get_meta()
			meta:set_string("description", S("Red Pocket with Money by @1", pname))
			meta:set_string("from", pname)
			meta:set_int("money", value)
			if value >= 10 and awards_exist then
				awards.unlock(pname, "redpockets:pack")
			end
			return itemstack
		end
	end
end)

core.register_craft_predict(function(itemstack, _, old_craft_grid)
	if itemstack:get_name() ~= "redpockets:money" then return end
	for _, i in ipairs(old_craft_grid) do
		if i:get_name() == "redpockets:unused" then
			local value = 0
			for _, m in ipairs(old_craft_grid) do
				if exist_notes[m:get_name()] then
					value = value + exist_notes[m:get_name()]
				end
			end
			if value == 0 then return end
			local meta = itemstack:get_meta()
			meta:set_string("description", S("Red Pocket with Money (@1MG)", value))
			return
		end
	end
end)
