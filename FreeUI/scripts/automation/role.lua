local F, C, L = unpack(select(2, ...))


if not C.automation.autoSetRole then return end

local function SetRole()
	local spec = GetSpecialization()
	if C.Level >= 10 and not InCombatLockdown() then
		if spec == nil then
			UnitSetRole('player', 'No Role')
		elseif spec ~= nil then
			if GetNumGroupMembers() > 1 then
				local role = GetSpecializationRole(spec)
				if UnitGroupRolesAssigned('player') ~= role then
					UnitSetRole('player', role)
				end
			end
		end
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_TALENT_UPDATE')
f:RegisterEvent('GROUP_ROSTER_UPDATE')
f:SetScript('OnEvent', SetRole)

RolePollPopup:UnregisterEvent('ROLE_POLL_BEGIN')

