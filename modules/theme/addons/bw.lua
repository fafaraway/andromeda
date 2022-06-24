local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

local function RemoveStyle(bar)
    bar.candyBarBackdrop:Hide()
    local height = bar:Get('bigwigs:restoreheight')
    if height then
        bar:SetHeight(height)
    end

    local tex = bar:Get('bigwigs:restoreicon')
    if tex then
        bar:SetIcon(tex)
        bar:Set('bigwigs:restoreicon', nil)
        bar.candyBarIconFrameBackdrop:Hide()
    end

    bar.candyBarDuration:ClearAllPoints()
    bar.candyBarDuration:SetPoint('TOPLEFT', bar.candyBarBar, 'TOPLEFT', 2, 0)
    bar.candyBarDuration:SetPoint('BOTTOMRIGHT', bar.candyBarBar, 'BOTTOMRIGHT', -2, 0)
    bar.candyBarLabel:ClearAllPoints()
    bar.candyBarLabel:SetPoint('TOPLEFT', bar.candyBarBar, 'TOPLEFT', 2, 0)
    bar.candyBarLabel:SetPoint('BOTTOMRIGHT', bar.candyBarBar, 'BOTTOMRIGHT', -2, 0)
end

local function ReskinBar(bar)
    local height = bar:GetHeight()
    bar:Set('bigwigs:restoreheight', height)
    bar:SetHeight(height / 2)
    bar.candyBarBackdrop:Hide()
    if not bar.styled then
        F.StripTextures(bar.candyBarBar, true)
        F.SetBD(bar.candyBarBar)

        bar.styled = true
    end
    bar:SetTexture(C.Assets.Statusbar.Normal)

    local tex = bar:GetIcon()
    if tex then
        local icon = bar.candyBarIconFrame
        bar:SetIcon(nil)
        icon:SetTexture(tex)
        icon:Show()
        if bar.iconPosition == 'RIGHT' then
            icon:SetPoint('BOTTOMLEFT', bar, 'BOTTOMRIGHT', 5, 0)
        else
            icon:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -5, 0)
        end
        icon:SetSize(height, height)
        bar:Set('bigwigs:restoreicon', tex)
        bar.candyBarIconFrameBackdrop:Hide()

        if not icon.styled then
            F.SetBD(icon)

            icon.styled = true
        end
    end

    bar.candyBarLabel:ClearAllPoints()
    bar.candyBarLabel:SetPoint('LEFT', bar.candyBarBar, 'LEFT', 2, 8)
    bar.candyBarLabel:SetPoint('RIGHT', bar.candyBarBar, 'RIGHT', -2, 8)
    bar.candyBarDuration:ClearAllPoints()
    bar.candyBarDuration:SetPoint('RIGHT', bar.candyBarBar, 'RIGHT', -2, 8)
    bar.candyBarDuration:SetPoint('LEFT', bar.candyBarBar, 'LEFT', 2, 8)
end

local styleData = {
    apiVersion = 1,
    version = 3,
    GetSpacing = function(bar)
        return bar:GetHeight() + 5
    end,
    ApplyStyle = ReskinBar,
    BarStopped = RemoveStyle,
    fontSizeNormal = 13,
    fontSizeEmphasized = 14,
    fontOutline = 'OUTLINE',
    GetStyleName = function()
        return C.ADDON_TITLE
    end,
}

function THEME:RegisterBigWigsStyle()
    if not _G.FREE_ADB.ReskinAddons then
        return
    end

    local BigWigsAPI = _G.BigWigsAPI

    if not BigWigsAPI then
        return
    end

    BigWigsAPI:RegisterBarStyle(C.ADDON_TITLE, styleData)

    -- Force to use new style
    local pending = true
    hooksecurefunc(BigWigsAPI, 'GetBarStyle', function()
        if pending then
            BigWigsAPI.GetBarStyle = function()
                return styleData
            end

            pending = nil
        end
    end)
end

function THEME:RestyleBigWigsQueueTimer()
    if not _G.FREE_ADB.ReskinAddons then
        return
    end

    local BigWigsLoader = _G.BigWigsLoader

    if BigWigsLoader and BigWigsLoader.RegisterMessage then
        BigWigsLoader.RegisterMessage(C.ADDON_TITLE, 'BigWigs_FrameCreated', function(_, frame, name)
            if name == 'QueueTimer' and not frame.styled then
                F.StripTextures(frame)
                F.SetBD(frame)

                frame:SetStatusBarTexture(C.Assets.Statusbar.Gradient)
                frame:ClearAllPoints()
                frame:SetPoint('BOTTOMLEFT', '$parent', 'BOTTOMLEFT')
                frame:SetPoint('BOTTOMRIGHT', '$parent', 'BOTTOMRIGHT')
                frame:SetHeight(6)
                frame.text:Hide()

                frame.styled = true
            end
        end)

        -- BigWigsLoader.RegisterMessage(C.ADDON_TITLE, 'EmphasizedPrint', function(_, text)
        --     if text and not text.styled then

        --         text.styled = true
        --     end
        -- end)
    end
end

THEME:RegisterSkin('BigWigs', THEME.RestyleBigWigsQueueTimer)
THEME:RegisterSkin('BigWigs_Plugins', THEME.RegisterBigWigsStyle)
