-- status enums
addonchecker.status = {}
addonchecker.status.NOT_FOUND = 1
addonchecker.status.FOUND = 2
addonchecker.status.NOT_MOUNTED = 3

function addonchecker:ReadAddons()
	self.addons = {}

	-- legacy addons
	local files, directories = file.Find("addons/*", "GAME")

	for k,v in pairs(directories) do
		table.insert(self.addons, {folder=v})
	end

	-- workshop addons
	local addons = engine.GetAddons()

	for k,v in pairs(addons) do
		table.insert(self.addons, {wsid=v.wsid, mounted=v.mounted})
	end
end

function addonchecker:CheckAddons()
	if not self.addons or #self.addons == 0 then return end

	for k,v in pairs(self.config.addons) do
		if v.wsid then
			self:CheckWorkshopAddon(v)
		else
			self:CheckLegacyAddon(v)
		end
	end
end

function addonchecker:CheckLegacyAddon(config)
	for k,v in pairs(self.addons) do
		if v.wsid then continue end

		if config.folder then
			config.status = file.IsDir("addons/"..v.folder.."/"..config.folder, "GAME") and self.status.FOUND or self.status.NOT_FOUND
		elseif config.file then
			config.status = file.Exists("addons/"..v.folder.."/"..config.file, "GAME") and self.status.FOUND or self.status.NOT_FOUND
		end

		if config.status and config.status == self.status.FOUND then return end
	end

	config.status = self.status.NOT_FOUND
end

function addonchecker:CheckWorkshopAddon(config)
	for k,v in pairs(self.addons) do
		if v.wsid and v.wsid == config.wsid then
			config.status = v.mounted and self.status.FOUND or self.status.NOT_MOUNTED

			return
		end
	end

	config.status = self.status.NOT_FOUND
end

function addonchecker:HasMissingAddon()
	for k,v in pairs(self.config.addons) do
		if v.status != self.status.FOUND then
			return true
		end
	end

	return false
end


local function InitAddonCheck()
	addonchecker:ReadAddons()
	addonchecker:CheckAddons()

	if addonchecker:HasMissingAddon() then
		addonchecker.gui:Show()
	end
end
hook.Add("InitPostEntity", "addonchecker_initAddonCheck", InitAddonCheck)