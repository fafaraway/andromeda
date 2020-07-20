local F, C = unpack(select(2, ...))
local UNITFRAME, cfg = F:GetModule('Unitframe'), C.Unitframe


local buffs = {
	ALL = {},
	
	PRIEST = {
		{194384, 'TOPRIGHT',    {1, 1, 0.66}},              -- Atonement
		{214206, 'TOPRIGHT',    {1, 1, 0.66}},              -- Atonement (PvP)
		{ 41635, 'BOTTOMRIGHT', {0.2, 0.7, 0.2}},           -- Prayer of Mending
		{193065, 'BOTTOMRIGHT', {0.54, 0.21, 0.78}},        -- Masochism
		{   139, 'BOTTOMLEFT',  {0.4, 0.7, 0.2}},           -- Renew
		{    17, 'TOPLEFT',     {0.7, 0.7, 0.7}, true},     -- Power Word: Shield
		{ 47788, 'LEFT',        {0.86, 0.45, 0}, true},     -- Guardian Spirit
		{ 33206, 'LEFT',        {0.47, 0.35, 0.74}, true},  -- Pain Suppression
	},

	DRUID = {
		{   774, 'TOPRIGHT',    {0.8, 0.4, 0.8}},   		-- Rejuvenation
		{155777, 'RIGHT',       {0.8, 0.4, 0.8}},   		-- Germination
		{  8936, 'BOTTOMLEFT',  {0.2, 0.8, 0.2}},		    -- Regrowth
		{ 33763, 'TOPLEFT',     {0.4, 0.8, 0.2}},  		    -- Lifebloom
		{ 48438, 'BOTTOMRIGHT', {0.8, 0.4, 0}},		        -- Wild Growth
		{207386, 'TOP',         {0.4, 0.2, 0.8}},     		-- Spring Blossoms
		{102351, 'LEFT',        {0.2, 0.8, 0.8}},    		-- Cenarion Ward (Initial Buff)
		{102352, 'LEFT',        {0.2, 0.8, 0.8}},    		-- Cenarion Ward (HoT)
		{200389, 'BOTTOM',      {1, 1, 0.4}},      		    -- Cultivation
	},

	PALADIN = {
		{ 53563, 'TOPRIGHT',    {0.7, 0.3, 0.7}},           -- Beacon of Light
		{156910, 'TOPRIGHT',    {0.7, 0.3, 0.7}},           -- Beacon of Faith
		{200025, 'TOPRIGHT',    {0.7, 0.3, 0.7}},           -- Beacon of Virtue
		{  1022, 'BOTTOMRIGHT', {0.2, 0.2, 1}, true},       -- Hand of Protection
		{  1044, 'BOTTOMRIGHT', {0.89, 0.45, 0}, true},     -- Hand of Freedom
		{  6940, 'BOTTOMRIGHT', {0.89, 0.1, 0.1}, true},    -- Hand of Sacrifice
		{223306, 'BOTTOMLEFT',  {0.7, 0.7, 0.3}},           -- Bestow Faith
	},

	SHAMAN = {
		{ 61295, 'TOPRIGHT',    {0.7, 0.3, 0.7}},   	    -- Riptide
		{   974, 'BOTTOMRIGHT', {0.2, 0.2, 1}}, 	        -- Earth Shield
		{207400, 'BOTTOMLEFT',  {0.6, 0.8, 1}}, 	        -- 先祖活力
	},

	MONK = {
		{119611, 'TOPLEFT',     {0.3, 0.8, 0.6}},           -- Renewing Mist
		{116849, 'TOPRIGHT',    {0.2, 0.8, 0.2}, true},     -- Life Cocoon
		{124682, 'BOTTOMLEFT',  {0.8, 0.8, 0.25}},          -- Enveloping Mist
		{191840, 'BOTTOMRIGHT', {0.27, 0.62, 0.7}},         -- Essence Font
	},

	ROGUE = {
		{ 57934, 'TOPRIGHT',    {0.89, 0.09, 0.05}},        -- Tricks of the Trade
	},

	WARRIOR = {
		{114030, 'TOPLEFT',    	{0.2, 0.2, 1}},     	    -- Vigilance
		{122506, 'TOPRIGHT',   	{0.89, 0.09, 0.05}}, 	    -- Intervene
	},

	WARLOCK = {
		{ 20707, 'BOTTOMRIGHT',	{0.8, 0.4, 0.8}},     	    -- Soul Stone
	},

	HUNTER = {
		{ 34477, "BOTTOMRIGHT", {.9, .1, .1}},		        -- 误导
		{ 90361, "TOPLEFT",     {.4, .8, .2}},			    -- 灵魂治愈
	},

	DEMONHUNTER = {},
	MAGE = {},
	DEATHKNIGHT = {},
}

UNITFRAME['AuraTable'].CornerBuffs = buffs