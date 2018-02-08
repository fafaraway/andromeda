local _, private = ...

local FrameXML = {
    -- add C namespace augmentations here
    "SharedXML.C_TimerAugment",

    -- add snippets independent of modules here
    "SharedXML.Util",
    "SharedXML.Pools",
    "SharedXML.LoopingSoundEffect",
    "SharedXML.CircularBuffer",
    "SharedXML.FontableFrameMixin",
    "SharedXML.Vector2D",
    "SharedXML.Vector3D",
    "SharedXML.Spline",
    "SharedXML.LayoutFrame",
    "SharedXML.ManagedLayoutFrame",
    "SharedXML.BulletPoint",
    "MixinUtil",

    -- intrinsics
    "SharedXML.ScrollingMessageFrame",

    "SharedXML.ModelSceneTemplates",
    "SharedXML.ModelSceneMixin",
    "SharedXML.ModelSceneActorMixin",
    "SharedXML.FrameStack",

    "AnimatedStatusBar",
    "FlowContainer",
    "FrameLocks",


    "SharedXML.SoundKitConstants",
    "Constants",
    "Localization",
    "Fonts",
    "FontStyles",

    "SharedXML.PropertyBindingMixin",
    "SharedXML.PropertyButton",
    "SharedXML.PropertyFontString",
    "SharedXML.PropertySlider",

    "ObjectAPI_ItemLocation",
    "ObjectAPI_Item",

    -- add new modules below here
    "WorldFrame",
    "UIParent",
    "QuestUtils",
    -- IME needs to be loaded after UIParent
    "SharedXML.IME",
    "MoneyFrame",
    "MoneyInputFrame",
    "SharedXML.SharedUIPanelTemplates",
    "SharedXML.SharedBasicControls",
    "GameTooltip",
    "UIMenu",
    "UIDropDownMenu",
    "UIPanelTemplates",
    "SecureTemplates",
    "SecureHandlerTemplates",
    "SecureGroupHeaders",
    "SharedXML.ModelFrames",
    "WardrobeOutfits",
    "DressUpFrames",
    "ItemButtonTemplate",
    "NavigationBar",
    "SparkleFrame",
    "SharedXML.HybridScrollFrame",
    "GameMenuFrame",
    "CharacterFrameTemplates",
    "TextStatusBar",
    "UIErrorsFrame",
    "AutoComplete",
    "StaticPopup",
    "Sound",
    "OptionsFrameTemplates",
    "OptionsPanelTemplates",
    "UIOptions",
    "VideoOptionsFrame",
    "SharedXML.VideoOptionsPanels",
    "MacOptionsPanel",
    "AudioOptionsFrame",
    "AudioOptionsPanels",
    "InterfaceOptionsFrame",
    "InterfaceOptionsPanels",
    "SharedXML.AddonList",
    "GarrisonBaseUtils",
    "AlertFrames",
    "AlertFrameSystems",
    "MirrorTimer",
    "CoinPickupFrame",
    "StackSplitFrame",
    "FadingFrame",
    "ZoneText",
    "BuilderSpenderFrame",
    "UnitFrame",
    "Cooldown",
    "PVPHonorSystem",
    "ActionBarController",
    "TutorialFrame",
    "Minimap",
    "GameTime",
    -- "ActionWindow",
    "EquipmentFlyout",
    "BuffFrame",
    "LowHealthFrame",
    "CombatFeedback",
    "UnitPowerBarAlt",
    "CastingBarFrame",
    "UnitPopup",
    "BNet",
    "HistoryKeeper",
    "ChatFrame",
    "FloatingChatFrame",
    "VoiceChat",
    "ReadyCheck",
    "PlayerFrame",
    "PartyFrame",
    "TargetFrame",
    "TotemFrame",
    "PetFrame",
    "StatsFrame",
    "SpellBookFrame",
    "CharacterFrame",
    "PaperDollFrame",
    "ReputationFrame",
    "QuestFrame",
    "QuestPOI",
    "QuestInfo",
    "MerchantFrame",
    "TradeFrame",
    "ContainerFrame",
    "LootFrame",
    "ItemTextFrame",
    "TaxiFrame",
    "BankFrame",
    "ScrollOfResurrection",
    "RoleSelectionTemplate",
    "ItemRef",
    "SocialQueue",
    "QuickJoinToast",
    "FriendsFrame",
    "QuickJoin",
    "RaidFrame",
    "ChannelFrame",
    "PetActionBarFrame",
    "MultiCastActionBarFrame",
    "MainMenuBarBagButtons",
    "UnitPositionFrameTemplates",
    "WorldMapFrame",
    "QuestMapFrame",
    "RaidWarning",
    "CinematicFrame",
    "ComboFrame",
    "TabardFrame",
    "GuildRegistrarFrame",
    "PetitionFrame",
    "HelpFrame",
    "ColorPickerFrame",
    "GossipFrame",
    "MailFrame",
    "PetStable",
    "VehicleSeatIndicator",
    "DurabilityFrame",
    "WorldStateFrame",
    "PVEFrame",
    "LFGFrame",
    "LFDFrame",
    "LFRFrame",
    "RaidFinder",
    "ScenarioFinder",
    "LFGList",
    "RatingMenuFrame",
    "TalentFrameBase",
    "TalentFrameTemplates",
    "ClassPowerBar",
    "RuneFrame",
    "ShardBar",
    "ComboFramePlayer",
    "InsanityBar",
    "EasyMenu",
    "ChatConfigFrame",
    "MovieFrame",
    "AlternatePowerBar",
    "MonkStaggerBar",
    "LevelUpDisplay",
    "AnimationSystem",
    "EquipmentManager",
    "CompactUnitFrame",
    "CompactRaidGroup",
    "CompactPartyFrame",
    "RolePoll",
    "SpellFlyout",
    "PaladinPowerBar",
    "MageArcaneChargesBar",
    "SpellActivationOverlay",
    "GuildInviteFrame",
    "GhostFrame",
    "StreamingFrame",
    "IconIntroAnimation",
    "Timer",
    "MonkHarmonyBar",
    "RecruitAFriendFrame",
    "DestinyFrame",
    "PriestBar",
    "SharedPetBattleTemplates",
    "LootHistory",
    "FloatingPetBattleTooltip",
    "QueueStatusFrame",
    "BattlePetTooltip",
    "FloatingGarrisonFollowerTooltip",
    "GarrisonFollowerTooltip",
    "StaticPopupSpecial",
    "LossOfControlFrame",
    "PVPHelper",
    "MapBar",
    "ProductChoice",
    "ZoneAbility",
    "ArtifactToasts",
    "AzeriteItemToasts",
    "SharedXML.ModelPreviewFrame",
    "SplashFrame",
    "QuestChoiceFrameMixin",

    -- Save off whatever we need available unmodified.
    "SecureCapsule",

    -- add new modules above here
    "LocalizationPost",
}

private.FrameXML = private.CreateAPI(FrameXML)
private.SharedXML = private.CreateAPI({})

--[==[ Some boilerplate stuff for new files
local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ FrameXML\File.lua ]]
end

do --[[ FrameXML\File.xml ]]
end

function private.FrameXML.File()
    --[[
    ]]
end
function private.SharedXML.File()
    --[[
    ]]
end
]==]
