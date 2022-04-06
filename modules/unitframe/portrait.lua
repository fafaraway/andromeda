local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function PostUpdate(element)
    element:SetDesaturation(1)
end

function UNITFRAME:CreatePortrait(self)
    local portrait = CreateFrame('PlayerModel', nil, self)
    portrait:SetInside()
    portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
    portrait:SetAlpha(.1)

    portrait.PostUpdate = PostUpdate
    self.Portrait = portrait
end

function UNITFRAME:UpdatePortrait()
    for _, frame in pairs(oUF.objects) do
        if C.DB.Unitframe.Portrait then
            if not frame:IsElementEnabled('Portrait') then
                frame:EnableElement('Portrait')
                if frame.Portrait then
                    frame.Portrait:ForceUpdate()
                end
            end
        else
            if frame:IsElementEnabled('Portrait') then
                frame:DisableElement('Portrait')
            end
        end
    end
end
