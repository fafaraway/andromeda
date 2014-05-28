-- local F, C, L = unpack(select(2, ...))

-- local bottompanel = CreateFrame("Frame", nil, UIParent)
-- bottompanel:SetFrameStrata("BACKGROUND")
-- bottompanel:SetHeight(13)
-- bottompanel:SetPoint("BOTTOMLEFT", -1, -1)
-- bottompanel:SetPoint("BOTTOMRIGHT", 1, -1)
-- bottompanel:SetBackdrop({
	-- edgeFile = C.media.backdrop,
	-- edgeSize = 1,
-- })
-- bottompanel:SetBackdropBorderColor(0, 0, 0)

-- local function onEvent(event)
	-- if event == "PLAYER_REGEN_DISABLED" then
		-- bottompanel:SetBackdropBorderColor(1, 0, 0)
	-- else
		-- bottompanel:SetBackdropBorderColor(0, 0, 0)
	-- end
-- end

-- F.RegisterEvent("PLAYER_REGEN_DISABLED", onEvent)
-- F.RegisterEvent("PLAYER_REGEN_ENABLED", onEvent)

-- local overlay = bottompanel:CreateTexture(nil, "BORDER")
-- overlay:SetPoint("TOPLEFT", 0, -1)
-- overlay:SetPoint("BOTTOMRIGHT")
-- overlay:SetTexture(C.media.backdrop)
-- overlay:SetGradientAlpha("VERTICAL", .1, .1, .1, .5, 0, 0, 0, .5)

-- Queue popup timer!

-- local LFD_QUEUE_TIMEOUT = 40

-- local timer = CreateFrame("StatusBar", nil, bottompanel)
-- timer:SetPoint("TOPLEFT")
-- timer:SetPoint("TOPRIGHT")
-- timer:SetHeight(1)
-- timer:SetStatusBarTexture(C.media.backdrop)
-- timer:SetStatusBarColor(unpack(C.class))
-- timer:SetMinMaxValues(0, LFD_QUEUE_TIMEOUT)
-- timer:Hide()

-- local count = 0

-- timer:SetScript("OnUpdate", function(self, elapsed)
	-- count = count + elapsed
	-- if count < LFD_QUEUE_TIMEOUT then
		-- timer:SetValue(count)
	-- else
		-- self:Hide()
		-- count = 0
		-- self:SetValue(0)
	-- end
-- end)

-- timer:RegisterEvent("LFG_PROPOSAL_SHOW")
-- timer:RegisterEvent("LFG_PROPOSAL_FAILED")
-- timer:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
-- timer:SetScript("OnEvent", function(self, event)
	-- if event == "LFG_PROPOSAL_SHOW" then
		-- self:Show()
	-- else
		-- self:Hide()
		-- count = 0
		-- self:SetValue(0)
	-- end
-- end)