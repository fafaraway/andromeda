local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_ItemSocketingUI()
    _G.ItemSocketingFrame:DisableDrawLayer("ARTWORK")
    _G.ItemSocketingScrollFrameTop:SetAlpha(0)
    _G.ItemSocketingScrollFrameMiddle:SetAlpha(0)
    _G.ItemSocketingScrollFrameBottom:SetAlpha(0)
    _G.ItemSocketingSocket1Left:SetAlpha(0)
    _G.ItemSocketingSocket1Right:SetAlpha(0)
    _G.ItemSocketingSocket2Left:SetAlpha(0)
    _G.ItemSocketingSocket2Right:SetAlpha(0)
    _G.ItemSocketingSocket3Left:SetAlpha(0)
    _G.ItemSocketingSocket3Right:SetAlpha(0)

    for i = 36, 51 do
        select(i, _G.ItemSocketingFrame:GetRegions()):Hide()
    end

    local title = select(18, _G.ItemSocketingFrame:GetRegions())
    title:ClearAllPoints()
    title:SetPoint("TOP", 0, -5)

    for i = 1, _G.MAX_NUM_SOCKETS do
        local bu = _G["ItemSocketingSocket"..i]
        local shine = _G["ItemSocketingSocket"..i.."Shine"]

        _G["ItemSocketingSocket"..i.."BracketFrame"]:Hide()
        _G["ItemSocketingSocket"..i.."Background"]:SetAlpha(0)
        select(2, bu:GetRegions()):Hide()

        bu:SetPushedTexture("")
        bu.icon:SetTexCoord(.08, .92, .08, .92)

        shine:ClearAllPoints()
        shine:SetPoint("TOPLEFT", bu)
        shine:SetPoint("BOTTOMRIGHT", bu, 1, 0)

        bu.bg = F.CreateBDFrame(bu, .25)
    end

    _G.hooksecurefunc("ItemSocketingFrame_Update", function()
        for i = 1, _G.MAX_NUM_SOCKETS do
            local color = _G.GEM_TYPE_INFO[_G.GetSocketTypes(i)]
            _G["ItemSocketingSocket"..i].bg:SetBackdropBorderColor(color.r, color.g, color.b)
        end

        local num = _G.GetNumSockets()
        if num == 3 then
            _G.ItemSocketingSocket1:SetPoint("BOTTOM", _G.ItemSocketingFrame, "BOTTOM", -75, 39)
        elseif num == 2 then
            _G.ItemSocketingSocket1:SetPoint("BOTTOM", _G.ItemSocketingFrame, "BOTTOM", -35, 39)
        else
            _G.ItemSocketingSocket1:SetPoint("BOTTOM", _G.ItemSocketingFrame, "BOTTOM", 0, 39)
        end
    end)

    F.ReskinPortraitFrame(_G.ItemSocketingFrame, true)
    F.CreateBD(_G.ItemSocketingFrame)
    F.CreateSD(_G.ItemSocketingFrame)
    F.Reskin(_G.ItemSocketingSocketButton)
    F.ReskinScroll(_G.ItemSocketingScrollFrameScrollBar)
end
