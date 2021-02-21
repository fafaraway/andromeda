local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local GetTime = GetTime
local GetNumGroupMembers = GetNumGroupMembers
local GetSpellTexture = GetSpellTexture

local F = unpack(select(2, ...))
local OUF = F.OUF

local function Update(self, event, unit, _, spellID)
    if unit ~= self.unit then
        return
    end

    local element = self.PartyWatcher
    local maxButtons = element.maxButtons
    local index = element.index
    local duration = element.PartySpells[spellID]
    local talentCDFix = element.TalentCDFix[spellID]

    if duration then
        local thisTime = GetTime()
        local button = element.spellToButton[spellID]
        if not button then
            if index == maxButtons then
                return
            end
            index = index + 1
            button = element[index]
            button.lastTime = thisTime
            button.Icon:SetTexture(GetSpellTexture(spellID))
            button.spellID = spellID
            button:Show()

            element.index = index
            element.spellToButton[spellID] = button
        end

        if talentCDFix and (duration >= thisTime - button.lastTime + 1) then -- allow 1s latency
            duration = talentCDFix
        end
        button.lastTime = thisTime
        button.CD:SetCooldown(thisTime, duration)

        if element.PostUpdate then
            element:PostUpdate(button, unit, spellID)
        end
    end
end

local function ResetButtons(self)
    local element = self.PartyWatcher
    element.index = 0
    wipe(element.spellToButton)
    for i = 1, element.__max do
        local button = element[i]
        button.spellID = nil
        button:Hide()
    end
end

local function ResetButtonsWithCheck(self)
    local element = self.PartyWatcher
    local numMembers = GetNumGroupMembers()
    if not element.lastCount or element.lastCount ~= numMembers then
        ResetButtons(self)
        element.lastCount = numMembers
    end
end

local function Enable(self)
    local element = self.PartyWatcher

    if element then
        element.index = 0
        element.maxButtons = #element
        element.spellToButton = {}
        self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', Update)
        self:RegisterEvent('GROUP_LEFT', ResetButtons, true)
        self:RegisterEvent('CHALLENGE_MODE_START', ResetButtons, true)
        self:RegisterEvent('GROUP_ROSTER_UPDATE', ResetButtonsWithCheck, true)
        return true
    end
end

local function Disable(self)
    local element = self.PartyWatcher

    if element then
        self:UnregisterEvent('UNIT_SPELLCAST_SUCCEEDED', Update)
        self:UnregisterEvent('GROUP_LEFT', ResetButtons)
        self:UnregisterEvent('CHALLENGE_MODE_START', ResetButtons)
        self:UnregisterEvent('GROUP_ROSTER_UPDATE', ResetButtonsWithCheck)
    end
end

OUF:AddElement('PartyWatcher', nil, Enable, Disable)
