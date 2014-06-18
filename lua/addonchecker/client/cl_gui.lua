addonchecker.gui = addonchecker.gui or {}

function addonchecker.gui:Show()
	if IsValid(self.frame) then
		self.frame:Show()
		return
	end

	self:Rebuild()
end

function addonchecker.gui:Rebuild()
	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 300)
	frame:Center()
	frame:SetTitle(addonchecker.name)
	frame:SetSizable(true)
	frame:SetDeleteOnClose(false)
	frame:MakePopup()

	local scrollPanel = frame:Add("DScrollPanel")
	scrollPanel:Dock(FILL)

	local container = scrollPanel:Add("DListLayout")
	container:Dock(FILL)

	self.frame = frame
	self.container = container

	self:BuildAddonList()
end

function addonchecker.gui:BuildAddonList()
	for k,v in pairs(addonchecker.config.addons) do
		local addon = self.container:Add("DAddon")
		addon:SetTitle(v.title)
		addon:SetStatus(v.status)

		if v.download then
			addon:SetDownloadURL(v.download)
		elseif v.wsid then
			addon:SetWorkshopID(v.wsid)
		end
	end
end


concommand.Add("addonchecker_show", function()
	addonchecker.gui:Show()
end)