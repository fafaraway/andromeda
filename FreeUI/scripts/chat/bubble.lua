local F, C = unpack(select(2, ...))

local bubbleHook = CreateFrame("Frame")
local last = 0
local numKids = 0
local noscalemult = 1
local tslu = 0
local bubbles = {}

local function styleBubble(frame)
--	local scale = UIParent:GetScale()

	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			frame.text = region
--			region:SetShadowOffset(scale, -scale)
		end
	end

	frame.text:SetFont(C.font.normal, 20, "OUTLINE")
	frame.text:SetJustifyH("LEFT")

	frame:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.glow,
		insets = {left = 2, right = 2, top = 2, bottom = 2},
		tile = false, tileSize = 0, 
		edgeSize = 3,
	})

	frame:SetClampedToScreen(false)
	frame:SetBackdropColor(0, 0, 0, .75)
	frame:SetBackdropBorderColor(0, 0, 0)

	frame:SetScale(_G.UIParent:GetScale())

	tinsert(bubbles, frame)
end

local function isChatBubble(frame)
	if frame:IsForbidden() then return end
	if frame:GetName() then return end
	local region = frame:GetRegions()
	if region and region:IsObjectType("Texture") then
		return region:GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
	end
end

bubbleHook:SetScript("OnUpdate", function(self, elapsed)
	tslu = tslu + elapsed

	if tslu > .1 then
		tslu = 0
		
		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i = numKids + 1, newNumKids do
				local frame = select(i, WorldFrame:GetChildren())

				if isChatBubble(frame) then
					styleBubble(frame)
				end
			end
			numKids = newNumKids
		end

		for i, frame in next, bubbles do
			local r, g, b = frame.text:GetTextColor()
			frame:SetBackdropBorderColor(r, g, b, .8)
		end
	end
end)