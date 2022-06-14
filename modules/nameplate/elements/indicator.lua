local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')

function NAMEPLATE.UpdateRaidTargetIndicator(frame)
    local icon = frame.RaidTargetIndicator
    local enable = C.DB.Nameplate.RaidTargetIndicator
    local nameOnly = frame.plateType == 'NameOnly'
    local name = frame.NameTag

    if nameOnly then
        icon:SetPoint('BOTTOM', name, 'TOP')
    else
        icon:ClearAllPoints()
        icon:SetPoint('LEFT', frame, 'RIGHT', 4, 0)
    end

    icon:SetAlpha(1)
    icon:SetSize(frame:GetHeight(), frame:GetHeight())
    icon:SetScale(2)
    icon:SetShown(enable)
end

function NAMEPLATE:CreateRaidTargetIndicator(self)
    local icon = self:CreateTexture(nil, 'OVERLAY')

    self.RaidTargetIndicator = icon

    NAMEPLATE.UpdateRaidTargetIndicator(self)
end
