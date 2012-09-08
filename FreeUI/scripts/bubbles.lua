local F, C, L = unpack(select(2, ...))

local f = CreateFrame("Frame")

local function styleBubble(frame)
	for i = 1, frame:GetNumRegions() do
		local region = select(i, frame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		end
	end

	frame:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = UIParent:GetScale(),
	})
	frame:SetBackdropColor(0, 0, 0, .5)
	frame:SetBackdropBorderColor(0, 0, 0)
end

local function isChatBubble(frame)
	if frame:GetName() then return end
	if not frame:GetRegions() then return end
	return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
end

local freq = C.performance.bubbles
local last = 0
local numKids = 0

f:SetScript("OnUpdate", function(self, elapsed)
	last = last + elapsed
	if last > freq then
		last = 0
		local newNumKids = WorldFrame:GetNumChildren()
		if newNumKids ~= numKids then
			for i=numKids + 1, newNumKids do
				local frame = select(i, WorldFrame:GetChildren())

				if isChatBubble(frame) then
					styleBubble(frame)
				end
			end
			numKids = newNumKids
		end
	end
end)