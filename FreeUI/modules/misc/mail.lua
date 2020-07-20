local F, C, L = unpack(select(2, ...))
local MISC, cfg = F:GetModule('Misc'), C.General


local mailButton = CreateFrame('Button', 'FreeUI_MailButton', InboxFrame, 'UIPanelButtonTemplate')
local text = F.CreateFS(mailButton, C.Assets.Fonts.Normal, 12, 'OUTLINE')

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
	text:SetText(C.InfoColor..format('%d '..L['MISC_GOLD']..' %d '..L['MISC_ITEM'], floor(cash * 0.0001), items))

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


function MISC:MailButton()
	if not cfg.mailButton then return end

	OpenAllMail:Hide()
	OpenAllMail:UnregisterAllEvents()

	mailButton:SetPoint('BOTTOM', InboxFrame, 'BOTTOM', -20, 102)
	mailButton:SetWidth(128)
	mailButton:SetHeight(25)
	F.Reskin(mailButton)

	mailButton:RegisterEvent('MAIL_INBOX_UPDATE')
	mailButton:SetScript('OnEvent', OnEvent)
	mailButton:SetScript('OnClick', OnClick)
	mailButton:SetScript('OnHide', OnHide)
end

MISC:RegisterMisc("MailButton", MISC.MailButton)