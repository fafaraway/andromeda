local F, C, L = unpack(select(2, ...))

local module = F:GetModule("blizzard")

function module:ArchaeologyBar()
	local frame, xpBar
	local customPosition = false

	local function setPosition()
		frame:SetPoint("TOP", UIParent, "TOP", 0, -50)
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "Blizzard_ArchaeologyUI" then return end
		self:UnregisterEvent("ADDON_LOADED")

		frame = ArcheologyDigsiteProgressBar
		local bar = frame.FillBar

		frame.Shadow:Hide()
		frame.BarBackground:Hide()
		frame.BarBorderAndOverlay:Hide()

		if C.Client == 'zhCN' or C.Client == 'zhTW' then
			frame.BarTitle:SetFont(C.font.normal, 11, "OUTLINE")
		else
			F.SetFS(frame.BarTitle)
		end

		frame.BarTitle:SetPoint("CENTER", 0, 16)

		local width = C.unitframe.player_width
		bar:SetWidth(width)
		frame.Flash:SetWidth(width + 22)

		bar:SetStatusBarTexture(C.media.sbTex)
		bar:SetStatusBarColor(221/255, 197/255, 162/255)

		F.CreateBDFrame(bar)
		F.CreateSD(bar)

		--xpBar = FreeUIExpBar:GetParent()

		frame:HookScript("OnShow", setPosition)
		--xpBar:HookScript("OnShow", setPosition)
		--xpBar:HookScript("OnHide", setPosition)

		hooksecurefunc(frame, "SetPoint", function()
			if not customPosition then
				customPosition = true
				setPosition()
				customPosition = false
			end
		end)
	end)
end