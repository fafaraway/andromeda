local _G = _G
local select = select
local unpack = unpack
local hooksecurefunc = hooksecurefunc

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
    bar:SetTexture(C.Assets.statusbar_tex)

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
        return 'FreeUI'
    end
}

function THEME:RegisterBigWigsStyle()
    if not _G.FREE_ADB.ReskinAddons then
        return
    end

    if not _G.BigWigsAPI then
        return
    end

    _G.BigWigsAPI:RegisterBarStyle('FreeUI', styleData)

    -- Force to use FreeUI style
    local pending = true
    hooksecurefunc(
        _G.BigWigsAPI,
        'GetBarStyle',
        function()
            if pending then
                _G.BigWigsAPI.GetBarStyle = function()
                    return styleData
                end
                pending = nil
            end
        end
    )
end

function THEME:ReskinBigWigs()
    if not _G.FREE_ADB.ReskinAddons then
        return
    end

    if _G.BigWigsLoader and _G.BigWigsLoader.RegisterMessage then
        _G.BigWigsLoader.RegisterMessage(
            _,
            'BigWigs_FrameCreated',
            function(_, frame, name)
                if name == 'QueueTimer' and not frame.styled then
                    F.StripTextures(frame)
                    frame:SetStatusBarTexture(C.Assets.statusbar_tex)
                    F.SetBD(frame)

                    frame.styled = true
                end
            end
        )
    end
end

THEME:RegisterSkin('BigWigs', THEME.ReskinBigWigs)
THEME:RegisterSkin('BigWigs_Plugins', THEME.RegisterBigWigsStyle)
