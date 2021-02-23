local _G = _G
local select = select
local unpack = unpack
local IsAddOnLoaded = IsAddOnLoaded

local F = unpack(select(2, ...))
local THEME = F.THEME

function THEME:ReskinABP()
    if not _G.FREE_ADB.reskin_abp then
        return
    end

    if not IsAddOnLoaded('ActionBarProfiles') then
        return
    end

    local useProfile = _G.PaperDollActionBarProfilesPaneUseProfile
    local saveProfile = _G.PaperDollActionBarProfilesPaneSaveProfile
    local pane = _G.PaperDollActionBarProfilesPane
    local scrollBar = _G.PaperDollActionBarProfilesPaneScrollBar

    F.Reskin(useProfile)
    F.Reskin(saveProfile)

    useProfile:Width(useProfile:GetWidth() - 8)
    saveProfile:Width(saveProfile:GetWidth() - 8)
    useProfile:Point('TOPLEFT', pane, 'TOPLEFT', 8, 0)
    saveProfile:Point('LEFT', useProfile, 'RIGHT', 4, 0)
    useProfile.ButtonBackground:SetTexture(nil)

    for _, object in pairs(pane.buttons) do
        object.BgTop:SetTexture(nil)
        object.BgBottom:SetTexture(nil)
        object.BgMiddle:SetTexture(nil)
    end

    F.ReskinScroll(scrollBar)
end
