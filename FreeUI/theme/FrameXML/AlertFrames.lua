local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local OnShow = {}

	do --[[ Achievement alert ]]
		local r, g, b, a
		local function fixBg(f)
			if f:GetObjectType() == "AnimationGroup" then
				f = f:GetParent()
			end
			f:SetBackdropColor(r, g, b, a)
		end

		OnShow.Achievement = function(self)
			if not self.isSkinned then
				self.Background:Hide()
				F.CreateBD(self)

				r, g, b, a = self:GetBackdropColor()
				self:HookScript("OnEnter", fixBg)
				self:HookScript("OnShow", fixBg)
				self.animIn:HookScript("OnFinished", fixBg)

				self.Unlocked:SetTextColor(1, 1, 1)
				self.GuildName:SetPoint("TOPLEFT", 50, -2)
				self.GuildName:SetPoint("TOPRIGHT", -50, -2)

				self.GuildBanner:SetPoint("TOPRIGHT", -10, 0)
				self.GuildBorder:SetPoint("TOPRIGHT", -10, 0)

				F.ReskinIcon(self.Icon.Texture)
				self.Icon.Overlay:Hide()

				self.isSkinned = true
			end

			self:SetHeight(72)
			self.Icon:SetPoint("TOPLEFT", -26, 23)
			if self.guildDisplay then
				self.Unlocked:SetPoint("TOP", 0, -17)
				self.Name:SetPoint("BOTTOMLEFT", 65, 23)
				self.Name:SetPoint("BOTTOMRIGHT", -65, 23)

				self.Shield:SetPoint("TOPRIGHT", -12, 0)
			else
				self.Unlocked:SetPoint("TOP", 0, -5)
				self.Name:SetPoint("BOTTOMLEFT", 65, 30)
				self.Name:SetPoint("BOTTOMRIGHT", -65, 30)

				self.Shield:SetPoint("TOPRIGHT", -10, -5)
			end
		end
	end

	--[[ Dungeon completion rewards ]]
	local DungeonCompletionAlertFrame = DungeonCompletionAlertFrame
	local bg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame)
	bg:SetPoint("TOPLEFT", 6, -14)
	bg:SetPoint("BOTTOMRIGHT", -6, 6)
	bg:SetFrameLevel(DungeonCompletionAlertFrame:GetFrameLevel()-1)
	F.CreateBD(bg)

	DungeonCompletionAlertFrame.dungeonTexture:SetDrawLayer("ARTWORK")
	DungeonCompletionAlertFrame.dungeonTexture:SetTexCoord(.02, .98, .02, .98)
	DungeonCompletionAlertFrame.dungeonTexture:SetPoint("BOTTOMLEFT", DungeonCompletionAlertFrame, "BOTTOMLEFT", 13, 13)
	DungeonCompletionAlertFrame.dungeonTexture.SetPoint = F.dummy
	F.CreateBG(DungeonCompletionAlertFrame.dungeonTexture)

	DungeonCompletionAlertFrame.raidArt:SetAlpha(0)
	DungeonCompletionAlertFrame.dungeonArt1:SetAlpha(0)
	DungeonCompletionAlertFrame.dungeonArt2:SetAlpha(0)
	DungeonCompletionAlertFrame.dungeonArt3:SetAlpha(0)
	DungeonCompletionAlertFrame.dungeonArt4:SetAlpha(0)

	DungeonCompletionAlertFrame.shine:Hide()
	DungeonCompletionAlertFrame.shine.Show = F.dummy
	DungeonCompletionAlertFrame.glowFrame:Hide()
	DungeonCompletionAlertFrame.glowFrame.Show = F.dummy

	OnShow.DungeonCompletion = function(self)
		local bu = DungeonCompletionAlertFrameReward1
		local index = 1

		while bu do
			if not bu.isSkinned then
				_G["DungeonCompletionAlertFrameReward"..index.."Border"]:Hide()

				bu.texture:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(bu.texture)

				bu.isSkinned = true
			end

			index = index + 1
			bu = _G["DungeonCompletionAlertFrameReward"..index]
		end
	end

	--[[ Guild challenges ]]
	local challenge = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
	challenge:SetPoint("TOPLEFT", 8, -12)
	challenge:SetPoint("BOTTOMRIGHT", -8, 13)
	challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
	F.CreateBD(challenge)
	F.CreateBG(GuildChallengeAlertFrameEmblemBackground)
	select(2, GuildChallengeAlertFrame:GetRegions()):Hide()

	GuildChallengeAlertFrameGlow:SetTexture("")
	GuildChallengeAlertFrameShine:SetTexture("")
	GuildChallengeAlertFrameEmblemBorder:SetTexture("")

    hooksecurefunc(AlertFrame, "AddAlertFrame", function(self, frame)
    	local frameName = frame:GetName()
    	if frameName then
    		local alertName = frameName:match("(%w+)AlertFrame")
    		if OnShow[alertName] then OnShow[alertName](frame) end
    	else
    		-- QueueAlertFrames are created dynamicly and do not have names
    		if frame.Unlocked then
    			-- Achievement alert
    			if frame.Unlocked:GetText() == ACHIEVEMENT_PROGRESSED then
    			else
    				OnShow.Achievement(frame)
    			end
    		end
    	end
    end)
end)
