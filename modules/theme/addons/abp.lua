local F, C = unpack(select(2, ...))
local THEME = F.THEME

function THEME:ReskinABP()
	if not FREE_ADB.reskin_abp then
		return
	end

	if not IsAddOnLoaded('ActionBarProfiles') then
		return
	end

	F.Reskin(_G.PaperDollActionBarProfilesPaneUseProfile)
	F.Reskin(_G.PaperDollActionBarProfilesPaneSaveProfile)

	_G.PaperDollActionBarProfilesPaneUseProfile:Width(_G.PaperDollActionBarProfilesPaneUseProfile:GetWidth() - 8)
	_G.PaperDollActionBarProfilesPaneSaveProfile:Width(_G.PaperDollActionBarProfilesPaneSaveProfile:GetWidth() - 8)
	_G.PaperDollActionBarProfilesPaneUseProfile:Point("TOPLEFT", _G.PaperDollActionBarProfilesPane, "TOPLEFT", 8, 0)
	_G.PaperDollActionBarProfilesPaneSaveProfile:Point("LEFT", _G.PaperDollActionBarProfilesPaneUseProfile, "RIGHT", 4, 0)
	_G.PaperDollActionBarProfilesPaneUseProfile.ButtonBackground:SetTexture(nil)

	for _, object in pairs(_G.PaperDollActionBarProfilesPane.buttons) do
		object.BgTop:SetTexture(nil)
		object.BgBottom:SetTexture(nil)
		object.BgMiddle:SetTexture(nil)
	end



	F.ReskinScroll(_G.PaperDollActionBarProfilesPaneScrollBar)
end
