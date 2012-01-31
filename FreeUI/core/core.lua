local addon, core = ...

core[1] = {} -- F, Functions
core[2] = {} -- C, Constants/Config
core[3] = {} -- L, Localisation

FreeUI = core

local F, C, L = unpack(select(2, ...))

C.media = {
	["backdrop"] = "Interface\\ChatFrame\\ChatFrameBackground", -- default backdrop
	["checked"] = "Interface\\AddOns\\FreeUI\\media\\CheckButtonHilight", -- replace default checked texture
	["font"] = "Interface\\AddOns\\FreeUI\\media\\Hooge0655.ttf", -- default pixel font
	["font2"] = "Interface\\AddOns\\FreeUI\\media\\font.ttf", -- default font
	["glow"] = "Interface\\AddOns\\FreeUI\\media\\glowTex", -- glow/shadow texture
	["texture"] = "Interface\\AddOns\\FreeUI\\media\\statusbar", -- statusbar texture
}

-- [[ Functions ]]

local function dummy() end

local function CreateBD(f, a)
	f:SetBackdrop({
		bgFile = C.media.backdrop, 
		edgeFile = C.media.backdrop, 
		edgeSize = 1, 
	})
	f:SetBackdropColor(0, 0, 0, a or .5)
	f:SetBackdropBorderColor(0, 0, 0)
end

local function CreateBG(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

local function CreateSD(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = C.media.glow,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -sd.size - 1 - sd.offset, sd.size + 1 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", parent, sd.size + 1 + sd.offset, -sd.size - 1 - sd.offset)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

local function CreateFS(parent, size, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont(C.media.font, size, "OUTLINEMONOCHROME")
    f:SetShadowColor(0, 0, 0, 0)
    if(justify) then f:SetJustifyH(justify) end
    return f
end

local function CreatePulse(frame, speed, mult, alpha) -- pulse function originally by nightcracker
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0 -- time since last update
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end

F.dummy = dummy
F.CreateBD = CreateBD
F.CreateBG = CreateBG
F.CreateSD = CreateSD
F.CreateFS = CreateFS
F.CreatePulse = CreatePulse

-- [[ Saved variables ]]

if not FreeUIGlobalConfig then FreeUIGlobalConfig = {} end
if not FreeUIConfig then FreeUIConfig = {} end

-- [[ High resolution support ]]

local scaler = CreateFrame("Frame")
scaler:RegisterEvent("VARIABLES_LOADED")
scaler:RegisterEvent("UI_SCALE_CHANGED")
scaler:SetScript("OnEvent", function(self, event)
	if not InCombatLockdown() then
		local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
		if scale < .64 then
			UIParent:SetScale(scale)
			ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 50)
		else
			self:SetScript("OnEvent", nil)
		end
	else
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end)