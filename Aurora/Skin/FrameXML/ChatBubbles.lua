local _, private = ...

-- [[ Lua Globals ]]
local next = _G.next

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\ChatBubbles.lua ]]
    local defaultColor = "ffffffff"
    function Hook.UpdateChatBubble(chatbubble, guid, name)
        local color
        if guid ~= nil and guid ~= "" then
            local _, class = _G.GetPlayerInfoByGUID(guid)
            color = _G.CUSTOM_CLASS_COLORS[class].colorStr
        else
            color = defaultColor
        end
        chatbubble._auroraName:SetFormattedText("|c%s%s|r", color, name)
    end
end

do --[[ FrameXML\ChatBubbles.xml ]]
    local tailSize = 16
    function Skin.ChatBubbleFrame(frame)
        local font
        for i = 1, frame:GetNumRegions() do
            local region = _G.select(i, frame:GetRegions())
            if region:GetObjectType() == "Texture" then
                region:SetTexture(nil)
            elseif region:GetObjectType() == "FontString" then
                font = region:GetFontObject()
                frame._auroraText = region
            end
        end

        Base.SetBackdrop(frame)
        frame:SetScale(_G.UIParent:GetScale())

        local tail = frame:CreateTexture(nil, "BORDER")
        tail:SetPoint("TOP", frame, "BOTTOM", -(tailSize / 2), 0) -- places tail about where the old one was
        tail:SetSize(tailSize, tailSize)
        tail:SetColorTexture(0, 0, 0)
        tail:SetVertexOffset(2, tailSize, 0)
        frame._auroraTail = tail

        local name = frame:CreateFontString(nil, "BORDER")
        name:SetPoint("TOPLEFT", 5, 5)
        name:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -5, -5)
        name:SetJustifyH("LEFT")
        name:SetFontObject(font)
        frame._auroraName = name
    end
end

function private.FrameXML.ChatBubbles()
    local function FindChatBubble(msg)
        local chatbubbles = _G.C_ChatBubbles.GetAllChatBubbles()
        for index = 1, #chatbubbles do
            local chatbubble = chatbubbles[index]
            for i = 1, _G.select("#", chatbubble:GetRegions()) do
                local region = _G.select(i, chatbubble:GetRegions())
                if region:GetObjectType() == "FontString" and region:GetText() == msg then
                    return chatbubble
                end
            end
        end
    end

    local events = {
        CHAT_MSG_SAY = "chatBubbles",
        CHAT_MSG_YELL = "chatBubbles",
        CHAT_MSG_MONSTER_SAY = "chatBubbles",
        CHAT_MSG_MONSTER_YELL = "chatBubbles",

        CHAT_MSG_PARTY = "chatBubblesParty",
        CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
        CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
    }
    local bubbleHook = _G.CreateFrame("Frame")
    bubbleHook:SetScript("OnEvent", function(self, event, msg, sender, _, _, _, _, _, _, _, _, _, guid)
        if _G.GetCVarBool(events[event]) then
            self.elapsed = 0
            self.msg = msg
            self.sender = _G.Ambiguate(sender, "none") -- Only show realm if it's not yours
            self.guid = guid
            self:Show()
        end
    end)
    bubbleHook:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = self.elapsed + elapsed
        local chatbubble = FindChatBubble(self.msg)
        if chatbubble or self.elapsed > 0.3 then
            self:Hide()
            if chatbubble then
                if not chatbubble._auroraTail then
                    Skin.ChatBubbleFrame(chatbubble)
                end
                Hook.UpdateChatBubble(chatbubble, self.guid, self.sender)
            end
        end
    end)
    bubbleHook:Hide()
    for event in next, events do
        bubbleHook:RegisterEvent(event)
    end
end
