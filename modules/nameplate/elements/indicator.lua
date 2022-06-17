local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')
local oUF = F.Libs.oUF

function NAMEPLATE.ConfigureTargetIndicator(frame)
    local icon = frame.RaidTargetIndicator
    local enable = C.DB.Nameplate.RaidTargetIndicator
    local nameOnly = frame.plateType == 'NameOnly'
    local name = frame.NameTag

    if nameOnly then
        icon:ClearAllPoints()
        icon:SetPoint('TOP', name, 'BOTTOM')
        icon:SetParent(frame)
    else
        icon:ClearAllPoints()
        icon:SetPoint('CENTER', frame, 'BOTTOM')
        icon:SetParent(frame.Health)
    end

    icon:SetAlpha(1)
    icon:SetSize(8, 8)
    icon:SetScale(2)
    icon:SetShown(enable)
end

function NAMEPLATE:CreateRaidTargetIndicator(self)
    local icon = self:CreateTexture(nil, 'OVERLAY')

    self.RaidTargetIndicator = icon

    NAMEPLATE.ConfigureTargetIndicator(self)
end

function NAMEPLATE:UpdateRaidTargetIndicator()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'nameplate' then
            if C.DB.Nameplate.RaidTargetIndicator then
                if not frame:IsElementEnabled('RaidTargetIndicator') then
                    frame:EnableElement('RaidTargetIndicator')
                    if frame.RaidTargetIndicator then
                        frame.RaidTargetIndicator:ForceUpdate()
                    end
                end
            else
                if frame:IsElementEnabled('RaidTargetIndicator') then
                    frame:DisableElement('RaidTargetIndicator')
                end
            end
        end
    end
end
