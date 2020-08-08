local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FreeUIConfigs['theme']['reskin_blizz'] then return end

	local bubbleHook = CreateFrame('Frame')
	local last = 0
	local numKids = 0
	local noscalemult = 1
	local tslu = 0
	local bubbles = {}

	local function styleBubble(frame)
		if frame:IsForbidden() then return end

		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region:GetObjectType() == 'Texture' then
				region:SetTexture(nil)
			elseif region:GetObjectType() == 'FontString' then
				frame.text = region
			end
		end

		frame:SetClampedToScreen(false)

		F.CreateBD(frame)
		F.CreateSD(frame)
		F.CreateTex(frame)
		frame:SetScale(UIParent:GetScale())

		tinsert(bubbles, frame)
	end

	local function isChatBubble(frame)
		if frame:IsForbidden() then return end
		if frame:GetName() then return end
		local region = frame:GetRegions()
		if region and region:IsObjectType('Texture') then
			return region:GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
		end
	end


	bubbleHook:SetScript('OnUpdate', function(self, elapsed)
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
				frame.Shadow:SetBackdropBorderColor(r, g, b, .75)
			end
		end
	end)
end)
