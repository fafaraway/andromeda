local _G = getfenv(0)
local unpack = _G.unpack
local select = _G.select

local _, C = unpack(select(2, ...))

C.ReminderBuffsList = {
    ITEMS = {
        {
            itemID = 178742, -- 瓶装毒素饰品
            spells = {[345545] = true},
            instance = true,
            combat = true
        },
        {
            itemID = 174906, -- 属性符文
            spells = {[317065] = true, [270058] = true},
            equip = true,
            instance = true,
            disable = true
        }
    },
    MAGE = {
        {
            spells = {
                -- 奥术魔宠
                [210126] = true
            },
            depend = 205022,
            spec = 1,
            combat = true,
            instance = true,
            pvp = true
        },
        {
            spells = {
                -- 奥术智慧
                [1459] = true
            },
            depend = 1459,
            instance = true
        }
    },
    PRIEST = {
        {
            spells = {
                -- 真言术耐
                [21562] = true
            },
            depend = 21562,
            instance = true
        }
    },
    WARRIOR = {
        {
            spells = {
                -- 战斗怒吼
                [6673] = true
            },
            depend = 6673,
            instance = true
        }
    },
    SHAMAN = {
        {
            spells = {
                [192106] = true, -- 闪电之盾
                [974] = true, -- 大地之盾
                [52127] = true -- 水之护盾
            },
            depend = 192106,
            combat = true,
            instance = true,
            pvp = true
        },
        {
            spells = {
                [33757] = true -- 风怒武器
            },
            depend = 33757,
            combat = true,
            instance = true,
            pvp = true,
            weaponIndex = 1,
            spec = 2
        },
        {
            spells = {
                [318038] = true -- 火舌武器
            },
            depend = 318038,
            combat = true,
            instance = true,
            pvp = true,
            weaponIndex = 2,
            spec = 2
        }
    },
    ROGUE = {
        {
            spells = {
                -- 伤害类毒药
                [2823] = true, -- 致命药膏
                [8679] = true, -- 致伤药膏
                [315584] = true -- 速效药膏
            },
            texture = 132273,
            depend = 315584,
            combat = true,
            instance = true,
            pvp = true
        },
        {
            spells = {
                -- 效果类毒药
                [3408] = true, -- 减速药膏
                [5761] = true -- 迟钝药膏
            },
            depend = 3408,
            pvp = true
        }
    }
}

C.GroupBuffsCheckList = {
    [1] = {
        -- 合剂
        307166, -- 大锅
        307185, -- 通用合剂
        307187 -- 耐力合剂
    },
    [2] = {
        -- 进食充分
        104273 -- 250敏捷，BUFF名一致
    },
    [3] = {
        -- 10%智力
        1459,
        264760
    },
    [4] = {
        -- 10%耐力
        21562,
        264764
    },
    [5] = {
        -- 10%攻强
        6673,
        264761
    },
    [6] = {
        -- 符文
        270058
    }
}
