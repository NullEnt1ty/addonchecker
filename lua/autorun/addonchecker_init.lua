if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("addonchecker/cl_init.lua")

	include("addonchecker/init.lua")
else
	include("addonchecker/cl_init.lua")
end