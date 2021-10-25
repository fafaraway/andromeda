local _G = _G
local unpack = unpack
local select = select
local GetTime = GetTime
local GetActionCooldown = GetActionCooldown
local hooksecurefunc = hooksecurefunc

local F, C = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

-- Desaturate the action icon when the spell is on cooldown

local minDuration = 1.51
local updateFuncCache = {}
local desaturateHooked = false

local function DesaturateUpdateCooldown(self, expectedUpdate)
    local icon = self.icon
    local action = self.action

    if (icon and action) then
        local start, duration = GetActionCooldown(action)

        if (duration >= minDuration) then
            if start > 3085367 and start <= 4294967.295 then
                start = start - 4294967.296
            end

            if ((not self.onCooldown) or (self.onCooldown == 0)) then
                local nextTime = start + duration - GetTime() - 1.0

                if (nextTime < -1.0) then
                    nextTime = 0.05
                elseif (nextTime < 0) then
                    nextTime = -nextTime / 2
                end

                if nextTime <= 4294967.295 then
                    local func = updateFuncCache[self]

                    if not func then
                        func = function()
                            DesaturateUpdateCooldown(self, true)
                        end
                        updateFuncCache[self] = func
                    end

                    F:Delay(nextTime, func)
                end
            elseif (expectedUpdate) then
                if ((not self.onCooldown) or (self.onCooldown < start + duration)) then
                    self.onCooldown = start + duration
                end

                local nextTime = 0.05
                local timeRemains = self.onCooldown - GetTime()

                if (timeRemains > 0.31) then
                    nextTime = timeRemains / 5
                elseif (timeRemains < 0) then
                    nextTime = 0.05
                end

                if nextTime <= 4294967.295 then
                    local func = updateFuncCache[self]
                    if not func then
                        func = function()
                            DesaturateUpdateCooldown(self, true)
                        end
                        updateFuncCache[self] = func
                    end

                    F:Delay(nextTime, func)
                end
            end

            if ((not self.onCooldown) or (self.onCooldown < start + duration)) then
                self.onCooldown = start + duration
            end

            if (not icon:IsDesaturated()) then
                icon:SetDesaturated(true)
            end
        else
            self.onCooldown = 0

            if (icon:IsDesaturated()) then
                icon:SetDesaturated(false)
            end
        end
    end
end

function ACTIONBAR:CooldownDesaturate()
    if not C.DB.Actionbar.CooldownDesaturate then
        return
    end

    if (not desaturateHooked) then
        hooksecurefunc('ActionButton_UpdateCooldown', DesaturateUpdateCooldown)
        desaturateHooked = true
    end
end
