-- aMail by Alza, modified.

local F, C, L = unpack(select(2, ...))

local button = CreateFrame("Button", "aMailButton", InboxFrame, "UIPanelButtonTemplate")
button:SetPoint("BOTTOM", InboxFrame, "BOTTOM", -10, 92)
button:SetWidth(128)
button:SetHeight(25)

local text = F.CreateFS(button, 8)
text:SetPoint"CENTER"

local processing = false

local function OnEvent()
	if(not MailFrame:IsShown()) then return end

	local num = GetInboxNumItems()

	local cash = 0
	local items = 0
	for i = 1, num do
		local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
		if(item and COD<1) then items = items + item end
		cash = cash + money
	end
	text:SetText(format("%d gold, %d items", floor(cash * 0.0001), items))

	if(processing) then
		if(num==0) then
			processing = false
			return
		end

		for i = num, 1, -1 do
			local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
			if(item and COD<1) then
				TakeInboxItem(i)
				return
			end
			if(money>0) then
				TakeInboxMoney(i)
				return
			end
		end
	end
end

local function OnClick()
	FreeUIMailFrame:Hide()
	MiniMapMailFrame:Hide()
	if(not processing) then
		processing = true
		OnEvent()
	end
end

local function OnHide()
	processing = false
end

button:RegisterEvent("MAIL_INBOX_UPDATE")
button:SetScript("OnEvent", OnEvent)
button:SetScript("OnClick", OnClick)
button:SetScript("OnHide", OnHide)