local MP = minetest.get_modpath("redpockets") .. DIR_DELIM

if minetest.get_modpath("currency") then
	dofile(MP .. "c_currency.lua")
else
	dofile(MP .. "c_none.lua")
end

dofile(MP .. "c_common.lua")
