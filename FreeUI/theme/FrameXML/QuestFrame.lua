local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	F.ReskinPortraitFrame(QuestFrame, true)

	--[[ QuestFrame ]]

	hooksecurefunc("QuestFrame_SetMaterial", function(frame, material)
		if material ~= "Parchment" then
			local name = frame:GetName()
			_G[name.."MaterialTopLeft"]:Hide()
			_G[name.."MaterialTopRight"]:Hide()
			_G[name.."MaterialBotLeft"]:Hide()
			_G[name.."MaterialBotRight"]:Hide()
		end
	end)

	--[[ Reward Panel ]]

	QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameRewardPanel:DisableDrawLayer("BORDER")
	F.Reskin(QuestFrameCompleteQuestButton)

	QuestRewardScrollFrameTop:Hide()
	QuestRewardScrollFrameBottom:Hide()
	QuestRewardScrollFrameMiddle:Hide()
	F.ReskinScroll(QuestRewardScrollFrame.ScrollBar)

	--[[ Progress Panel ]]
	QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameProgressPanel:DisableDrawLayer("BORDER")

	F.Reskin(QuestFrameGoodbyeButton)
	F.Reskin(QuestFrameProgressPanel.IgnoreButton)
	F.Reskin(QuestFrameProgressPanel.UnignoreButton)
	F.Reskin(QuestFrameCompleteButton)

	QuestProgressScrollFrameTop:Hide()
	QuestProgressScrollFrameBottom:Hide()
	QuestProgressScrollFrameMiddle:Hide()
	F.ReskinScroll(QuestProgressScrollFrame.ScrollBar)

	QuestProgressTitleText:SetTextColor(1, 1, 1)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText.SetTextColor = F.dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = F.dummy
	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		F.CreateBD(bu, .25)

		bu.Icon:SetPoint("TOPLEFT", 1, -1)
		bu.Icon:SetDrawLayer("OVERLAY")
		F.ReskinIcon(bu.Icon)

		bu.NameFrame:Hide()
		bu.Count:SetDrawLayer("OVERLAY")
	end

	--[[ Detail Panel ]]
	QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
	QuestFrameDetailPanel:DisableDrawLayer("BORDER")

	F.Reskin(QuestFrameDeclineButton)
	F.Reskin(QuestFrameDetailPanel.IgnoreButton)
	F.Reskin(QuestFrameDetailPanel.UnignoreButton)
	F.Reskin(QuestFrameAcceptButton)

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off
	QuestDetailScrollFrameTop:Hide()
	QuestDetailScrollFrameBottom:Hide()
	QuestDetailScrollFrameMiddle:Hide()
	F.ReskinScroll(QuestDetailScrollFrame.ScrollBar)

	--[[ Greeting Panel ]]
	QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
	F.Reskin(QuestFrameGreetingGoodbyeButton)

	QuestGreetingScrollFrameTop:Hide()
	QuestGreetingScrollFrameBottom:Hide()
	QuestGreetingScrollFrameMiddle:Hide()
	F.ReskinScroll(QuestGreetingScrollFrame.ScrollBar)

	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = F.dummy
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = F.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = F.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)

	local hRule = QuestFrameGreetingPanel:CreateTexture()
	hRule:SetColorTexture(1, 1, 1, .2)
	hRule:SetSize(256, 1)
	hRule:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

	QuestGreetingFrameHorizontalBreak:SetTexture("")
	QuestFrameGreetingPanel:HookScript("OnShow", function()
		hRule:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	-- [[ Quest NPC model ]]
	QuestNPCModelBg:Hide()
	QuestNPCModel:DisableDrawLayer("OVERLAY")
	QuestNPCModelNameText:SetDrawLayer("ARTWORK")

	QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")
	QuestNPCModelTextFrameBg:Hide()
	F.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 1)
	npcbd:SetPoint("RIGHT", 2, 0)
	npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
	npcbd:SetFrameLevel(0)
	F.CreateBD(npcbd)

	local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
	npcLine:SetPoint("BOTTOMLEFT", 0, -1)
	npcLine:SetPoint("BOTTOMRIGHT", 1, -1)
	npcLine:SetHeight(1)
	npcLine:SetFrameLevel(0)
	F.CreateBD(npcLine, 0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)
end)
