local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


local botsList = {
	[157066] = true, -- 沃特
	[22700] = true, -- 修理機器人74A型
	[44389] = true, -- 修理機器人110G型
	[54711] = true, -- 廢料機器人
	[67826] = true, -- 吉福斯
	[126459] = true, -- 布靈登4000型
	[161414] = true, -- 布靈登5000型
	[200061] = true, -- 召唤里弗斯
	[200204] = true, -- 自動鐵錘模式(里弗斯)
	[200205] = true, -- 自動鐵錘模式(里弗斯)
	[200210] = true, -- 故障检测模式(里弗斯)
	[200211] = true, -- 故障检测模式(里弗斯)
	[200212] = true, -- 烟花表演模式(里弗斯)
	[200214] = true, -- 烟花表演模式(里弗斯)
	[200215] = true, -- 零食发放模式(里弗斯)
	[200216] = true, -- 零食发放模式(里弗斯)
	[200217] = true, -- 华丽模式(布靈登6000型)(里弗斯)
	[200218] = true, -- 华丽模式(布靈登6000型)(里弗斯)
	[200219] = true, -- 驾驶战斗模式(里弗斯)
	[200220] = true, -- 驾驶战斗模式(里弗斯)
	[200221] = true, -- 虫洞发生器模式(里弗斯)
	[200222] = true, -- 虫洞发生器模式(里弗斯)
	[200223] = true, -- 热砧模式(里弗斯)
	[200225] = true, -- 热砧模式(里弗斯)
	[199109] = true, -- 自動鐵錘
	[226241] = true, -- 宁神圣典
	[256230] = true -- 静心圣典
}

local feastsList = {
	[126492] = true, -- 燒烤盛宴
	[126494] = true, -- 豪华燒烤盛宴
	[126495] = true, -- 快炒盛宴
	[126496] = true, -- 豪华快炒盛宴
	[126501] = true, -- 烘烤盛宴
	[126502] = true, -- 豪华烘烤盛宴
	[126497] = true, -- 燉煮盛宴
	[126498] = true, -- 豪华燉煮盛宴
	[126499] = true, -- 蒸煮盛宴
	[126500] = true, -- 豪華蒸煮盛宴
	[104958] = true, -- 熊貓人盛宴
	[126503] = true, -- 美酒盛宴
	[126504] = true, -- 豪華美酒盛宴
	[145166] = true, -- 拉麵推車
	[145169] = true, -- 豪華拉麵推車
	[145196] = true, -- 熊貓人國寶級拉麵推車
	[188036] = true, -- 靈魂大鍋
	[201351] = true, -- 澎湃盛宴
	[201352] = true, -- 蘇拉瑪爾豪宴
	[259409] = true, -- 艦上盛宴
	[259410] = true, -- 豐盛的船長饗宴
	[276972] = true, -- 神秘大鍋
	[286050] = true, -- 血潤盛宴
	[297048] = true, -- 超澎湃饗宴
	[298861] = true, -- 強效神秘大鍋
	[308458] = true, -- 意外可口盛宴
	[308462] = true, -- 暴食享樂盛宴
}

local portalsList = {
	-- 聯盟
	[10059] = true, -- 暴風城
	[11416] = true, -- 鐵爐堡
	[11419] = true, -- 達納蘇斯
	[32266] = true, -- 艾克索達
	[49360] = true, -- 塞拉摩
	[33691] = true, -- 撒塔斯
	[88345] = true, -- 托巴拉德
	[132620] = true, -- 恆春谷
	[176246] = true, -- 暴風之盾
	[281400] = true, -- 波拉勒斯
	-- 部落
	[11417] = true, -- 奧格瑪
	[11420] = true, -- 雷霆崖
	[11418] = true, -- 幽暗城
	[32267] = true, -- 銀月城
	[49361] = true, -- 斯通納德
	[35717] = true, -- 撒塔斯
	[88346] = true, -- 托巴拉德
	[132626] = true, -- 恆春谷
	[176244] = true, -- 戰爭之矛
	[281402] = true, -- 達薩亞洛
	-- 中立
	[53142] = true, -- 達拉然——北裂境
	[224871] = true, -- 達拉然——破碎群島
	[120146] = true -- 遠古達拉然
}

local toysList = {
	[61031] = true, -- 玩具火車組
	[49844] = true -- 恐酒遙控器
}

local function FormatMessage(message, name, id)
	message = gsub(message, '%%player%%', name)
	message = gsub(message, '%%spell%%', GetSpellLink(id))
	return message
end

local function TryAnnounce(spellId, sourceName, id, list, type)
	sourceName = sourceName:gsub('%-[^|]+', '')

	if (id and spellId == id) or (type and list[spellId]) then

			ANNOUNCEMENT:SendMessage(
				FormatMessage(L['ANNOUNCEMENT_CASTED'], sourceName, spellId),
				ANNOUNCEMENT:GetChannel()

			)

		return true
	end

	return false
end

function ANNOUNCEMENT:Utility(event, sourceName, spellId)
	if not C.DB.announcement.utility then return end

	if not (IsInInstance() and IsInGroup()) or not event or not spellId or not sourceName then
		return
	end

	if event == 'SPELL_CAST_SUCCESS' then
		if TryAnnounce(spellId, sourceName, 190336) then
			return
		end -- 召喚餐點桌

		if TryAnnounce(spellId, sourceName, nil, feastsList, 'feasts') then
			return
		end -- 大餐大鍋

	elseif event == 'SPELL_SUMMON' then
		if TryAnnounce(spellId, sourceName, nil, botsList, 'bots') then
			return
		end -- 修理機器人

		if TryAnnounce(spellId, sourceName, 261602) then
			return
		end -- 凱蒂的郵哨

		if TryAnnounce(spellId, sourceName, 195782) then
			return
		end -- 召喚月羽雕像

	elseif event == 'SPELL_CREATE' then
		if TryAnnounce(spellId, sourceName, 698) then
			return
		end -- 召喚儀式

		if TryAnnounce(spellId, sourceName, 54710) then
			return
		end -- MOLL-E 郵箱

		if TryAnnounce(spellId, sourceName, 29893) then
			return
		end -- 靈魂之井

		if TryAnnounce(spellId, sourceName, nil, toysList, 'toys') then
			return
		end -- 玩具

		if TryAnnounce(spellId, sourceName, nil, portalsList, 'portals') then
			return
		end --傳送門
	end
end

