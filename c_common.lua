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
			{paper,glue,paper},
			{paper,dye,paper},
			{paper,paper,paper}
		},
	})
end
