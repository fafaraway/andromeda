local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local function Portrait_PreUpdate(element)
    element:SetShown(C.DB.Unitframe.Portrait)
end

local function Portrait_PostUpdate(element)
    element:SetDesaturation(1)
end

function UNITFRAME:CreatePortrait(self)
    local portrait = CreateFrame('PlayerModel', nil, self)
    portrait:SetInside()
    portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
    portrait:SetAlpha(.1)
    portrait.PreUpdate = Portrait_PreUpdate
    portrait.PostUpdate = Portrait_PostUpdate
    self.Portrait = portrait
end
