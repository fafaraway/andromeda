local _G = getfenv(0)
local unpack = _G.unpack
local select = _G.select

local _, C = unpack(select(2, ...))

C.CharacterSettings = {
    ShadowLands = false,
    InstallationComplete = false,
    UIAnchor = {},
    UIAnchorTemp = {},
    SpellBinding = {},
    TalentManager = {},
    General = {
        HideTalkingHead = true,
        HideBossBanner = false,
        HideBossEmote = true,
        HideMawBuffsFrame = true,
        SimplifyErrors = true,
        EnhancedFriendsList = true,
        EnhancedMailButton = true,
        EnhancedDressup = true,
        OrderHallIcon = true,
        TradeTabs = true,
        PetFilter = true,
        EnhancedMenu = true,
        NakedButton = true,
        MissingStats = true,
        ItemLevel = true,
        GemEnchant = true,
        AzeriteTrait = true,
        AutoScreenshot = true,
        EarnedNewAchievement = true,
        ChallengeModeCompleted = true,
        PlayerLevelUp = false,
        PlayerDead = false,
        FasterZooming = true,
        ActionCamera = false,
        CursorTrail = true,
        Vignetting = true,
        VignettingAlpha = .85,
        FasterMovieSkip = true,
        ScreenSaver = true,
        ProposalTimer = true,

        GroupTool = true,
            RuneCheck = false,
            Countdown = '10',

        EnhancedMailBox = true,
            SaveRecipient = false,
            RecipientList = '',

        EnhancedLFGList = true,
            ShortenScore = true,
    },
    Combat = {
        Enable = true,
        CombatAlert = true,
        AlertScale = .4,
        AlertSpeed = 1,
        SoundAlert = true,
            Interrupt = true,
            Dispel = true,
            SpellSteal = true,
            SpellMiss = true,
            LowHealth = true,
            LowHealthThreshold = .3,
            LowMana = true,
            LowManaThreshold = .3,
        PvPSound = true,
        SmartTab = true,
        EasyMark = true,
            EasyMarkKey = 1,
        EasyFocus = true,
            EasyFocusKey = 3,
            EasyFocusOnUnitframe = false,
        SimpleFloatingCombatText = true,
            Pet = true,
            Periodic = true,
            Merge = true,
            Incoming = true,
            Outgoing = false,
        CooldownPulse = true,
    },
    Announcement = {
        Enable = true,
        Channel = 4,
        Spells = true,
        Interrupt = true,
        Dispel = true,
        Stolen = true,
        Reflect = true,
        Quest = false,
        Reset = true
    },
    Aura = {
        Enable = true,
        Margin = 6,
        Offset = 12,
        BuffSize = 40,
        BuffPerRow = 12,
        BuffReverse = true,
        DebuffSize = 50,
        DebuffPerRow = 12,
        DebuffReverse = true,
        Reminder = true
    },
    Inventory = {
        Enable = true,
        Offset = 26,
        Spacing = 3,
        SlotSize = 44,
        BagColumns = 10,
        BankColumns = 10,
        BagsPerRow = 6,
        BankPerRow = 10,
        HideWidgets = true,
        SortMode = 2,
        ItemLevel = true,
            MinItemLevelToShow = 1,
        NewItemFlash = true,
        BindType = true,
        CombineFreeSlots = true,
        AutoDeposit = false,
        SpecialBagsColor = true,
        FavItemsList = {},
        ItemFilter = true,
            FilterEquipSet = true,
            FilterTradeGoods = true,
            FilterQuestItem = true,
            FilterJunk = true,
            FilterAzeriteArmor = true,
            FilterEquipment = true,
            FilterConsumable = true,
            FilterLegendary = true,
            FilterCollection = true,
            FilterFavourite = true,
            FilterAnima = true,
            FilterRelic = true,
        AutoSellJunk = true,
        AutoRepair = true
    },
    Unitframe = {
        Enable = true,
            TextureStyle = 1,
            ColorStyle = 2,
            InvertedColorMode = true,
            Smooth = true,
            Portrait = true,

            HealthColor = {r = .82, g = .8, b = .77},

            FrequentHealth = false,
                HealthFrequency = .2,

            Fader = true,
                MinAlpha = 0,
                MaxAlpha = 1,
                OutDuration = .3,
                InDuration = .3,
                InPvP = true,
                InInstance = true,
                MouseOver = false,
                InCombat = true,
                Targeting = true,
                Casting = true,
                Injured = true,
                ManaNotFull = false,
                HavePower = false,

            RangeCheck = true,
                OutRangeAlpha = .4,



            GCDIndicator = true,

            RaidTargetIndicator = true,
                RaidTargetIndicatorAlpha = .2,
                RaidTargetIndicatorScale = 1,

            HidePlayerTags = true,

            ClassPower = true,
                ClassPowerHeight = 2,
                RunesTimer = false,

            OnlyShowPlayer = true,
            DesaturateIcon = true,
            ShortenName = true,

            Castbar = true,
                SeparateCastbar = false,
                CastingColor = {r = .31, g = .48, b = .85},
                UninterruptibleColor = {r = .66, g = .65, b = .65},
                CompleteColor = {r = .25, g = .63, b = .49},
                FailColor = {r = .73, g = .39, b = .43},
                PlayerCastbarWidth = 200,
                PlayerCastbarHeight = 16,
                TargetCastbarWidth = 160,
                TargetCastbarHeight = 10,
                FocusCastbarWidth = 200,
                FocusCastbarHeight = 16,

            AltPowerHeight = 2,

            PlayerWidth = 160,
            PlayerHealthHeight = 4,
            PlayerPowerHeight = 1,

            PetWidth = 60,
            PetHealthHeight = 4,
            PetPowerHeight = 1,
            PetAurasPerRow = 3,

            TargetWidth = 160,
            TargetHealthHeight = 4,
            TargetPowerHeight = 1,
            TargetAurasPerRow = 6,

            TargetTargetWidth = 60,
            TargetTargetHealthHeight = 4,
            TargetTargetPowerHeight = 1,

            FocusWidth = 60,
            FocusHealthHeight = 4,
            FocusPowerHeight = 1,
            FocusAurasPerRow = 3,

            FocusTargetWidth = 60,
            FocusTargetHealthHeight = 4,
            FocusTargetPowerHeight = 1,

            Group = true,
                GroupShowName = false,
                ShowSolo = false,
                SmartRaid = true,
                ShowRaidBuff = false,
                DispellableOnly = false,
                RaidBuffSize = 8,
                ShowRaidDebuff = false,
                RaidDebuffSize = 12,
                GroupFilter = 6,
                PositionBySpec = false,
                ClickToCast = true,
                DebuffHighlight = true,
                CornerIndicator = true,
                CornerIndicatorScale = 1,
                InstanceAuras = true,
                RaidDebuffsScale = 1,
                AurasClickThrough = true,
                PartyWatcher = true,
                PartyWatcherSync = false,
                ThreatIndicator = true,

                PartyWidth = 100,
                PartyHealthHeight = 30,
                PartyPowerHeight = 2,
                PartyGap = 6,
                PartyHorizon = false,
                PartyReverse = false,

                RaidColorStyle = 2,
                RaidWidth = 38,
                RaidHealthHeight = 30,
                RaidPowerHeight = 2,
                RaidGap = 5,
                RaidHorizon = false,
                RaidReverse = true,

            Boss = true,
                BossWidth = 100,
                BossHealthHeight = 18,
                BossPowerHeight = 2,
                BossGap = 60,
                BossAurasPerRow = 6,

            Arena = true,
                ArenaWidth = 100,
                ArenaHealthHeight = 18,
                ArenaPowerHeight = 2,
                ArenaGap = 60,
                ArenaAurasPerRow = 6
    },
    Nameplate = {
        Enable = true,
            TextureStyle = 2,
            Width = 120,
            Height = 12,
            FriendlyWidth = 120,
            FriendlyHeight = 12,
            EnemyClickThrough = false,
            FriendlyClickThrough = true,
            ForceCVars = true,
            NameOnlyMode = true,
            HealthPerc = true,
            FriendlyPlate = true,
            TargetIndicator = true,
                TargetIndicatorColor = {r = .73, g = .92, b = .99},
            ThreatIndicator = true,
            ClassifyIndicator = true,
            QuestIndicator = true,
            ExecuteIndicator = false,
                ExecuteRatio = 0,
            SpitefulIndicator = true,
            ExplosiveIndicator = false,
                ExplosiveScale = 2,
            RaidTargetIndicator = true,
                RaidTargetIndicatorScale = 2,
                RaidTargetIndicatorAlpha = .4,
            FriendlyClassColor = false,
            HostileClassColor = true,
            TankMode = false,
            RevertThreat = false,
            SecureColor = {r = .22, g = .9, b = .25},
            TransColor = {r = 1, g = 1, b = .5},
            InsecureColor = {r = .95, g = .03, b = .31},
            OffTankColor = {r = .17, g = .79, b = .67},
            ColoredTarget = false,
                TargetColor = {r = 0, g = .6, b = 1},
            ColoredFocus = true,
                FocusColor = {r = 1, g = 1, b = 1},
            CustomUnitColor = true,
                CustomColor = {r = .76, g = .42, b = 1},
                CustomUnitList = '',
            ShowPowerList = '',

            ShowAura = true,
                AuraFilterMode = 3,
                AuraPerRow = 6,
                AuraSize = 22,
                AuraNumTotal = 12,

            TotemIcon = true,

            Castbar = true,
                CastbarHeight = 8,
                SeparateCastbar = true,
                MajorSpellsGlow = true,
                CastTarget = true,

            InsideView = true,
            MinScale = .7,
            TargetScale = 1,
            MinAlpha = .6,
            OccludedAlpha = .2,
            VerticalSpacing = .7,
            HorizontalSpacing = .3
    },
    Tooltip = {
        Enable = true,
            BackdropAlpha = .65,
            FollowCursor = false,
            Icon = true,
            BorderColor = true,
            HealthValue = false,
            HideTitle = true,
            HideRealm = true,
            HideGuildRank = true,
            HideInCombat = false,
            SpecIlvl = true,
            Covenant = true,
            MythicPlusScore = true,
                PlayerInfoByAlt = true,
            TargetedBy = true,
            DomiRank = true,
            IDs = true,
                IDsByAlt = true,
            ItemInfo = true,
                ItemInfoByAlt = true,
    },
    Map = {
        Enable = true,
        WorldMapScale = 1,
        MaxWorldMapScale = 1,
        RemoveFog = true,
        Coords = true,
        Minimap = true,
        MinimapScale = 1,
        HideMinimapInCombat = false,
        WhoPings = true,
        ExpBar = true
    },
    Infobar = {
        Enable = true,
        AnchorTop = true,
        Height = 14,
        Mouseover = true,
        Stats = true,
        Spec = true,
        Durability = true,
        Guild = true,
        Friends = true,
        Report = true,
        Currencies = true,
        Gold = true,
        CombatPulse = true,
    },
    Notification = {
        Enable = true,
        BagFull = true,
        NewMail = true,
        LowDurability = true,
        RareFound = true,
        ParagonChest = true
    },
    Chat = {
        Enable = true,
        LockPosition = true,
        Width = 300,
        Height = 100,
        HideInCombat = false,
        FadeOut = true,
        TimeVisible = 120,
        FadeDuration = 6,
        ShortenChannelName = true,
        CopyButton = true,
        VoiceButton = true,
        EasyChannelSwitch = true,
        SmartChatBubble = false,
        ChannelBar = true,
        WhisperInvite = false,
        InviteKeyword = '111 inv',
        GuildOnly = true,
        WhisperSticky = true,
        WhisperSound = true,
        SoundThreshold = 60,
        ExtendLink = true,
        DamageMeterFilter = true,
        SpamFilter = true,
        Matches = 1,
        BlockSpammer = false,
        BlockStrangerWhisper = false,
        BlockAddonSpam = true,
        GroupLootFilter = true,
        GroupLootThreshold = 2,
        GroupRoleIcon = true,
        DisableProfanityFilter = true
    },
    Actionbar = {
        Enable = true,
        Scale = 1,
        ButtonSize = 26,
        Hotkey = true,
        MacroName = true,
        CountNumber = true,
        ClassColor = false,
        EquipColor = true,
        ButtonFlash = true,
        Layout = 4, -- 1*12 2*12 3*12 2*18


        EnableBar1 = true,
            Bar1Size = 34,
            Bar1Font = 12,
            Bar1Num = 12,
            Bar1PerRow = 12,
            Bar1Fader = true,

        EnableBar2 = true,
            Bar2Size = 34,
            Bar2Font = 12,
            Bar2Num = 12,
            Bar2PerRow = 12,
            Bar2Fader = true,

        EnableBar3 = true,
            Bar3Size = 34,
            Bar3Font = 12,
            Bar3Num = 0,
            Bar3PerRow = 12,
            Bar3Fader = true,

        EnableBar4 = true,
            Bar4Size = 30,
            Bar4Font = 12,
            Bar4Num = 12,
            Bar4PerRow = 1,
            Bar4Fader = true,

        EnableBar5 = true,
            Bar5Size = 30,
            Bar5Font = 12,
            Bar5Num = 12,
            Bar5Fader = true,

        EnablePetBar = true,
            Bar5PerRow = 1,
            BarPetSize = 26,
            BarPetFont = 12,
            BarPetNum = 10,
            BarPetPerRow = 10,
        EnableStanceBar = true,
            BarStanceSize = 30,
            BarStanceFont = 12,
            BarStancePerRow = 10,
        EnableVehicleBar = true,
            VehicleButtonSize = 30,
        BarExtraSize = 40,
        CustomBar = false,
            CBMargin = 3,
            CBPadding = 3,
            CBButtonSize = 34,
            CBButtonNumber = 12,
            CBButtonPerRow = 6,

        Fader = true,
            FadeOutAlpha = 0,
            FadeInAlpha = 1,
            FadeOutDuration = 1,
            FadeInDuration = .3,
            ConditionCombat = true,
            ConditionTarget = false,
            ConditionDungeon = true,
            ConditionPvP = true,
            ConditionVehicle = true,

        CooldownNotify = true,
        CooldownDesaturate = true,
        BindType = 1
    },
    Cooldown = {
        Enable = true,
        Decimal = true,
        OverrideWA = false
    },
    Quest = {
        QuickQuest = false,
        CompletedSound = true,
        AutoCollapseTracker = true,
        WowheadLink = true,
    }
}

