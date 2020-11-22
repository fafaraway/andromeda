local F, C = unpack(select(2, ...))

local function ReanchorTutorial(button)
	button.Ring:Hide()
	button:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPLEFT", -12, 12)
end

local function ReskinPvPTalent(self)
	if not self.styled then
		F.ReskinIcon(self.Icon)
		local bg = F.CreateBDFrame(self, .25)
		bg:SetPoint("TOPLEFT", self.Icon, "TOPRIGHT", 0, C.Mult)
		bg:SetPoint("BOTTOMRIGHT", -1, C.Mult)
		local hl = self:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .1)
		hl:SetInside(bg)
		self:GetRegions():SetAlpha(0)
		self.Selected:SetColorTexture(C.r, C.g, C.b, .25)
		self.Selected:SetDrawLayer("BACKGROUND")
		self.styled = true
	end
end

C.Themes["Blizzard_TalentUI"] = function()
	local r, g, b = C.r, C.g, C.b

	PlayerTalentFrameTalents:DisableDrawLayer("BORDER")
	PlayerTalentFrameTalentsBg:Hide()
	ReanchorTutorial(PlayerTalentFrameTalentsTutorialButton)

	PlayerTalentFrameActiveSpecTabHighlight:SetTexture("")
	PlayerTalentFrameTitleGlowLeft:SetTexture("")
	PlayerTalentFrameTitleGlowRight:SetTexture("")
	PlayerTalentFrameTitleGlowCenter:SetTexture("")
	PlayerTalentFrameLockInfoPortraitFrame:Hide()
	PlayerTalentFrameLockInfoPortrait:Hide()

	hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
		for i = 1, NUM_TALENT_FRAME_TABS do
			local tab = _G["PlayerTalentFrameTab"..i]
			local a1, p, a2, x = tab:GetPoint()

			tab:ClearAllPoints()
			if i == 1 then
				tab:SetPoint(a1, p, a2, x, 2)
			else
				tab:SetPoint('LEFT', PlayerTalentFrameTab1, 'RIGHT', -10, 0)
			end
		end
	end)

	for i = 1, NUM_TALENT_FRAME_TABS do
		F.ReskinTab(_G["PlayerTalentFrameTab"..i])
	end

	for _, frame in pairs({PlayerTalentFrameSpecialization, PlayerTalentFramePetSpecialization}) do
		F.StripTextures(frame)
		for _, child in pairs({frame:GetChildren()}) do
			if child:IsObjectType("Frame") and not child:GetName() then
				F.StripTextures(child)
			end
		end
		ReanchorTutorial(_G[frame:GetName().."TutorialButton"])

		for i = 1, 4 do
			local bu = frame["specButton"..i]
			local _, _, _, icon, role = GetSpecializationInfo(i, false, frame.isPet)
			F.StripTextures(bu)
			F.Reskin(bu, true)

			bu.selectedTex:SetColorTexture(r, g, b, .25)
			bu.selectedTex:SetDrawLayer("BACKGROUND")
			bu.selectedTex:SetInside(bu.__bg)

			bu.specIcon:SetTexture(icon)
			bu.specIcon:SetSize(58, 58)
			bu.specIcon:SetPoint("LEFT", bu, "LEFT")
			F.ReskinIcon(bu.specIcon)

			local roleIcon = bu.roleIcon
			roleIcon:SetTexture(C.Assets.roles_icon)
			F.CreateBDFrame(roleIcon):SetFrameLevel(2)
			if role then
				roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
			end
		end

		local scrollChild = frame.spellsScroll.child
		F.StripTextures(scrollChild)
		F.ReskinIcon(scrollChild.specIcon)

		local roleIcon = scrollChild.roleIcon
		roleIcon:SetTexture(C.Assets.roles_icon)
		F.CreateBDFrame(roleIcon)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(self, spec)
		local playerTalentSpec = GetSpecialization(nil, self.isPet, 1)
		local shownSpec = spec or playerTalentSpec or 1
		local numSpecs = GetNumSpecializations(nil, self.isPet)
		local sex = self.isPet and UnitSex("pet") or UnitSex("player")
		local id, _, _, icon, role = GetSpecializationInfo(shownSpec, nil, self.isPet, nil, sex)

		if not id then return end

		local scrollChild = self.spellsScroll.child
		scrollChild.specIcon:SetTexture(icon)
		if role then
			scrollChild.roleIcon:SetTexCoord(F.GetRoleTexCoord(role))
		end

		local index = 1
		local bonuses
		local bonusesIncrement = 1
		if self.isPet then
			bonuses = {GetSpecializationSpells(shownSpec, nil, self.isPet, true)}
			bonusesIncrement = 2
		else
			bonuses = C_SpecializationInfo.GetSpellsDisplay(id)
		end

		if bonuses then
			for i = 1, #bonuses, bonusesIncrement do
				local frame = scrollChild["abilityButton"..index]
				local _, icon = GetSpellTexture(bonuses[i])
				frame.icon:SetTexture(icon)
				frame.subText:SetTextColor(.75, .75, .75)

				if not frame.styled then
					frame.ring:Hide()
					F.ReskinIcon(frame.icon)

					frame.styled = true
				end
				index = index + 1
			end
		end

		for i = 1, numSpecs do
			local bu = self["specButton"..i]
			if bu.disabled then
				bu.roleName:SetTextColor(.5, .5, .5)
			else
				bu.roleName:SetTextColor(1, 1, 1)
			end
		end
	end)

	for i = 1, MAX_TALENT_TIERS do
		local row = _G["PlayerTalentFrameTalentsTalentRow"..i]
		_G["PlayerTalentFrameTalentsTalentRow"..i.."Bg"]:Hide()
		row:DisableDrawLayer("BORDER")

		row.TopLine:SetDesaturated(true)
		row.TopLine:SetVertexColor(r, g, b)
		row.BottomLine:SetDesaturated(true)
		row.BottomLine:SetVertexColor(r, g, b)

		for j = 1, NUM_TALENT_COLUMNS do
			local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
			local ic = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j.."IconTexture"]

			bu:SetHighlightTexture("")
			bu.Cover:SetAlpha(0)
			bu.Slot:SetAlpha(0)
			bu.knownSelection:SetAlpha(0)

			F.ReskinIcon(ic)

			bu.bg = F.CreateBDFrame(bu, .25)
			bu.bg:SetPoint("TOPLEFT", 10, 0)
			bu.bg:SetPoint("BOTTOMRIGHT")
		end
	end

	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_TALENT_TIERS do
			for j = 1, NUM_TALENT_COLUMNS do
				local _, _, _, selected, _, _, _, _, _, _, known = GetTalentInfo(i, j, 1)
				local bu = _G["PlayerTalentFrameTalentsTalentRow"..i.."Talent"..j]
				if known then
					bu.bg:SetBackdropColor(r, g, b, .6)
				elseif selected then
					bu.bg:SetBackdropColor(r, g, b, .25)
				else
					bu.bg:SetBackdropColor(0, 0, 0, .25)
				end
			end
		end
	end)

	F.ReskinPortraitFrame(PlayerTalentFrame)
	F.Reskin(PlayerTalentFrameSpecializationLearnButton)
	F.Reskin(PlayerTalentFrameActivateButton)
	F.Reskin(PlayerTalentFramePetSpecializationLearnButton)

	-- PVP Talents

	F.Reskin(PlayerTalentFrameTalentsPvpTalentButton)
	PlayerTalentFrameTalentsPvpTalentButton:SetSize(20, 20)

	local talentList = PlayerTalentFrameTalentsPvpTalentFrameTalentList
	talentList:ClearAllPoints()
	talentList:SetPoint("LEFT", PlayerTalentFrame, "RIGHT", 3, 0)
	F.StripTextures(talentList)
	F.SetBD(talentList)
	talentList.Inset:Hide()
	F.Reskin(select(4, talentList:GetChildren()), nil)

	F.StripTextures(PlayerTalentFrameTalentsPvpTalentFrame)
	F.ReskinScroll(PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameScrollBar)

	for i = 1, 10 do
		local bu = _G["PlayerTalentFrameTalentsPvpTalentFrameTalentListScrollFrameButton"..i]
		hooksecurefunc(bu, "Update", ReskinPvPTalent)
	end
end
