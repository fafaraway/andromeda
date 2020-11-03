local F, C, L = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD


local text
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
	text:SetText(C.InfoColor..format('%d '..L['BLIZZARD_GOLD']..' %d '..ITEMS, floor(cash * 0.0001), items))

	if(processing) then
		if(num==0) then
			processing = false
			return
		end

		for i = num, 1, -1 do
			local _, _, _, _, money, COD, _, itemCount, _, _, _, _, isGM = GetInboxHeaderInfo(i)
			if not isGM then
				if(itemCount and COD<1) then
					AutoLootMailItem(i)
					return
				end
				if(money>0) then
					TakeInboxMoney(i)
					return
				end
			end
		end
	end
end

local function OnClick()
	if(not processing) then
		processing = true
		OnEvent()
	end
end

local function OnHide()
	processing = false
end


function BLIZZARD:MailButton()
	if not C.DB.blizzard.mail_button then return end

	_G.OpenAllMail:Hide()
	_G.OpenAllMail:UnregisterAllEvents()

	local b = CreateFrame('Button', 'FreeUI_MailButton', _G.InboxFrame, 'UIPanelButtonTemplate')
	b:SetPoint('BOTTOM', _G.InboxFrame, 'BOTTOM', -20, 102)
	b:SetWidth(128)
	b:SetHeight(25)
	F.Reskin(b)

	text = F.CreateFS(b, C.Assets.Fonts.Regular, 11, nil, nil, nil, true)

	b:RegisterEvent('MAIL_INBOX_UPDATE')
	b:SetScript('OnEvent', OnEvent)
	b:SetScript('OnClick', OnClick)
	b:SetScript('OnHide', OnHide)
end
BLIZZARD:RegisterBlizz('MailButton', BLIZZARD.MailButton)
