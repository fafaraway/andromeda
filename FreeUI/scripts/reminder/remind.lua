local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("reminder")

if not C.reminder.enable then return end

function module:OnLogin()
	self:Interrupt()
	self:Dispel()
	self:Spell()
	self:Resurrect()
	self:Sapped()
	self:Rare()
end