C.AccountSettings = {
    DetectVersion = C.AddonVersion,
    VersionCheck = true,
    UIScale = 1,
    HelpTips = {},
    GoldStatistic = {},
    ShadowOutline = true,
    BackdropColor = {r = .1, g = .1, b = .1},
    BackdropAlpha = .55,
    BorderColor = {r = .25, g = .25, b = .25},
    ButtonBackdropColor = {r = .1, g = .1, b = .1},
    ButtonBackdropAlpha = .25,
    GuildSortBy = 1,
    GuildSortOrder = true,
    GradientStyle = true,
    ReskinBlizz = true,
    ReskinAddons = true,
    NumberFormat = 1,
    FontOutline = false,
    WorldTextScale = 1,
    FloatingCombatText = true,
    FloatingCombatTextOldStyle = true,
    ChatFilterBlackList = '',
    ChatFilterWhiteList = '',
    RepairType = 1,
    CustomJunkList = {},
    NPAuraFilter = {[1] = {}, [2] = {}},
    RaidDebuffsList = {},
    RaidAuraWatch = {},
    NPMajorSpells = {},
    CornerSpellsList = {},
    PartySpellsList = {},
    AnnounceableSpellsList = {},
    KeystoneInfo = {},
    ProfileIndex = {},
    ProfileNames = {},
    UseCustomClassColor = true,
    CustomClassColors = {
        HUNTER = {b = 0.196078431372549, colorStr = 'ff009332', g = 0.580392156862745, r = 0},
        WARRIOR = {b = 0.4588235294117647, colorStr = 'ff9a8675', g = 0.5254901960784314, r = 0.6039215686274509},
        SHAMAN = {b = 0.4, colorStr = 'ff006166', g = 0.3843137254901961, r = 0},
        MAGE = {b = 0.8588235294117647, colorStr = 'ff3498db', g = 0.596078431372549, r = 0.203921568627451},
        PRIEST = {b = 0.8862745098039215, colorStr = 'ffd2dae2', g = 0.8549019607843137, r = 0.8235294117647058},
        DEATHKNIGHT = {b = 0.2509803921568627, colorStr = 'ffb71540', g = 0.08235294117647059, r = 0.7176470588235294},
        WARLOCK = {b = 1, colorStr = 'ff9c88ff', g = 0.5333333333333333, r = 0.611764705882353},
        DEMONHUNTER = {b = 0.8784313725490196, colorStr = 'fff368e0', g = 0.407843137254902, r = 0.9529411764705882},
        ROGUE = {b = 0.192156862745098, colorStr = 'fffbc530', g = 0.7725490196078432, r = 0.984313725490196},
        DRUID = {b = 0.1333333333333333, colorStr = 'ffe67e22', g = 0.4941176470588236, r = 0.9019607843137255},
        MONK = {b = 0.6980392156862745, colorStr = 'ff33d9b2', g = 0.8509803921568627, r = 0.2},
        PALADIN = {b = 0.4588235294117647, colorStr = 'ffff7675', g = 0.4627450980392157, r = 1}
    },
    ColorPickerPlus = {},
    ContactList = {},
}
