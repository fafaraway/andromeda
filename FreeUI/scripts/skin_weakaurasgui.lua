local F, C, L = unpack(select(2, ...))

local function StripTextures(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = _G.select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end
end

local function InitStyleWAO()
	local function Skin_WeakAurasOptions(...)
		--print("Options opened", ...)
		local frame = _G.WeakAuras.OptionsFrame()
		if frame.skinned then return end

		local r, g, b = C.r, C.g, C.b
		local children = {frame:GetChildren()}

		-- Close button
		children[1]:Hide()
		local close = children[1]:GetChildren()
		close:SetParent(frame)
		F.ReskinClose(close)

		-- Disable import check
		children[2]:Hide()
		local import = children[2]:GetChildren()
		F.ReskinCheck(import)
		import:SetParent(frame)
		import:SetSize(25, 25)
		import:ClearAllPoints()
		import:SetPoint("TOPRIGHT", close, "TOPLEFT", -24, 4)

		-- Title
		--children[3]

		-- Frame size handle
		local sizer = children[4]
		sizer:SetNormalTexture("")
		sizer:SetHighlightTexture("")
		sizer:SetPushedTexture("")

		for i = 1, 3 do
			local tex = sizer:CreateTexture(nil, "OVERLAY")
			tex:SetSize(2, 2)
			tex:SetTexture(C.media.backdrop)
			tex:SetVertexColor(r, g, b, .8)
			tex:Show()
			sizer[i] = tex
		end
		sizer[1]:SetPoint("BOTTOMLEFT", sizer, "BOTTOMLEFT", 6, 6)
		sizer[2]:SetPoint("BOTTOMLEFT", sizer[1], "TOPLEFT", 0, 4)
		sizer[3]:SetPoint("BOTTOMLEFT", sizer[1], "BOTTOMRIGHT", 4, 0)

		-- Minimize button
		children[5]:Hide()
		local minimize = children[5]:GetChildren()
		F.ReskinArrow(minimize, "up")
		minimize:SetParent(frame)
		minimize:SetSize(17, 17)
		minimize:ClearAllPoints()
		minimize:SetPoint("TOPRIGHT", close, "TOPLEFT", -5, 0)

		-- Tutorial
		--children[6]
		local _, _, _, enabled, loadable = _G.GetAddOnInfo("WeakAurasTutorials")
		local tutOfs = (enabled and loadable) and 1 or 0

		--[[ Ace groups
			children[6+tutOfs] container
			children[7+tutOfs] texturePick
			children[8+tutOfs] iconPick
			children[9+tutOfs] modelPick
			children[10+tutOfs] importexport
			children[11+tutOfs] texteditor
			children[12+tutOfs] codereview
			children[13+tutOfs] buttonsContainer
		]]

		-- Selected aura border/sizer
		-- local moversizer = children[14+tutOfs]
		-- moversizer.bl.l:SetColorTexture(r, g, b, .8)
		-- moversizer.bl.l:SetPoint("BOTTOMLEFT", moversizer.bl, "BOTTOMLEFT", 1, 1)
		-- moversizer.bl.b:SetColorTexture(r, g, b, .8)

		-- moversizer.br.r:SetColorTexture(r, g, b, .8)
		-- moversizer.br.r:SetPoint("BOTTOMRIGHT", moversizer.br, "BOTTOMRIGHT", -1, 1)
		-- moversizer.br.b:SetColorTexture(r, g, b, .8)

		-- moversizer.tl.l:SetColorTexture(r, g, b, .8)
		-- moversizer.tl.l:SetPoint("TOPLEFT", moversizer.tl, "TOPLEFT", 1, -1)
		-- moversizer.tl.t:SetColorTexture(r, g, b, .8)

		-- moversizer.tr.r:SetColorTexture(r, g, b, .8)
		-- moversizer.tr.r:SetPoint("TOPRIGHT", moversizer.tr, "TOPRIGHT", -1, -1)
		-- moversizer.tr.t:SetColorTexture(r, g, b, .8)

		-- moversizer.l.l:SetColorTexture(r, g, b, .8)
		-- moversizer.l.l:SetPoint("BOTTOMLEFT", moversizer.bl, "BOTTOMLEFT", 1, 1)
		-- moversizer.l.l:SetPoint("TOPRIGHT", moversizer.tl, "TOP", 0, -1)

		-- moversizer.b.b:SetColorTexture(r, g, b, .8)
		-- moversizer.b.b:SetPoint("BOTTOMLEFT", moversizer.bl, "BOTTOMLEFT", 1, 1)
		-- moversizer.b.b:SetPoint("TOPRIGHT", moversizer.br, "RIGHT", -1, 0)

		-- moversizer.r.r:SetColorTexture(r, g, b, .8)
		-- moversizer.r.r:SetPoint("BOTTOMRIGHT", moversizer.br, "BOTTOMRIGHT", -1, 1)
		-- moversizer.r.r:SetPoint("TOPLEFT", moversizer.tr, "TOP", 0, -1)

		-- moversizer.t.t:SetColorTexture(r, g, b, .8)
		-- moversizer.t.t:SetPoint("TOPRIGHT", moversizer.tr, "TOPRIGHT", -1, -1)
		-- moversizer.t.t:SetPoint("BOTTOMLEFT", moversizer.tl, "LEFT", 1, 0)

		-- F.CreateBD(moversizer, .01)

		-- Search
		F.ReskinInput(_G.WeakAurasFilterInput)

		-- Remove Title BG
		StripTextures(frame)

		-- StripTextures will actually remove the backdrop too, so we need to put that back
		F.CreateBD(frame)
		F.CreateSD(frame)
		frame.skinned = true
	end
	_G.hooksecurefunc(_G.WeakAuras, "ShowOptions", Skin_WeakAurasOptions)
end

if IsAddOnLoaded("WeakAurasOptions") then
	InitStyleWAO()
else
	local load = CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "WeakAurasOptions" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyleWAO()

		load = nil
	end)
end
