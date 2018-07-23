local F, C, L = unpack(select(2, ...))
if not C.general.rareAlert then return end

local blacklist = {
	[971] = true, -- Alliance garrison
	[976] = true, -- Horde garrison
}

local function OnVignetteAdded(self,event,id)
	if blacklist[GetCurrentMapAreaID()] then return end
	if not id then return end
	self.vignettes = self.vignettes or {}
	if self.vignettes[id] then return end
	local x, y, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id)
	local left, right, top, bottom = GetObjectIconTextureCoords(icon)
	PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
	local str = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t"
	RaidNotice_AddMessage(RaidWarningFrame, str..name.." spotted!", ChatTypeInfo["RAID_WARNING"])
	print(str..name,"spotted!")
	self.vignettes[id] = true
end

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("VIGNETTE_ADDED")
eventHandler:SetScript("OnEvent", OnVignetteAdded)
