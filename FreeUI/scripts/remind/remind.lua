local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("Remind")

if not C.remind.enable then return end

function module:OnLogin()
	self:Interrupt()
	self:Dispel()
	self:Spell()
	self:Resurrect()
	self:Sapped()
	self:Rare()
end