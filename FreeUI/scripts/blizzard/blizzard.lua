local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule("blizzard")

function module:OnLogin()
	self:FontStyle()
	self:PetBattleUI()
	self:EnhanceColorPicker()
end







