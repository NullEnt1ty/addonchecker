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
	-- frame:SetSize(400, 300)
	frame:SetSize(self:GetSavedSize())
	frame:Center()
	frame:SetTitle(addonchecker.name)
	frame:SetSizable(true)
	-- frame:SetDeleteOnClose(false)
	frame:MakePopup()
	frame.OnClose = function()
		self:SetSavedSize(frame:GetSize())
	end

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
		addon:SetDownloadURL(v.download)
		addon:SetWorkshopID(v.wsid)
		addon:SetStatus(v.status)
	end
end

function addonchecker.gui:GetSavedSize()
	local size = GetConVar("addonchecker_size"):GetString()

	if size == "" then
		return 400, 300
	end

	size = string.Explode(" ", size)

	return tonumber(size[1]), tonumber(size[2])
end

function addonchecker.gui:SetSavedSize(w, h)
	RunConsoleCommand("addonchecker_size", w.." "..h)
end


concommand.Add("addonchecker_show", function()
	addonchecker.gui:Show()
end)