local _G = _G
local unpack = unpack
local select = select
local pairs = pairs
local tinsert = tinsert
local GetCVarBool = GetCVarBool
local CreateFrame = CreateFrame
local C_ChatBubbles_GetAllChatBubbles = C_ChatBubbles.GetAllChatBubbles

local F, C = unpack(select(2, ...))

local function UpdateBorderColor(frame)
    local r, g, b = frame.String:GetTextColor()
    if frame.__shadow then
        frame.__shadow:SetBackdropBorderColor(r, g, b, .25)
    end
end

local function ReskinBubble(chatbubble)
    if chatbubble.styled then
        return
    end

    local frame = chatbubble:GetChildren()
    if frame and not frame:IsForbidden() then
        frame.__bg = F.CreateBDFrame(frame, .75)
        frame.__bg:SetScale(_G.UIParent:GetEffectiveScale())
        frame.__bg:SetInside(frame, 6, 6)
        frame.__shadow = F.CreateSD(frame.__bg)
        F.CreateTex(frame.__bg)
        frame:HookScript('OnShow', UpdateBorderColor)
        frame:DisableDrawLayer('BORDER')
        frame.Tail:SetAlpha(0)

        UpdateBorderColor(frame)
    end

    chatbubble.styled = true
end

tinsert(
    C.BlizzThemes,
    function()
        local events = {
            CHAT_MSG_SAY = 'chatBubbles',
            CHAT_MSG_YELL = 'chatBubbles',
            CHAT_MSG_MONSTER_SAY = 'chatBubbles',
            CHAT_MSG_MONSTER_YELL = 'chatBubbles',
            CHAT_MSG_PARTY = 'chatBubblesParty',
            CHAT_MSG_PARTY_LEADER = 'chatBubblesParty',
            CHAT_MSG_MONSTER_PARTY = 'chatBubblesParty'
        }

        local bubbleHook = CreateFrame('Frame')
        for event in next, events do
            bubbleHook:RegisterEvent(event)
        end
        bubbleHook:SetScript(
            'OnEvent',
            function(self, event)
                if GetCVarBool(events[event]) then
                    self.elapsed = 0
                    self:Show()
                end
            end
        )

        bubbleHook:SetScript(
            'OnUpdate',
            function(self, elapsed)
                self.elapsed = self.elapsed + elapsed
                if self.elapsed > .1 then
                    for _, chatbubble in pairs(C_ChatBubbles_GetAllChatBubbles()) do
                        ReskinBubble(chatbubble)
                    end

                    self:Hide()
                end
            end
        )
        bubbleHook:Hide()
    end
)
