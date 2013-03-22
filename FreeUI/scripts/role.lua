local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local useSpec = C.automation.autoSetRole_useSpec
local verbose = C.automation.autoSetRole_verbose

local _, class = UnitClass("Player")
local isPureClass
if class == "HUNTER" or class == "MAGE" or class == "ROGUE" or class == "WARLOCK" then
	isPureClass = true
end

local lastMsgTime = 0
local function Print(msg)
	if time() - lastMsgTime > 10 then
		lastMsgTime = time()
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffff"..msg, r, g, b)
	end
end

local function setRoleForSpec(self)
	local spec = GetSpecialization()
	if spec then
		UnitSetRole("player", select(6, GetSpecializationInfo(spec)))
		if verbose then
			Print("Role check: Setting role based on current spec.")
		end
	else
		RolePollPopup_Show(self)
		if verbose then
			Print("Role check: You have no spec, cannot set automatically.")
		end
	end
end

local function autoSetRole(self, event)
	if event ~= "ROLE_POLL_BEGIN" or InCombatLockdown() then return end

	if isPureClass then
		UnitSetRole("player", "DAMAGER")
		if verbose then
			Print("Role check: Setting role to dps.")
		end
	else
		if UnitGroupRolesAssigned("player") == "NONE" then
			if useSpec then
				setRoleForSpec(self)
			else
				if not self:IsShown() then
					RolePollPopup_Show(self)
				end
			end
		else
			if useSpec then
				setRoleForSpec(self)
			else
				if verbose then
					Print("Role check: Role already set, doing nothing.")
				end
			end
		end
	end
end

if C.automation.autoSetRole then
	RolePollPopup:SetScript("OnEvent", autoSetRole)
end

F.AddOptionsCallback("automation", "autoSetRole", function()
	if C.automation.autoSetRole then
		RolePollPopup:SetScript("OnEvent", autoSetRole)
	else
		RolePollPopup:SetScript("OnEvent", RolePollPopup_OnEvent)
	end
end)

F.AddOptionsCallback("automation", "autoSetRole_useSpec", function()
	useSpec = C.automation.autoSetRole_useSpec
end)

F.AddOptionsCallback("automation", "autoSetRole_verbose", function()
	verbose = C.automation.autoSetRole_verbose
end)