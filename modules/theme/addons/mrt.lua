local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

local function ReskinMRTWidget(self)
    local iconTexture = self.iconTexture
    local bar = self.statusbar

    if not self.styled then
        F.SetBD(iconTexture)
        self.__bg = F.SetBD(bar)
        self.background:SetAllPoints(bar)

        self.styled = true
    end
    iconTexture:SetTexCoord(unpack(C.TexCoord))
    self.__bg:SetShown(bar:GetWidth() ~= 0)

    local parent = self.parent
    if parent.optionIconPosition == 3 or parent.optionIconTitles then
        -- do nothing
    elseif parent.optionIconPosition == 2 then
        self.icon:SetPoint('RIGHT', self, 3, 0)
    else
        self.icon:SetPoint('LEFT', self, -3, 0)
    end
end

function THEME:ReskinMRT()
    if not IsAddOnLoaded('MRT') then
        return
    end

    local name = 'MRTRaidCooldownCol'
    for i = 1, 10 do
        local column = _G[name .. i]
        local lines = column and column.lines
        if lines then
            for j = 1, #lines do
                local line = lines[j]
                if line.UpdateStyle then
                    hooksecurefunc(line, 'UpdateStyle', ReskinMRTWidget)
                end
            end
        end
    end
end
