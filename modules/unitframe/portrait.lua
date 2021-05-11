local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

--[[ Portrait ]]

local function PostUpdatePortrait(element)
    element:SetDesaturation(1)
end

function UNITFRAME:AddPortrait(self)
    if not C.DB.Unitframe.Portrait then
        return
    end

    local portrait = CreateFrame('PlayerModel', nil, self)
    portrait:SetInside()
    portrait:SetFrameLevel(self.Health:GetFrameLevel() + 2)
    portrait:SetAlpha(.1)
    portrait.PostUpdate = PostUpdatePortrait
    self.Portrait = portrait
end
