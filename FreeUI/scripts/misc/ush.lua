local F, C, L = unpack(select(2, ...))
local module = F:GetModule("misc")

-- UI setup helper by Constie

local toggle = 0

local shadeFrame = CreateFrame("Frame")
local shadeTexture = shadeFrame:CreateTexture(nil, "BACKGROUND", nil, -8)

shadeFrame:SetFrameStrata("BACKGROUND")
shadeFrame:SetWidth(GetScreenWidth() * UIParent:GetEffectiveScale())
shadeFrame:SetHeight(GetScreenHeight() * UIParent:GetEffectiveScale())
shadeTexture:SetAllPoints(shadeFrame)
shadeFrame:SetPoint("CENTER", 0, 0)

local crosshairFrameNS = CreateFrame("Frame")
local crosshairTextureNS = crosshairFrameNS:CreateTexture(nil, "TOOLTIP")

crosshairFrameNS:SetFrameStrata("TOOLTIP")
crosshairFrameNS:SetWidth(1)
crosshairFrameNS:SetHeight(GetScreenHeight() * UIParent:GetEffectiveScale())
crosshairTextureNS:SetAllPoints(crosshairFrameNS)
crosshairTextureNS:SetColorTexture(0, 0, 0, 1)

local crosshairFrameEW = CreateFrame("Frame")
local crosshairTextureEW = crosshairFrameEW:CreateTexture(nil, "TOOLTIP")

crosshairFrameEW:SetFrameStrata("TOOLTIP")
crosshairFrameEW:SetWidth(GetScreenWidth() * UIParent:GetEffectiveScale())
crosshairFrameEW:SetHeight(1)
crosshairTextureEW:SetAllPoints(crosshairFrameEW)
crosshairTextureEW:SetColorTexture(0, 0, 0, 1)

local function clear()
  shadeFrame:Hide()
  crosshairFrameNS:Hide()
  crosshairFrameEW:Hide()
end

local function shade(r, g, b, a)
  shadeTexture:SetColorTexture(r, g, b, a)
  shadeFrame:Show()
end

local function follow()
  local mouseX, mouseY = GetCursorPosition()
  crosshairFrameNS:SetPoint("TOPLEFT", mouseX, 0)
  crosshairFrameEW:SetPoint("BOTTOMLEFT", 0, mouseY)
end

local function crosshair(arg)
  local mouseX, mouseY = GetCursorPosition()
  crosshairFrameNS:SetPoint("TOPLEFT", mouseX, 0)
  crosshairFrameEW:SetPoint("BOTTOMLEFT", 0, mouseY)
  crosshairFrameNS:Show()
  crosshairFrameEW:Show()
  if arg == "follow" then
    crosshairFrameNS:SetScript("OnUpdate", follow)
  else
    crosshairFrameNS:SetScript("OnUpdate", nil)
  end
end

local function SlashCmdList_AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func
    local command = ''
    for i = 1, select('#', ...) do
        command = select(i, ...)
        if strsub(command, 1, 1) ~= '/' then
            command = '/' .. command
        end
        _G['SLASH_'..name..i] = command
    end
end

SlashCmdList_AddSlashCommand('UISETUPHELPER_SLASHCMD', function(arg)
    if arg == "dark" then
      shade(0, 0, 0, 0.85)
      crosshairTextureNS:SetColorTexture(1, 1, 1, 1)
      crosshairTextureEW:SetColorTexture(1, 1, 1, 1)
    elseif arg == "light" then
      shade(1, 1, 1, 0.85)
      crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
      crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
    elseif arg == "clear" then
      clear()
      toggle = 0
    elseif arg == "align" or arg == "follow" then
      crosshair(arg)
    else
      if toggle == 0 then
        shade(1, 1, 1, 0.85)
        crosshairTextureNS:SetColorTexture(0, 0, 0, 1)
        crosshairTextureEW:SetColorTexture(0, 0, 0, 1)
        crosshair("follow")
        toggle = 1
      else
        clear()
      end
    end
end, 'uisetuphelper', 'ush')