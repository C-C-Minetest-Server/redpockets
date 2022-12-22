local function return_used()
	return ItemStack("redpockets:used")
end

minetest.register_craftitem("redpockets:unused",{
	description = S("Red Pocket"),
	_tt_help = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_longdesc = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_usagehelp = S("No money can be put into this red pocket due to the absence of the Currency mod. This item can only act as a decoration, or as a fuel for furnaces."),
	inventory_image = "redpockets_unused.png",
	on_place = return_used,
	on_secondary_use = return_used,
	groups = {flammable = 3,redpockets=1},
})

minetest.register_craftitem("redpockets:money",{
	description = S("Red Pocket"),
	_tt_help = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_longdesc = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_usagehelp = S("No money can be put into this red pocket due to the absence of the Currency mod. This item can only act as a decoration, or as a fuel for furnaces."),
	inventory_image = "redpockets_money.png",
	groups = {flammable = 3,redpockets=1},
	stack_max = 1,
})

minetest.register_craftitem("redpockets:used",{
	description = S("Red Pocket"),
	_tt_help = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_longdesc = S("A money gift, usually given during the Chinese New Year in China."),
	_doc_items_usagehelp = S("No money can be put into this red pocket due to the absence of the Currency mod. This item can only act as a decoration, or as a fuel for furnaces."),
	inventory_image = "redpockets_used.png",
	groups = {flammable = 3,redpockets=1},
})
