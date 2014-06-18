local statusTbl = {}
statusTbl[addonchecker.status.NOT_FOUND] 	= {tooltip="Not found", image="icon16/cross.png", color=Color(231, 76, 60)}
statusTbl[addonchecker.status.FOUND] 		= {tooltip="Found", image="icon16/tick.png", color=Color(46, 204, 113)}
statusTbl[addonchecker.status.NOT_MOUNTED] 	= {tooltip="Not mounted", image="icon16/exclamation.png", color=Color(230, 126, 34)}


local PANEL = {}

AccessorFunc(PANEL, "m_strDownloadURL", 	"DownloadURL")
AccessorFunc(PANEL, "m_strWsid", 			"WorkshopID")

function PANEL:Init()
	self:SetHeight(30)
	self:DockMargin(0, 0, 0, 5)

	self.title = self:Add("DLabel")
	self.title:Dock(FILL)
	self.title:DockMargin(5, 0, 25, 0)
	self.title:SetColor(Color(255,255,255))
	self.title:SetFont("AddonCheckerTitle")

	self.container = self:Add("Panel")
	self.container:SetSize(32, 16)

	self.imgDownload = self.container:Add("DImageButton")
	self.imgDownload:SetSize(16, 16)
	self.imgDownload:Dock(RIGHT)
	self.imgDownload:SetImage("icon16/page_go.png")
	self.imgDownload:SetToolTip("Open download page")
	self.imgDownload:Hide()
	self.imgDownload.DoClick = function()
		self:OpenDownloadPage()
	end

	self.imgStatus = self.container:Add("DImage")
	self.imgStatus:SetSize(16, 16)
	self.imgStatus:Dock(RIGHT)
	self.imgStatus:SetMouseInputEnabled(true)
end

function PANEL:PerformLayout()
	self.container:SetPos(self:GetWide() - self.container:GetWide() - 4, 3)
end

function PANEL:SetTitle(txt)
	self.title:SetText(txt)
end

function PANEL:SetStatus(status)
	local t = statusTbl[status]

	self:SetBackgroundColor(t.color)
	
	self.imgStatus:SetImage(t.image)
	self.imgStatus:SetToolTip(t.tooltip)

	if status == addonchecker.status.NOT_FOUND then
		self.imgDownload:Show()
	end
end

function PANEL:OpenDownloadPage()
	local url = self:GetDownloadURL() or self:GetWorkshopID() and "http://steamcommunity.com/sharedfiles/filedetails/?id=" .. self:GetWorkshopID()
	
	if not url then return end

	gui.OpenURL(url)
end

derma.DefineControl("DAddon", "", PANEL, "DPanel")