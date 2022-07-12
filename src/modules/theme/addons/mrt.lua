local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

local function ReskinMRTWidget(self)
    local iconTexture = self.iconTexture
    local bar = self.statusbar
    local parent = self.parent
    local width = parent.barWidth or 100
    local mult = (parent.iconSize or 24) + 5
    local offset = 3

    if not self.styled then
        F.SetBD(iconTexture)
        self.__bg = F.SetBD(bar)
        self.background:SetAllPoints(bar)

        self.styled = true
    end
    iconTexture:SetTexCoord(unpack(C.TEX_COORD))
    self.__bg:SetShown(parent.optionAlphaTimeLine ~= 0)

    if parent.optionIconPosition == 3 or parent.optionIconTitles then
        self.statusbar:SetPoint('RIGHT', self, -offset, 0)
        mult = 0
    elseif parent.optionIconPosition == 2 then
        self.icon:SetPoint('RIGHT', self, -offset, 0)
        self.statusbar:SetPoint('LEFT', self, offset, 0)
        self.statusbar:SetPoint('RIGHT', self, -mult, 0)
    else
        self.icon:SetPoint('LEFT', self, offset, 0)
        self.statusbar:SetPoint('LEFT', self, mult, 0)
        self.statusbar:SetPoint('RIGHT', self, -offset, 0)
    end

    self.timeline.width = width - mult - offset
    self.timeline:SetWidth(self.timeline.width)

    self.border.top:Hide()
    self.border.bottom:Hide()
    self.border.left:Hide()
    self.border.right:Hide()
end

local MRTLoaded
local function LoadMRTSkin()
    if MRTLoaded then
        return
    end
    MRTLoaded = true

    local name = 'MRTRaidCooldownCol'
    for i = 1, 10 do
        local column = _G[name .. i]
        local lines = column and column.lines
        if lines then
            for j = 1, #lines do
                local line = lines[j]
                if line.UpdateStyle then
                    hooksecurefunc(line, 'UpdateStyle', ReskinMRTWidget)
                    line:UpdateStyle()
                end
            end
        end
    end
end

function THEME:ReskinMRT()
    if not IsAddOnLoaded('MRT') then
        return
    end

    if not _G.ANDROMEDA_ADB.ReskinMethodRaidTools then
        return
    end

    local isEnabled = _G.VMRT and _G.VMRT.ExCD2 and _G.VMRT.ExCD2.enabled
    if isEnabled then
        LoadMRTSkin()
    else
        hooksecurefunc(_G.MRTOptionsFrameExCD2, 'Load', function(self)
            if self.chkEnable then
                self.chkEnable:HookScript('OnClick', LoadMRTSkin)
            end
        end)
    end

    -- Consumables
    local buttons = _G.MRTConsumables and _G.MRTConsumables.buttons
    if buttons then
        for i = 1, 8 do
            local button = buttons[i]
            local icon = button and button.texture
            if icon then
                F.ReskinIcon(icon)
            end
        end
    end
end
