local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.PVEFrame()
    local r, g, b = C.r, C.g, C.b

    _G.PVEFrame:DisableDrawLayer("ARTWORK")
    _G.PVEFrameLeftInset:DisableDrawLayer("BORDER")
    _G.PVEFrameLeftInsetBg:Hide()
    _G.PVEFrameBlueBg:Hide()
    _G.PVEFrameBlueBg.Show = F.dummy
    _G.PVEFrameTopFiligree:Hide()
    _G.PVEFrameTopFiligree.Show = F.dummy
    _G.PVEFrameBottomFiligree:Hide()
    _G.PVEFrameBottomFiligree.Show = F.dummy
    _G.PVEFrame.shadows:Hide()
    _G.PVEFrame.shadows.Show = F.dummy

    _G.PVEFrameTab2:SetPoint("LEFT", _G.PVEFrameTab1, "RIGHT", -15, 0)
    _G.PVEFrameTab3:SetPoint("LEFT", _G.PVEFrameTab2, "RIGHT", -15, 0)

    _G.GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
    _G.GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
    _G.GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\inv_helmet_06")

    for i = 1, 4 do
        local bu = _G.GroupFinderFrame["groupButton"..i]

        bu.ring:Hide()
        bu.bg:SetTexture(C.media.backdrop)
        bu.bg:SetVertexColor(r, g, b, .2)
        bu.bg:SetAllPoints()

        F.Reskin(bu, true)

        bu.icon:SetTexCoord(.08, .92, .08, .92)
        bu.icon:SetPoint("LEFT", bu, "LEFT")
        bu.icon:SetDrawLayer("OVERLAY")
        bu.icon.bg = F.CreateBG(bu.icon)
        bu.icon.bg:SetDrawLayer("ARTWORK")
    end

    hooksecurefunc("GroupFinderFrame_SelectGroupButton", function(index)
        local self = _G.GroupFinderFrame
        for i = 1, 4 do
            local button = self["groupButton"..i]
            if i == index then
                button.bg:Show()
            else
                button.bg:Hide()
            end
        end
    end)

    F.ReskinPortraitFrame(_G.PVEFrame)
    F.CreateBD(_G.PVEFrame)
    F.CreateSD(_G.PVEFrame)
    F.ReskinTab(_G.PVEFrameTab1)
    F.ReskinTab(_G.PVEFrameTab2)
    F.ReskinTab(_G.PVEFrameTab3)
end
