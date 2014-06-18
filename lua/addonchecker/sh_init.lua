addonchecker = addonchecker or {}
addonchecker.name = "Addon Checker"
addonchecker.version = "1.0.0"

if SERVER then
	AddCSLuaFile("shared/sh_util.lua")
end

include("shared/sh_util.lua")

addonchecker:Print("Initialized! Version %s", addonchecker.version)