-- Translated by Hacktivist (Хактивист-Ясеневый лес)

local _G = _G
local unpack = unpack
local select = select
local GetLocale = GetLocale

local _, _, L = unpack(select(2, ...))

if GetLocale() ~= 'ruRU' then
    return
end

--[[ Binding ]]
do
    _G.BINDING_HEADER_FREEUI = 'FreeUI'
    _G.BINDING_NAME_TOGGLE_FREEUI_GUI = 'Переключить панель конфигурации FreeUI'
    _G.BINDING_NAME_TOGGLE_QUEST_TRACKER = 'Переключение отслеживания заданий'
end

L.MOVER = {
    MAIN_BAR = 'Главная панель',
    PET_BAR = 'Панель питомца',
    STANCE_BAR = 'Панель стоек',
    VEHICLE_BAR = 'Кнопка спешивания',
    EXTRA_BAR = 'Extra кнопка',
    ZONE_ABILITY = 'Кнопка абилки зоны',
    CUSTOM_BAR = 'Дополнительная панель действий',
    COOLDOWN_FLASH = 'Вспышка перезарядки',
}

L.ACTIONBAR = {
    CD_REMAINING = '%s оставшееся время перезарядки %s.',
    CD_FINISHED = '%s теперь доступна.',
    CUSTOM_BAR = 'Кастомная панель',
    UNBIND_TIP = 'Нажмите клавишу ESC или щелкните правой кнопкой мыши, чтобы отменить это действие.',
    KEY_INDEX = 'Индекс',
    KEY_BINDING = 'Клавиша',
    KEY_BOUND_TO = ' bound to',
    SAVE_KEYBINDS = 'Привязка клавиши сохранена.',
    DISCARD_KEYBINDS = 'Отмена привязки клавиши.',
    CLEAR_BINDS = '|cff20ff20Все привязки клавишь очищены для|r %s.',
}

L.ANNOUNCEMENT = {
    INTERRUPT = 'Прерванно %target% %target_spell%!',
    DISPEL = 'Диспел %target% %target_spell%!',
    STOLEN = 'Украл %target% %target_spell%!',
    BATTLE_REZ = '%player% кастует %spell% на %target%!',
    CAST = '%player% кастует %spell%!',
    CAST_TARGET = '%player% кастует %spell% на %target%!',
    QUEST_ACCEPT = 'Принятый квет:',
    QUEST_ANNOUNCE = 'Анонс квеста',
    QUEST_ANNOUNCE_TIP = 'Пусть ваши тим-мэйты знают о ходе выполнения заданий.',
    RESET_SUCCESS = '%s был сброшен.',
    RESET_FAILED = 'Невозможно сбросить %s, внутри подземелья все еще есть игроки.',
    RESET_FAILED_ZONING = 'Невозможно сбросить %s, есть игроки в вашей группе, пытающиеся войти в подземелье.',
    RESET_FAILED_OFFLINE = 'Невозможно сбросить %s, в вашей гуппе есть игроки, находящиеся в офлайне.',
}

L.QUEST = {
    AUTOMATION = 'Авто-квесты',
    AUTOMATION_TIP = 'Автоматически принимать и сдавать квесты'
}

L.UNITFRAME = {
    BINDER_OPEN = 'Открыть бинды спелов',
    BINDER_TITLE = 'Бинды спелов',
    BINDER_TIP = 'Ctrl/Alt/Shift + любая кнопка мыши для привязки заклинаний.',
}

--[[ Misc ]]
do
    L['MISC_NUMBER_CAP'] = {'Миллион', 'миллиард', 'триллион'}

    L['MISC_REPUTATION'] = 'Репутация'
    L['MISC_PARAGON'] = 'Парагон'
    L['MISC_PARAGON_REPUTATION'] = 'Максимальный парагон'
    L['MISC_PARAGON_NOTIFY'] = 'Уведомления парагона'
    L['MISC_ORDERHALL_TIP'] = 'Удерживайте нажатой клавишу Shift для отображения подробных сведений'

    L['MISC_DISBAND_GROUP'] = 'Распустить группу'
    L['MISC_DISBAND_GROUP_CHECK'] = 'Вы уверены, что хотите распустить группу?'

    L['MISC_DECLINE_INVITE'] = 'Автоматическое отклоненное приглашение группы %s'
    L['MISC_ACCEPT_INVITE'] = 'Автоматическое принятое приглашение группы %s'

    L['AUTOMATION_GET_NAKED'] = 'Двойной щелчек что бы снять всю броню'
    L['MISC_BUY_STACK'] = 'Are you sure to buy |cffff0000a stack|r of these?' -- Need translete

    L['MISC_GROUP_TOOL'] = 'Инструменты группы'
    L['MISC_FOOD'] = 'Еда'
    L['MISC_FLASK'] = 'Настои'
    L['MISC_LACK'] = 'Отсутствие'
    L['MISC_PLAYER_COUNT'] = '%s игроки'
    L['MISC_COUNTDOWN'] = 'Начало/Отмена обратного отсчета'
    L['MISC_CHECK_STATUS'] = 'Проверьть настои и еду'
    L['MISC_BUFFS_READY'] = 'Все баффы готовы!'
    L['MISC_RAID_BUFF_CHECK'] = 'Проверка рейдовых баффов:'
    L['MISC_EXRT_POTION_CHECK'] = 'ExRT проверка потов'
    L['MISC_ADDON_REQUIRED'] = 'У вас нет установленного DBM или BigWigs'
    L['MISC_DISBAND_CHECK'] = 'Вы уверены что хотите |cffff0000распустить|r группу?'
    L['MISC_DISBAND_PROCESS'] = 'Роспуск рейда'

end

--[[ Blizzard ]]
do
    L['BLIZZARD_MOVER_ALERT'] = 'Рамка оповещения'
    L['BLIZZARD_MOVER_VEHICLE'] = 'Индикатор транспортного средства'
    L['BLIZZARD_MOVER_UIWIDGET'] = 'Рамка UIWidget'
    L['BLIZZARD_MOVER_DURABILITY'] = 'Индикатор прочности'
    L['BLIZZARD_UNDRESS'] = 'Раздеть'
    L['BLIZZARD_STRANGER'] = 'Незнакомец'
    L['BLIZZARD_KEYSTONES'] = 'Ключи'
    L['BLIZZARD_KEYSTONES_RESET'] = 'Удалить информацию о ключах'
    L['BLIZZARD_GET_NAKED'] = 'Двойной клик что бы снять всю броню'
    L['BLIZZARD_ORDERHALL_TIP'] = 'Зажать SHIFT для доп.информации'
    L['BLIZZARD_GOLD'] = 'Золото'
end

--[[ Notification ]]
do
    L['NOTIFICATION_NEW_MAIL'] = 'Новое письмо!'
    L['NOTIFICATION_BAG_FULL'] = 'Нет места в сумке!'
    L['NOTIFICATION_MAIL'] = 'Письмо'
    L['NOTIFICATION_BAG'] = 'Сумка'
    L['NOTIFICATION_RARE'] = 'Рарник найден'
    L['NOTIFICATION_VERSION'] = 'Провека версии'
    L['NOTIFICATION_VERSION_OUTDATE'] = 'Твой FreeUI устарел, последняя версия %s'
    L['NOTIFICATION_DURABILITY'] = 'Скоро сломаешься, нужно починиться!'
    L['NOTIFICATION_INSTANCE'] = 'Подземелье'
end

--[[ Infobar ]]
do
    L['INFOBAR_DURABILITY'] = 'Прочность'
    L['INFOBAR_OPEN_CHARACTER_PANEL'] = 'Открыть окно символов'

    L['INFOBAR_FRIENDS'] = 'Друзья'
    L['INFOBAR_OPEN_FRIENDS_PANEL'] = 'Открыть окно друзей'
    L['INFOBAR_ADD_FRIEND'] = 'Добавить друга'

    L['INFOBAR_GUILD'] = 'Гильдия'
    L['INFOBAR_GUILD_NONE'] = 'Нет'
    L['INFOBAR_OPEN_GUILD_PANEL'] = 'Открыть окно гильдии и сообщества'

    L['INFOBAR_REPORT'] = 'Ежедневки/Виклики'
    L['INFOBAR_BLINGTRON'] = 'Blingtron daily pack' -- Need translete
    L['INFOBAR_MEAN_ONE'] = 'Дейлики зимнего покрова'
    L['INFOBAR_TIMEWARPED'] = 'Награды за путишествие во времени'
    L['INFOBAR_INVASION_LEG'] = 'Вторжение легиона'
    L['INFOBAR_INVASION_BFA'] = 'Нападения фракций'
    L['INFOBAR_INVASION_CURRENT'] = 'Текущий: '
    L['INFOBAR_INVASION_NEXT'] = 'Следующий: '
    L['INFOBAR_LESSER_VISION'] = 'Нападения Н\'зота'
    L['INFOBAR_ISLAND'] = 'Острова'

    L['INFOBAR_TOGGLE_WEEKLY_REWARDS'] = 'Открыть окно хранилища'
    L['INFOBAR_TOGGLE_CALENDAR'] = 'Открыть календарь'
    L['INFOBAR_HOLD_SHIFT'] = 'Зажмите SHIFT для доп.информации'

    L['INFOBAR_SPEC'] = 'Спек'
    L['INFOBAR_LOOT'] = 'Добыча'
    L['INFOBAR_OPEN_SPEC_PANEL'] = 'Открыть окно талантов'
    L['INFOBAR_CHANGE_SPEC'] = 'Переключение специализации и добычи'

    L['INFOBAR_LOCAL_TIME'] = 'Локальное время'
    L['INFOBAR_REALM_TIME'] = 'Время сервера'
    L['INFOBAR_OPEN_ADDON_PANEL'] = 'Открыть окно аддонов'
    L['INFOBAR_OPEN_TIMER_TRACKER'] = 'Открыть таймер'

    L['INFOBAR_EARNED'] = 'Заработанно'
    L['INFOBAR_SPENT'] = 'Потраченно'
    L['INFOBAR_DEFICIT'] = 'Дефицит'
    L['INFOBAR_PROFIT'] = 'Профит'
    L['INFOBAR_SESSION'] = 'Сессия'
    L['INFOBAR_OPEN_CURRENCY_PANEL'] = 'Открыть окно валют'
    L['INFOBAR_OPEN_STORE_PANEL'] = 'Открыть окно магазина'
    L['INFOBAR_RESET_GOLD_COUNT'] = 'Сброс количества золота'
end

--[[ Chat ]]
do
    L['CHAT_TOGGLE_PANEL'] = 'Спрятать/показать чат'
    L['CHAT_TOGGLE_WC'] = 'Войти/выйти мировые каналы'
    L['CHAT_COPY'] = 'Копирование содержимого чата'
    L['CHAT_WHISPER_TELL'] = 'Я шепчу'
    L['CHAT_WHISPER_FROM'] = 'Шепчет'
    L['CHAT_WORLD_CHANNEL'] = 'Мировой канал'
end

--[[ Aura ]]
do
    L['AURA_MOVER_BUFFS'] = 'Баффы'
    L['AURA_MOVER_DEBUFFS'] = 'Дебаффы'
    L['AURA_LACK'] = 'Отсутствие'
end

--[[ Combat ]]
do
    L['COMBAT_ENTER'] = 'Вступил в бой'
    L['COMBAT_LEAVE'] = 'Вышел из боя'
    L['COMBAT_MOVER_IN'] = 'FCT входящий'
    L['COMBAT_MOVER_OUT'] = 'FCT исходящий'

    L['COMBAT_ENABLE_COMBAT'] = 'Включить боевой модуль'
    L['COMBAT_COMBAT_ALERT'] = 'Предупредение по входу и выходу из боя'
    L['COMBAT_HEALTH_ALERT'] = 'Предупредение по низкому объему здоровья'
    L['COMBAT_HEALTH_ALERT_THRESHOLD'] = 'Порог объема здоровья'
    L['COMBAT_SPELL_ALERT'] = 'Специальные предупреждения по навыкам'
    L['COMBAT_PVP_SOUND'] = 'Убрать PVP звуковые эффекты'
    L['COMBAT_EASY_TAB'] = 'Легкий ТАБ'
    L['COMBAT_EASY_FOCUS'] = 'Быстро установить фокус'
    L['COMBAT_EASY_MARK'] = 'Быстрая установка маркеров'
    L['COMBAT_FCT'] = 'Прокрутка лога боя'
    L['COMBAT_FCT_IN'] = 'Урон и лечение'
    L['COMBAT_FCT_OUT'] = 'Исходящий урон'
    L['COMBAT_FCT_PET'] = 'Урон питомцев'
    L['COMBAT_FCT_PERIODIC'] = 'Переодический урон'
    L['COMBAT_FCT_MERGE'] = 'Поглащение'
end

--[[ Inventory ]]
do
    L['INVENTORY_NOTIFICATION_HEADER'] = 'Сумка'
    L['INVENTORY_SORT'] = 'Сортировать'
    L['INVENTORY_ANCHOR_RESET'] = 'Сбросить позицию'
    L['INVENTORY_BAGS'] = 'Переключение сумки'
    L['INVENTORY_FREE_SLOTS'] = 'Свободные слоты'
    L['INVENTORY_SORT_DISABLED'] = 'Сортировка рюкзака была отключена'
    L['INVENTORY_AZERITEARMOR'] = 'Азеритовая броня'
    L['INVENTORY_QUICK_DELETE_ENABLED'] = '|nВы можете удалить элемент сумки, удерживая CTRL+ALT. Предмет может быть фамилькой или его качество ниже редкого (синий).'
    L['INVENTORY_QUICK_DELETE'] = 'Быстрое удаление'
    L['INVENTORY_PICK_FAVOURITE_ENABLED'] = '|nТеперь можно пометить звездочкой.|nЕсли включен \'Фильтр сумок\', то выбранный вами элемент будет добавлен в слоты фильтра предпочтений.|nНельзя выбрать для мусора.'
    L['INVENTORY_PICK_FAVOURITE'] = 'Фаворит'
    L['INVENTORY_AUTO_REPAIR'] = 'Авто-починка'
    L['INVENTORY_AUTO_REPAIR_TIP'] = '|nЕсли кнопка выделена, вы будете продавать ненужные вещи вендору автоматически.'
    L['INVENTORY_REPAIR_ERROR'] = 'О боже, у тебя кончается золото!'
    L['INVENTORY_REPAIR_COST'] = 'Стоимость ремонта (%s)'
    L['INVENTORY_SELL_JUNK'] = 'Авто-продажа мусора'
    L['INVENTORY_SELL_JUNK_TIP'] = '|nЕсли кнопка выделена, вы автоматически отремонтируете вещи у кузнеца.'
    L['INVENTORY_SELL_JUNK_EARN'] = 'Авто-продажа на (%s)'
    L['INVENTORY_SEARCH'] = 'Поиск'
    L['INVENTORY_SEARCH_ENABLED'] = 'Введите имя для поиска'
    L['INVENTORY_MARK_JUNK'] = 'Пометить мусор'
    L['INVENTORY_MARK_JUNK_ENABLED'] =
        '|nНажмите, чтобы пометить элемент как мусор.|nЕсли Авто-продажа мусора включена, эти предметы также будут продаваться.|n Список сохраняется на всей учетной записи.|n Удерживайте Ctrl+Alt и щелкните, чтобы стереть настраиваемый список хлама .'
    L['INVENTORY_QUICK_SPLIT'] = 'Быстрое разделение'
    L['INVENTORY_SPLIT_COUNT'] = 'Split count' -- Need translete
    L['INVENTORY_SPLIT_MODE_ENABLED'] = '|nНажмите, чтобы разделить предметы в ваших сумках|nВы можете изменить split count для каждого клика через поле редактирования.'

    L['INVENTORY_AUTO_DEPOSIT'] =
        '|nЩелкните левой кнопкой мыши, чтобы внести реагенты, щелкните правой кнопкой мыши, чтобы переключить автоматическое внесение.|nЕсли кнопка будет выделена, то реагенты из ваших сумок будут автоматически скидываться, как только вы откроете банк.'
    L['INVENTORY_EQUIPEMENT_SET'] = 'Комплект сета'
end

--[[ Map ]]
do
    L['MAP_MOVER_MINIMAP'] = 'Миникарта'
    L['MAP_CURSOR'] = 'курсор'
    L['MAP_REVEAL'] = 'Убрать туман войны'
    L['MAP_PARAGON'] = 'Парагон'
    L['MAP_NEXT_TRAIT'] = 'Следующий трейт'
    L['MAP_NEW_MAIL'] = '<Новое письмо>'
    L['MAP_CALENDAR'] = 'Календарь'
end

-- Tooltip
do
    L['TOOLTIP_MOVER'] = 'Подсказки'
    L['TOOLTIP_RARE'] = 'Редкий'
    L['TOOLTIP_AURA_FROM'] = 'скастовано'
    L['TOOLTIP_SELL_PRICE'] = 'Прайс'
    L['TOOLTIP_STACK_CAP'] = 'Стак'
    L['TOOLTIP_ID_AZERITE_TRAIT'] = 'Азеритовый талант'
    L['TOOLTIP_BAG'] = 'Сумка'
    L['TOOLTIP_ID_SPELL'] = 'SpellID'
    L['TOOLTIP_ID_ITEM'] = 'ItemID'
    L['TOOLTIP_ID_COMPANION'] = 'CompanionID'
    L['TOOLTIP_ID_QUEST'] = 'QuestID'
    L['TOOLTIP_ID_TALENT'] = 'TalentID'
    L['TOOLTIP_ID_ACHIEVEMENT'] = 'AchievementID'
    L['TOOLTIP_ID_CURRENCY'] = 'CurrencyID'
    L['TOOLTIP_ID_VISUAL'] = 'Visual'
    L['TOOLTIP_ID_SOURCE'] = 'Source'
    L['TOOLTIP_SECTION'] = 'Секция'
    L['TOOLTIP_TARGETED'] = 'Цель'
    L['TOOLTIP_ILVL'] = 'iLvl'
end

--[[ Unitframe ]]
do
    L['UNITFRAME_MOVER_CASTBAR'] = 'Focus castbar'
    L['UNITFRAME_MOVER_PLAYER'] = 'Player'
    L['UNITFRAME_MOVER_PET'] = 'Pet'
    L['UNITFRAME_MOVER_TARGET'] = 'Target'
    L['UNITFRAME_MOVER_TARGETTARGET'] = 'Target target'
    L['UNITFRAME_MOVER_FOCUS'] = 'Focus'
    L['UNITFRAME_MOVER_FOCUSTARGET'] = 'Focus target'
    L['UNITFRAME_MOVER_BOSS'] = 'Boss'
    L['UNITFRAME_MOVER_ARENA'] = 'Arena'
    L['UNITFRAME_MOVER_PARTY'] = 'Party'
    L['UNITFRAME_MOVER_RAID'] = 'Raid'

    L['UNITFRAME_GHOST'] = 'Ghost'
    L['UNITFRAME_OFFLINE'] = 'Offline'
end

--[[ GUI ]]
L.GUI = {
    ['HINT'] = 'Подсказка',
    ['RELOAD'] = '|cffff2020Вы хотите перезагрузить интерфейс, чтобы применить настройки ?|r',
    ['RESET_GOLD'] = '|cffff2020Отчистить статистику золота?|r',
    ['RESET_JUNK_LIST'] = '|cffff2020Следует ли очистить пользовательский список нежелательных элементов?|r',

    SPELL_ID = 'Spell ID',
    SPELL_ID_TIP = '|nSpell ID, должно быть число.|n|nВы можете получить ID на подсказке заклинания.|n|nИмя заклинаний не поддерживается.',
    INCORRECT_ID = 'Неправильный SpellID.',
    EXISTING_ID = 'Этот SpellID уже существует.',
    RESET_LIST = 'Вы уверены, что восстановите список по умолчанию?',

    WIDTH = 'ширина',
    HEIGHT = 'высота',
    SIZE = 'размер',
    ALPHA = 'альфа',

    ['MOVER'] = {
        ['NAME'] = 'UI Mover',
        ['GRID'] = 'Сетка',
        ['RESET_ELEMENT'] = 'Сбросить позицию этой рамки ',
        ['HIDE_ELEMENT'] = 'Скрыть этот фрейм',
        ['RESET'] = 'Вы уверены, что хотите сбросить все позиции фреймов?',
        ['GROUP_TOOL'] = 'Инструмент группы',

        ['QUEST_BUTTON'] = 'Кнопка квеста',
        ['OBJECTIVE_TRACKER'] = 'отслеживание обьекта',
        ['MAW_THREAT_BAR'] = 'Око тюремщика',
        ['PLAYER_PLATE'] = 'Рамка игрока',
    },

    ['PROFILE'] = {
        ['NAME'] = 'Профили',
        ['RESET_WARNING'] = 'Вы уверены что хотите сбросить |cffff2020ALL|r настройки?',
        ['RESET_PROFILE_WARNING'] = 'Вы уверены, что хотите сбросить текущий профиль?',
        ['APPLY_SELECTED_PROFILE'] = 'Вы уверены что хотите переключиться на выбранный профиль?',
        ['DOWNLOAD_SELECTED_PROFILE'] = 'Вы уверены, что хотите заменить свой текущий профиль на выбранный?',
        ['UPLOAD_CURRENT_PROFILE'] = 'Вы уверены, что хотите заменить выбранный профиль на ваш текущий?',
        ['IMPORT_ERROR'] = 'Импорт не удался из-за неверных данных.',
        ['IMPORT_WARNING'] = 'Вы уверены, что хотите импортиртировать настройки?',
        ['INFO'] = 'Инфо',
        ['VERSION'] = 'Версия',
        ['CHARACTER'] = 'Персонаж',
        ['EXCEPTION'] = 'Data exception',
        ['RESET_TIP'] = 'Удалить %AddonName% и все настройки.',
        ['IMPORT_TIP'] = 'Импорт настроек.',
        ['EXPORT_TIP'] = 'Экспорт настроек.',
        ['RESET'] = 'Сбросить',
        ['IMPORT'] = 'Импорт',
        ['EXPORT'] = 'Экспорт',
        ['IMPORT_HEADER'] = 'Импорт настроек',
        ['EXPORT_HEADER'] = 'Экспорт настроек',
        ['DEFAULT_CHARACTER_PROFILE'] = 'Профиль персонажа',
        ['DEFAULT_SHARED_PROFILE'] = 'Расшаренный профиль',
        ['PROFILE_NAME'] = 'Имя профиль',
        ['PROFILE_NAME_TIP'] = '|nНастройте имя своего профиля. Если поле ввода оставить пустыи, все настройки вернуться по умолчанию.|n|nКогда вы закончите печатать, нажмите клавишу ENTER.',
        ['RESET_PROFILE'] = 'Сбросить профиль',
        ['RESET_PROFILE_TIP'] = '|nСбросить текущий профиль и вернуть настройки по умолчанию. Требуется перезагрузка UI.',
        ['SELECT_PROFILE'] = 'Выбрать профиль',
        ['SELECT_PROFILE_TIP'] = '|nПереключиться на выбранный профиль, требуется перезагрузка UI.',
        ['DOWNLOAD_PROFILE'] = 'Заменить существующий профиль',
        ['DOWNLOAD_PROFILE_TIP'] = '|nЗаменить текущий профиль выбранным, требуется перезагрузка UI.',
        ['UPLOAD_PROFILE'] = 'Заменить выбранный профиль',
        ['UPLOAD_PROFILE_TIP'] = '|nЗаменить выбранный профиль на текущий.',
        ['PROFILE_MANAGEMENT'] = 'Управление профилем',
        ['PROFILE_DESCRIPTION'] = 'Вы можете управлять своим профилем аддона, пожалуйста, сделайте резервную копию своих настроек перед запуском. Настройки по умолчанию основаны на вашем персонаже, не будут шарится в рамках одной учетной записи. Вы можете переключиться на общий профиль, чтобы расшарить его между вашими персонажами, и избавиться от передачи данных.',
        ['SHARED_CHARACTERS'] = 'Общие персонажи',
        ['DELETE_UNIT_PROFILE_WARNING'] = 'Вы уверены что хотите удалить %s%s|r информацию о профиле?',
        ['INCORRECT_UNIT_NAME'] = 'Неправильное имя персонажа.',
        ['DELETE_UNIT_PROFILE'] = 'Полностью удалить профиль',
        ['DELETE_UNIT_PROFILE_TIP'] = '|nВведите имя персонажа, который вы собираетесь удалить из своего профиля, формат ввода \'ИмяПерсонажа-ИмяСервера\'. Вам нужно ввести только имя, если персонаж находится на этом же сервере.|n|nЭто также приведет к удалению информации о золоте.|n|nНажмите клавишу ESC, чтобы очистить поле редактирования, нажмите клавишу Enter, чтобы подтвердить.',
    },

    ['MISC'] = {
        ['NAME'] = 'Разное',
        ['TEXTURE_STYLE'] = 'Стиль текстур',
        ['TEXTURE_NORM'] = 'стандарт',
        ['TEXTURE_GRAD'] = 'градиент',
        ['TEXTURE_FLAT'] = 'плоский',
        ['NUMBER_FORMAT'] = 'Нумерация',
        ['NUMBER_TYPE1'] = 'Стандартная: b/m/k',
        ['NUMBER_TYPE2'] = 'Азиатская: y/w',
        ['NUMBER_TYPE3'] = 'Полностью цифровая',
        ['CUSTOM_CLASS_COLOR'] = 'Настройка цветов класса',
        ['CUSTOM_CLASS_COLOR_SETTING_HEADER'] = 'Настройка пользовательских цветов класса',
        ['HIDE_TALKINGHEAD'] = 'Скрыть говорящую голову',
        ['HIDE_BOSS_BANNER'] = 'Скрыть баннер босса',
        ['FONT_OUTLINE'] = 'Использовать контур шрифта',
        ['SCREEN_SAVER'] = 'AFK заставка',
        ['CONCISE_ERRORS'] = 'Упрощенные ошибки',
        ['MAW_THREAT_BAR'] = 'Панель Ока тюремщика',
        ['AUTO_SCREENSHOT'] = 'Включить (АС)Авто-скриншоты',
        ['AUTO_SCREENSHOT_ACHIEVEMENT'] = '(АС) Новое достижение заработано',
        ['AUTO_SCREENSHOT_CHALLENGE'] = '(АС) Мифик+ завершен',
        ['ITEM_LEVEL'] = 'Item lvl',
        ['ITEM_LEVEL_TIP'] = 'Показать Item lvl в рамке персонажа.',
        ['GEM_ENCHANT'] = 'Зачарования и камни',
        ['GEM_ENCHANT_TIP'] = 'Показывать зачаровиня и камни в рамке персонажа.',
        ['NAKED_BUTTON'] = 'Кнопка раздется',
        ['NAKED_BUTTON_TIP'] = 'Показать кнопку раздется в рамке персонажа, двойной клик что бы снять всю броню.',
        ['MISSING_STATS'] = 'Потерянные статы',
        ['MISSING_STATS_TIP'] = 'Показывать все статы в окне персонажа.',
    },

    ['APPEARANCE'] = {
        ['NAME'] = 'Стили',
        ['CURSOR_TRAIL'] = 'Хвост курсора',
        ['RESKIN_BLIZZ'] = 'Рестайл Blizzard интерфейса',
        ['VIGNETTING'] = 'Виньетка (по краям экрана)',
        ['BACKDROP_ALPHA'] = 'Прозрачность фона',
        ['VIGNETTING_ALPHA'] = 'Прозрачность виньетки',
        ['SHADOW_BORDER'] = 'Тень границ',
        ['UI_SCALE'] = 'Маштаб UI',
        ['UI_SCALE_TIP'] = 'Отрегулируйте глобальный масштаб для всего интерфейса.|nРекомендуется 1080P на 1, 1440P на 1.2-1.4, 2160P на 2.',
        ['RESKIN_DBM'] = 'Рестайл полос DBM',
        ['RESKIN_PGF'] = 'Рестайл панели PGF',
        ['BACKDROP_COLOR'] = 'Цвет фона',
        ['BORDER_COLOR'] = 'Цвет границ',
        ['RESKIN_WA'] = 'Рестайл иконок WeakAuras',
        ['RESKIN_BW'] = 'Рестайл полос BigWigs',
    },

    ['NOTIFICATION'] = {
        ['NAME'] = 'Уведомления',
        ['ENABLE'] = 'Включить уведомления',
        ['BAG_FULL'] = 'Полная сумка',
        ['NEW_MAIL'] = 'Новое письмо',
        ['RARE_FOUND'] = 'Рядом событие (рарник,сундук)',
        ['RARE_FOUND_TIP'] = 'Вокруг появляются рарники или сундуки, обратите внимание на миникарту, чтобы определить местоположение.',
        ['VERSION_CHECK'] = 'Аддон устарел',
    },

    ['INFOBAR'] = {
        ['NAME'] = 'Инфо-панель',
        ['ENABLE'] = 'Включить Инфо-панель',
        ['ANCHOR_TOP'] = 'Привязка к верху',
        ['MOUSEOVER'] = 'По наведению мыши',
        ['STATS'] = 'Системная информация',
        ['SPEC'] = 'Спек и добыча',
        ['DURABILITY'] = 'Прочность',
        ['GUILD'] = 'Гильдия',
        ['FRIENDS'] = 'Друзья',
        ['REPORT'] = 'Дейли/Викли',
        ['CURRENCY'] = 'Валюты',
    },

    ['CHAT'] = {
        ['NAME'] = 'Чат',
        ['ENABLE'] = 'Включить Чат',
        ['LOCK_POSITION'] = 'Зафиксировать позицию',
        ['LOCK_POSITION_TIP'] = 'Положение и размер окна чата фиксированы.',
        ['FONT_OUTLINE'] = 'Контур шрифта',
        ['FADE_OUT'] = 'Затухание',
        ['FADE_OUT_TIP'] = 'Окно чата будет постепенно исчезать, если в течение определенного периода времени нет новой информации.',
        ['ABBR_CHANNEL_NAMES'] = 'Сократить названия каналов',
        ['VOICE_BUTTON'] = 'Кнопка голоса',
        ['TAB_CYCLE'] = 'Цикл вкладки',
        ['TAB_CYCLE_TIP'] = 'После ввода нажмите TAB, для быстрого переключения каналов.',
        ['SMART_BUBBLE'] = 'Всплывающие окна чата(bubbles)',
        ['SMART_BUBBLE_TIP'] = 'Уберите галочку, чтобы включить всплывающее окно чата. Установите галочку, чтобы убрать всплывающие окна чата.',
        ['WHISPER_STICKY'] = 'Липкий шепот',
        ['WHISPER_SOUND'] = 'Звук личных сообщений',
        ['ITEM_LINKS'] = 'Extend item link', --Need translete
        ['DAMAGE_METER_FILTER'] = 'DMG фильтр',
        ['USE_FILTER'] = 'Использовать фильтр чата',
        ['BLOCK_ADDON_SPAM'] = 'Блокировать спам аддонов',
        ['ALLOW_FRIENDS_SPAM'] = 'Разрешить друзьям спамить',
        ['ALLOW_FRIENDS_SPAM_TIP'] = 'Не фильтровать информацию от друзей, группы и членов гильдии.',
        ['BLOCK_STRANGER_WHISPER'] = '|cffff2020Блок. странные сообщения|r',
        ['WHITE_LIST'] = 'Белый лист',
        ['WHITE_LIST_TIP'] = 'Будут отображаться только сообщения чата, содержащие ключевые слова из белого списка|n|nКогда есть несколько ключевых слов, они разделяются пробелами.|n|nПосле ввода нажмите Enter для сохранения.',
        ['MATCHE_NUMBER'] = 'Matche number',
        ['BLACK_LIST'] = 'Блэк лист',
        ['BLACK_LIST_TIP'] = 'Контент чата, содержащий отфильтрованные ключевые слова, будет заблокирован, когда будет достигнуто количество совпадений.|n|nЕсли ключевых слов несколько, они разделяются пробелами.|n|nПосле ввода нажмите Enter, чтобы сохранить',
        ['WHISPER_INVITE'] = 'Вкл. приглашение шепотом',
        ['GUILD_ONLY'] = 'Только от гильдии',
        ['INVITE_KEYWORD'] = 'Ключевое слово',
        ['GROUP_LOOT_FILTER'] = 'Отфильтровать добычу группы',
        ['GROUP_LOOT_THRESHOLD'] = 'Фильтровать добычу от:',
        ['GROUP_LOOT_COMMON'] = 'Common',
        ['GROUP_LOOT_UNCOMMON'] = 'Uncommon',
        ['GROUP_LOOT_RARE'] = 'Rare',
        ['GROUP_LOOT_EPIC'] = 'Epic',
        ['GROUP_LOOT_LEGENDARY'] = 'Legendary',
        ['GROUP_LOOT_ARTIFACT'] = 'Artifact',
        ['GROUP_LOOT_HEIRLOOM'] = 'Heirloom',
        ['GROUP_LOOT_ALL'] = 'All',
        ['FILTER_SETTING_HEADER'] = 'Настройка фильтра чата',
        ['CHANNEL_BAR'] = 'Панель каналов',
    },

    ['AURA'] = {
        ['NAME'] = 'Баффы',
        ['ENABLE'] = 'Включить баффы/дебаффы',
        ['ENABLE_TIP'] = 'Настройки и дополнительные функции',
        ['REVERSE_BUFFS'] = 'Обратные баффы',
        ['REVERSE_DEBUFFS'] = 'Обратные дебаффы',
        ['MARGIN'] = 'Отступ',
        ['OFFSET'] = 'Смещение',
        ['BUFF_SIZE'] = 'Размер баффа',
        ['DEBUFF_SIZE'] = 'Размер дебаффа',
        ['BUFFS_PER_ROW'] = 'Баффов в строке',
        ['DEBUFFS_PER_ROW'] = 'Дебаффов в строке',
        ['REMINDER'] = 'Напоминание для баффов',
        ['REMINDER_TIP'] = 'Напоминать вам о недостатке баффа вашего класса.|nПоддержка: Выносливость, Яды, Интелект, Боевой крик.',
    },

    ['ACTIONBAR'] = {
        ['NAME'] = 'Панель скилов',
        ['ENABLE'] = 'Включить панель действий',
        ['ENABLE_TIP'] = '|nФункции и стили, связанные с панелью действий.',
        ['BAR_SCALE'] = 'Размер панелей',
        ['HOTKEY'] = 'Показывать горячие клавиши',
        ['MACRO_NAME'] = 'Показывать имя макроса',
        ['COUNT_NUMBER'] = 'Количество и заряды',
        ['CLASS_COLOR'] = 'Панель под цвет класса',
        ['FADER'] = 'Затухание панели действий',
        ['FADER_TIP'] = '|nПанель действий плавно появляется и исчезает в зависимости от определенных условий..',
        ['BAR1'] = 'Панель 1',
        ['BAR2'] = 'Панель 2',
        ['BAR3'] = 'Панель 3',
        ['BAR3_DIVIDE'] = 'Доп. панель 3',
        ['BAR4'] = 'Панель 4',
        ['BAR5'] = 'Панель 5',
        ['PET_BAR'] = 'Панель питомца',
        ['STANCE_BAR'] = 'Панель стоек',
        ['LEAVE_VEHICLE_BAR'] = 'Кнопка "Покинуть транспорт"',

        ['SCALE_SETTING'] = 'Размер панели действий',

        ['FADER_SETTING'] = 'Настройка затухания панели действий',
        ['CONDITION_COMBATING'] = 'В бою',
        ['CONDITION_TARGETING'] = 'Взята цель/фокус',
        ['CONDITION_DUNGEON'] = 'В подземелье',
        ['CONDITION_PVP'] = 'На БГ и Арене',
        ['CONDITION_VEHICLE'] = 'На транспорте',
        ['FADE_OUT_ALPHA'] = 'исчезнуть альфа',
        ['FADE_IN_ALPHA'] = 'замирание в альфа',
        ['FADE_OUT_DURATION'] = 'длительность затухания',
        ['FADE_IN_DURATION'] = 'длительность появления',

        ['CUSTOM_BAR_SETTING'] = 'Дополнительная настройка панели действий',
        ['CUSTOM_BAR'] = 'Дополнительная панель',
        ['CUSTOM_BAR_TIP'] = '|nВключите дополнительную панель действий для настройки.',
        ['CB_MARGIN'] = 'Край кнопок',
        ['CB_PADDING'] = 'Заполнение кнопок',
        ['CB_BUTTON_SIZE'] = 'размер кнопок',
        ['CB_BUTTON_NUMBER'] = 'номер кнопки',
        ['CB_BUTTON_PER_ROW'] = 'кнопок в строке',

        ['COOLDOWN_COUNT'] = 'Время восстановления заклинаний',
        ['DECIMAL_CD'] = 'Дин. для перезарядок в 3с',
        ['OVERRIDE_WA'] = 'Скрыть время на WeakAuras',
        ['CD_FLASH'] = 'Вспышка готовности',
        ['CD_FLASH_TIP'] = '|nОтслеживайте время перезарядки с помощью значка вспышки в центре экрана.',
        ['CD_NOTIFY'] = 'Уведом. времени восстановления',
        ['CD_NOTIFY_TIP'] = '|nЕсли эта функция включена, вы можете нажать колесико мыши на кнопку панели действий и отправить ее состояние перезарядки в группу.|n|nДоступно только для FreeUI пенели действий.',
    },

    ['COMBAT'] = {
        ['NAME'] = 'Бой',
        ['ENABLE'] = 'Включить бой',
        ['ENABLE_TIP'] = 'Предоставляет функции, связанные с боем',
        ['COMBAT_ALERT'] = 'Предупреждения о бое',
        ['COMBAT_ALERT_TIP'] = 'Анимационная подсказка отображается в середине экрана при входе или выходе из боя.',
        ['SPELL_SOUND'] = 'Звуки прерываний',
        ['SPELL_SOUND_TIP'] = 'Воспроизвести звук, когда вы успешно прерываете заклинание.',
        ['EASY_TAB'] = 'Авто ТАБ',
        ['EASY_TAB_TIP'] = 'При входе на поле боя или арену клавиша Tab будет игнорировать питомцев, после выхода с поля боя или арены значение становится по умолчанию.',
        ['EASY_FOCUS'] = 'Быстрый фокус',
        ['EASY_FOCUS_TIP'] = 'Shift+щелчок левой кнопкой мыши по фрейму юнита быстро устанавливается в фокус.',
        ['EASY_FOCUS_ON_UNITFRAME'] = 'Быстрой фокус по юнитфреймам',
        ['EASY_FOCUS_ON_UNITFRAME_TIP'] = 'Быстрый фокус по юнитфреймам если они включенны.',
        ['EASY_MARK'] = 'Быстрые метки',
        ['EASY_MARK_TIP'] = 'Alt+Щелкните левой кнопкой мыши на фрейм, чтобы быстро установить метку.',
        ['PVP_SOUND'] = 'PVP звкуи',
        ['PVP_SOUND_TIP'] = 'Добавить звуковую тему, похожую на DotA(Unreal), к PVP-убийствам',
        ['FCT'] = 'Включить "плавающий" текст боя',
        ['FCT_IN'] = 'Показывать входящий урон',
        ['FCT_OUT'] = 'Показывать исходящий урон',
        ['FCT_PET'] = 'Показывать урон питомца',
        ['FCT_PERIODIC'] = 'Показывать переодический урон',
        ['FCT_MERGE'] = 'Показывать поглащенный урон',
    },

    ['ANNOUNCEMENT'] = {
        ['NAME'] = 'Уведомления',
        ['ENABLE'] = 'Включить уведомления',
        ['ENABLE_TIP'] = 'Модуль уведомления-это инструмент, который будет вам показывать сообщения.',
        ['INTERRUPT'] = 'Сбитие',
        ['INTERRUPT_TIP'] = 'Отправлять сообщение при успешном прирывании.',
        ['DISPEL'] = 'Диспел',
        ['DISPEL_TIP'] = 'Отправлять сообщение при успешном диспеле.',
        ['BATTLEREZ'] = 'БР',
        ['BATTLEREZ_TIP'] = 'Отправлять сообщение при успешном БРе.',
        ['UTILITY'] = 'Полезности',
        ['UTILITY_TIP'] = 'Отправлять сообщение при использовании порталов, еды, рембота и и т.п.',
        ['RESET'] = 'Подземелье обновленно',
        ['RESET_TIP'] = 'Отправить сообщение при обновлении подземелья.',
        ['COOLDOWN'] = 'Состояние перезарядки',
        ['COOLDOWN_TIP'] = 'Вы можете нажать колесиком мыши на кнопку панели действий и отправить ее статус перезарядки в группу.|nДоступно только для FreeUI панели действий.',
    },

    ['INVENTORY'] = {
        ['NAME'] = 'Инвентарь',
        ['ENABLE'] = 'Включить интвентарь',
        ['ENABLE_TIP'] = 'Отрегулируйте инвентарь и функции, связанные с банком.',
        ['NEW_ITEM_FLASH'] = 'Подсвечивать новые предметы',
        ['NEW_ITEM_FLASH_TIP'] = 'Новые предметы будут иметь эффект свечения, наведите курсор мыши что бы убрать свечение.',
        ['COMBINE_FREE_SLOTS'] = 'Комбинировать пустые слоты',
        ['COMBINE_FREE_SLOTS_TIP'] = 'Объединить все пустые слоты в один, чтобы сэкономить место на дисплее.',
        ['BIND_TYPE'] = 'Показывать тип предмета',
        ['BIND_TYPE_TIP'] = '(BOA)и(BOE)предметы будут подписанны в инвентаре',
        ['ITEM_LEVEL'] = 'Показать iLvL вещей',
        ['SPECIAL_COLOR'] = 'Специальный цвет',
        ['SPECIAL_COLOR_TIP'] = 'Специальный цвет предметов для быстрого различия.',
        ['ITEM_FILTER'] = 'Включить фильтр предметов',
        ['ITEM_FILTER_TIP'] = 'Предметы в рюкзаке в соответствии с соответствующей классификацией будут отображаться отдельно.',
        ['SLOT_SIZE'] = 'Размер слота',
        ['SPACING'] = 'Отступ',
        ['BAG_COLUMNS'] = 'Слотов в строку',
        ['BANK_COLUMNS'] = 'Банковские слоты в строку',
        ['ITEM_LEVEL_TO_SHOW'] = 'Уровень предмета для отображения',
        ['ITEM_LEVEL_TO_SHOW_TIP'] = 'iLvL ниже этого параметра не будет отображаться.',
        ['SORT_MODE'] = 'Режим сортировки',
        ['SORT_TO_TOP'] = 'Вперед',
        ['SORT_TO_BOTTOM'] = 'Назад',
        ['SORT_TIP'] = 'Если у вас есть пустые слоты после сортировки сумок, пожалуйста, отключите модуль инвентаризации и отключите фильтр всех сумок в контейнерах пользовательского интерфейса по умолчанию.',
        ['FILTER_SETUP'] = 'Установка фильтра',
        ['ITEM_FILTER_JUNK'] = 'Мусор',
        ['ITEM_FILTER_CONSUMABLE'] = 'Расходники',
        ['ITEM_FILTER_AZERITE'] = 'Азеритовая броня',
        ['ITEM_FILTER_EQUIPMENT'] = 'Экиперовка',
        ['ITEM_FILTER_LEGENDARY'] = 'Легендарки',
        ['ITEM_FILTER_COLLECTION'] = 'Коллекции',
        ['ITEM_FILTER_FAVOURITE'] = 'Избранные',
        ['ITEM_FILTER_TRADE'] = 'Трейд',
        ['ITEM_FILTER_QUEST'] = 'Квест',
        ['ITEM_FILTER_GEAR_SET'] = 'Экипировки сэтов',
    },

    ['MAP'] = {
        ['NAME'] = 'Карта',
        ['ENABLE'] = 'Включить карту',
        ['ENABLE_TIP'] = 'Настройка карты-миникарты и связанных с ней функций',
        ['REMOVE_FOG'] = 'Убрать "Туман войны"',
        ['COORDS'] = 'Показывать координаты',
        ['WORLDMAP_SCALE'] = 'Размер карты',
        ['MAX_WORLDMAP_SCALE'] = 'Максимальный масштаб карты',
        ['WHO_PINGS'] = 'Показать кто пингует',
        ['MICRO_MENU'] = 'Микро-меню',
        ['MICRO_MENU_TIP'] = 'Щелчок средней кнопкой мыши по миникарте вызовет микро-меню.',
        ['PROGRESS_BAR'] = 'XP/REP индикатор',
        ['PROGRESS_BAR_TIP'] = 'В верхней части миникарты отображается индикатор прогресса, вы можете отслеживать опыт игрока, его репутацию и честь, а также другую связанную с этим информацию о прогрессе.',
        ['MINIMAP_SCALE'] = 'Масштаб мини-карты',
    },

    ['TOOLTIP'] = {
        ['NAME'] = 'Подсказки',
        ['ENABLE'] = 'Включить подсказки',
        ['ENABLE_TIP'] = 'Функции, связанные с подсказками.',
        ['FOLLOW_CURSOR'] = 'Следловать за курсором',
        ['FOLLOW_CURSOR_TIP'] = 'Подсказки следуют за мышью, при отключении фиксируется в правом нижнем углу.',
        ['HIDE_IN_COMBAT'] = 'Скрывать в бою',
        ['BORDER_COLOR'] = 'Граница по цвету класса',
        ['TIP_ICON'] = 'Показать иконки',
        ['EXTRA_INFO'] = 'Показать доп. информацию',
        ['EXTRA_INFO_TIP'] = 'Удерживайте нажатой клавишу Alt,чтобы отобразить ID элемента,запас банка-рюкзака, ID навыка, источник ауры и другую дополнительную информацию.',
        ['SPEC_ILVL'] = 'Показать Спек и iLvL',
        ['SPEC_ILVL_TIP'] = 'Зажать ALT для отображения Спека и iLvLа.',
        ['AZERITE_ARMOR'] = 'Упр. инф. по азеритовой броне',
        ['CONDUIT_INFO'] = 'Показать информацию кондуита',
        ['TARGET_BY'] = 'Показать targetby,',
        ['HIDE_REALM'] = 'Скрыть Реалм',
        ['HIDE_TITLE'] = 'Скрыть титул',
        ['HIDE_RANK'] = 'Скрыть ранг гильдии',
        ['DISABLE_FADING'] = 'Отключить анимацию',
        ['HEALTH_VALUE'] = 'Показать ценность здоровья',
    },

    ['UNITFRAME'] = {
        ['NAME'] = 'Юнит-фреймы',
        ['ENABLE'] = 'Включить юнит-фреймы',
        ['UNITFRAME_SIZE_SETTING_HEADER'] = 'Настройка размеров юнит-фреймов',
        ['TRANSPARENT_MODE'] = 'Прозрачный стиль',
        ['FADE'] = 'Динамическое затухание',
        ['FADER_SETTING_HEADER'] = 'Настройки динамического затухания',
        ['CONDITION_COMBAT'] = 'В Бою',
        ['CONDITION_TARGET'] = 'Выбрана цель',
        ['CONDITION_INSTANCE'] = 'В подземелье',
        ['CONDITION_ARENA'] = 'На арене',
        ['CONDITION_CASTING'] = 'Каст',
        ['CONDITION_INJURED'] = 'Раненый',
        ['CONDITION_MANA'] = 'Не полная мана',
        ['CONDITION_POWER'] = 'Есть ресурс',
        ['FADE_OUT_ALPHA'] = 'Прозрачность затухания',
        ['FADE_IN_ALPHA'] = 'Прозрачность появления',
        ['FADE_OUT_DURATION'] = 'Скорость появления',
        ['FADE_IN_DURATION'] = 'Скорость затухания',
        ['RANGE_CHECK'] = 'Проверка дальности',
        ['PORTRAIT'] = 'Портреты',
        ['HEAL_PREDICTION'] = 'Прогноз исцеления',
        ['GCD_INDICATOR'] = 'GCD индикатор',
        ['CLASS_POWER_BAR'] = 'Классовая панель',
        ['STAGGER_BAR'] = 'Stagger bar',
        ['TOTEMS_BAR'] = 'Панель тотемов',
        ['DEBUFFS_BY_PLAYER'] = 'Фильтр дебаффов',
        ['DEBUFF_TYPE'] = 'Тип дебаффа',
        ['STEALABLE_BUFFS'] = 'Стил баффы',
        ['PLAYER_COMBAT_INDICATOR'] = 'Индикатор боя',
        ['PLAYER_RESTING_INDICATOR'] = 'Индикатор покоя',
        ['PLAYER_HIDE_TAGS'] = 'Скрыть теги игроков',
        ['ENABLE_CASTBAR'] = 'Включить кастбары',
        ['CASTBAR_SETTING_HEADER'] = 'Настройка кастбаров',
        ['CASTBAR_TIMER'] = 'Показать таймер кастбара',
        ['CASTBAR_FOCUS_SEPARATE'] = 'Separate focus castbar',
        ['CASTBAR_COLORS'] = 'Цвета',
        ['CASTBAR_WIDTH'] = 'Ширина',
        ['CASTBAR_HEIGHT'] = 'Высота',
        ['CASTING_COLOR'] = 'Обычный',
        ['CASTING_UNINTERRUPTIBLE_COLOR'] = 'Непрерываемый',
        ['CASTING_COMPLETE_COLOR'] = 'Полный',
        ['CASTING_FAIL_COLOR'] = 'Неудачный',
        ['CASTBAR_FOCUS'] = 'Кастбар фокуса',
        ['CASTBAR_FOCUS_WIDTH'] = 'Ширина кастбара фокуса',
        ['CASTBAR_FOCUS_HEIGHT'] = 'Высота кастбара фокуса',
        ['ENABLE_BOSS'] = 'Включить босс фрейм фреймы',
        ['BOSS_COLOR_SMOOTH'] = 'Шладкий цвет фрейма босса',
        ['ENABLE_ARENA'] = 'Включить арена фреймы',
        ['CAT_PLAYER'] = 'Игрок',
        ['CAT_TARGET'] = 'Цель',
        ['CAT_FOCUS'] = 'Фокус',
        ['CAT_PET'] = 'Питомец',
        ['CAT_BOSS'] = 'Босс',
        ['CAT_ARENA'] = 'Арена',
        ['CAT_POWER'] = 'Power',
        ['SET_WIDTH'] = 'ширина',
        ['SET_HEIGHT'] = 'выстота',
        ['SET_GAP'] = 'gap', -- Need translete
        ['SET_POWER_HEIGHT'] = 'Высота ресурса',
        ['SET_ALT_POWER_HEIGHT'] = 'Высота альтернативного ресурса',
        ['COLOR_STYLE'] = 'Цвет ХП',
        ['COLOR_STYLE_DEFAULT'] = 'По умолчанию белый',
        ['COLOR_STYLE_CLASS'] = 'Класс цветной',
        ['COLOR_STYLE_GRADIENT'] = 'Процентный градиент',
        ['TARGET_ICON_INDICATOR_ALPHA'] = 'Непрозрачность Значка Индикатора',
        ['TARGET_ICON_INDICATOR_SIZE'] = 'Размер значка индикатора',
        ['ABBR_NAME'] = 'Сокращение имен',
        ['ABBR_NAME_TIP'] = 'Сокращенные имена на неймплейтах и панелях.',
    },

    ['GROUPFRAME'] = {
        ['NAME'] = 'Груп-фреймы',
        ['ENABLE_GROUP'] = 'Включить груп-фреймы',
        ['GROUPFRAME_SIZE_SETTING_HEADER'] = 'Настройки размеров груп-фреймов',
        ['GROUP_NAME'] = 'Показать имена',
        ['GROUP_THREAT_INDICATOR'] = 'Индикатор угрозы',
        ['GROUP_DEBUFF_HIGHLIGHT'] = 'Подсветить диспел',
        ['GROUP_DEBUFF_HIGHLIGHT_TIP'] = 'Всякий раз, когда член группы имеет рассеиваемый дебафф, выделяет рамку цветом дебаффа.',
        ['CORNER_INDICATOR'] = 'Индикатор угловых баффов', -- ??
        ['INSTANCE_AURAS'] = 'Рейдовые дебаффы',
        ['INSTANCE_AURAS_TIP'] = 'Показать основные дебаффы в рейде и подземелье.|nПоказывать только рассеиваемые дебаффы, если они отключены.',
        ['AURAS_CLICK_THROUGH'] = 'Скрыть подск. от баффов/дебаффов',
        ['PARTY_SPELL_WATCHER'] = 'Показать групповые закл.',
        ['PARTY_SPELL_SYNC'] = 'Синхронизировать групповые закл.',
        ['PARTY_SPELL_SYNC_TIP'] = 'Если этот параметр включен, то состояние перезарядки будет синхронизироваться с членами группы, которые используют FreeUI или ZenTracker(WA).|nЭто может снизить производительность.',
        ['PARTY_SPELL_SETTING_HEADER'] = 'Настройка груповых перезарядок',
        ['PARTY_SPELL_RESET_WARNING'] = 'Вы уверены, что хотите сбросить список по умолчанию?',
        ['PARTY_SPELL_PRESET'] = 'Пресет',
        ['INCOMPLETE_INPUT'] = 'Вам нужно заполнить все * опции.',
        ['INCORRECT_SPELLID'] = 'Некорректный SpellID.',
        ['EXISTING_ID'] = 'SpellID существует.',
        ['SPELL_ID'] = 'Spell ID',
        ['SPELL_ID_TIP'] = '|nSpell ID, только числа.|nSpell имена не поддерживаются.',
        ['SPELL_COOLDOWN'] = 'Перезарядка заклинания*',
        ['SPELL_COOLDOWN_TIP'] = '|nEnter the spell\'s cooldown duration.|nOnly support regular spells and abilities.|nFor spells like \'Aspect of the Wild\' (BM Hunter), you need to sync cooldown with your party members.', -- Need translete
        ['GROUP_CLICK_CAST'] = 'Клик каст на груп-фреймах',
        ['GROUP_CLICK_CAST_TIP'] = 'Вы можете привязать клик каст заклинаний в книге заклинаний Blizzard.',
        ['GROUP_DEBUFF_SETTING_HEADER'] = 'Настройка групповых дебаффов',
        ['TYPE'] = 'Тип',
        ['TYPE_TIP'] = '|nВыберите тип, к которому принадлежит ID.',
        ['DUNGEON_TIP'] = '|nВыберите подземелья, к которым принадлежит ID.',
        ['RAID_TIP'] = '|nВыберите рейд, к которым принадлежит ID.',
        ['PRIORITY'] = 'Приоритеты',
        ['PRIORITY_TIP'] = '|nПриоритет заклинания, когда он виден.|n|nКогда несколько заклинаний, остается только то которое имеет высший приоритет.|n|nПриоритет по умолчанию равен 2, если оставить его пустым.|n|nМаксимальный приоритет равен 6, и значок будет мигать.',
        ['GROUP_DEBUFF_RESET_WARNING'] = 'Вы уверены, что хотите восстановить список по умолчанию?',
        ['PRIORITY_EDITBOX_TIP'] = '|nОграничение приоритета в 1-6.|n|nКогда вы закончите печатать, нажмите клавишу ENTER.',
        ['RAID_HORIZON'] = 'Гориз. расположение рейда',
        ['RAID_REVERSE'] = 'Реверс рейда',
        ['PARTY_HORIZON'] = 'Гориз. расположение группы',
        ['PARTY_REVERSE'] = 'Реверс группы',
        ['SPEC_POSITION'] = 'Сохранение позиции по спекам',
        ['PARTY_WIDTH'] = 'Ширина групфреймов',
        ['PARTY_HEIGHT'] = 'Высота групфреймов',
        ['PARTY_GAP'] = 'Расстояние групфреймов',
        ['RAID_WIDTH'] = 'Ширина рейдфреймов',
        ['RAID_HEIGHT'] = 'Высота рейдфреймов',
        ['RAID_GAP'] = 'Расстояние рейдфреймов',
        ['GROUP_FILTER'] = 'Максимальное отоброжение групп',
        ['CAT_PARTY'] = 'Группа',
        ['CAT_RAID'] = 'Рейд',
    },

    ['NAMEPLATE'] = {
        NAME = 'Неймплейты',
        ENABLE = 'Включить неймплейты',
        ENABLE_TIP = '|nОтключите этот модуль, если вы хотите использовать другой аддон неймплейтов.',

        NAME_ONLY = '"Режим" только имя',
        NAME_ONLY_TIP = '|nЕсли эта функция включена, то хпбары будут скрыты на дружественных нпц.|nИ показывает только ауры из белого списка хпбаров.',
        TARGET_INDICATOR = 'Индикатор цели',
        TARGET_INDICATOR_TIP = '|nБелое свечение под шильдиком текущей цели.',
        THREAT_INDICATOR = 'Индикатор угрозы',
        THREAT_INDICATOR_TIP = '|nЦветовое свечение поверх неймплейтов.|nЦвет будет представлять для вас статус угрозы.',
        CLASSIFY_INDICATOR = 'Классифицировать индикатор',
        CLASSIFY_INDICATOR_TIP = '|nИконка на правой стороне неймплейтов.',
        QUEST_INDICATOR = 'Индикатор квеста',
        QUEST_INDICATOR_TIP = '|nПоказать информацию о ходе выполнения задания под неймплейтом.',
        INTERRUPT_INDICATOR = 'Информация о прерывании',
        EXECUTE_INDICATOR = 'Индикатор выполнения',
        EXECUTE_INDICATOR_TIP = '|nЕсли процент здоровья единицы ниже установленного вами предела выполнения, цвет текста ее имени становится красным.',
        EXPLOSIVE_INDICATOR = 'Aффикс M+ "Взрывной"',
        EXPLOSIVE_INDICATOR_TIP = 'Увеличить нейплейты для сфер в M+.',
        SPITEFUL_INDICATOR = '"Зловредный" таргет',
        SPITEFUL_INDICATOR_TIP = 'Показать неймплейт M+ аффикса "Зловредный".',
        MAJOR_SPELLS_GLOW = 'Свечение особых закл.',
        MAJOR_SPELLS_GLOW_TIP = '|nЕсли враг произносит опасное заклинание, выделите его значок панели заклинаний.', -- ??
        SHOW_AURA = 'Показать ауры',
        SHOW_AURA_TIP = '',
        TOTEM_ICON = 'Иконки тотемов',
        TOTEM_ICON_TIP = '|nПоказать значки тотемов на неймплейтах.',
        AK_PROGRESS = 'Мифик+ Прогресс',
        AK_PROGRESS_TIP = '|nПоказать информацию о ходе выполнения M+.|nТРЕБУЕТСЯ AngryKeystones.',
        RAID_TARGET_INDICATOR = 'Индикатор цели рейда',
        RAID_TARGET_INDICATOR_SETTING = 'Индикатор цели рейда',
        EXPLOSIVE_INDICATOR_SETTING = 'Взрывная шкала',
        SCALE = 'Масштаб',
        EXECUT_RATIO_SETTING = 'Коэффициент исполнения',
        EXECUTE_RATIO = 'Коэффициент исполнения',
        SPELL_TARGET = 'Показывать в кого идет каст',
        SPELL_TARGET_TIP = '|nПоказывать имя игрока в которого идет каст.',

        BLACK_WHITE = 'Белый/черный лист',
        PLAYER_ONLY = 'Список и игрок',
        INCLUDE_CROWD_CONTROL = 'Список и игрок и CCs',

        BASIC_SETTING = 'Неймплейты',
        SIZE = 'Размер',
        CVAR = 'CVars',
        MIN_SCALE = 'None target scale',
        TARGET_SCALE = 'Target scale',
        MIN_ALPHA = 'None target alpha',
        OCCLUDED_ALPHA = 'Occluded alpha',
        VERTICAL_SPACING = 'Vertical spacing',
        HORIZONTAL_SPACING = 'Horizontal spacing',

        FRIENDLY_CLASS_COLOR = 'Окраш. дружелюбных игроков',
        HOSTILE_CLASS_COLOR = 'Окраш. враждебных игроков',
        TANK_MODE = 'Мод для Танка',
        TANK_MODE_TIP = '|nЕсли этот параметр включен, цвет неймплейтов будет показывать вам свой статус угрозы.|nДля пользовательских цветовых настроек состояние угрозы остается на индикаторе угрозы.',
        REVERT_THREAT = 'Вернуть цвет угрозы',
        REVERT_THREAT_TIP = '|nЕсли включен "Режим танка", замените их цвет состояния угрозы на классы без танко-спека.',
        SECURE_COLOR = 'Безопопасный',
        TRANS_COLOR = 'Переходный',
        INSECURE_COLOR = 'Небезопасный',
        OFF_TANK_COLOR = 'Офф-танк',
        COLORED_TARGET = 'Цвет цели',
        COLORED_TARGET_TIP = '|nЕсли эта функция включена, примените цвет к вашей цели, ее приоритет выше, чем пользовательский цвет и цвет угрозы.|nВы можете настроить цвет ниже.',
        TARGET_COLOR = 'Цвет цели',
        COLORED_CUSTOM_UNIT = 'Окрашивание особых нпц',
        COLORED_CUSTOM_UNIT_TIP = '|nЕсли эта функция включена, то здоровье некоторых нпц будет окрашиваться в пользовательский цвет.|nВы можете настроить цвет и список единиц измерения в соответствии с вашими требованиями.',
        CUSTOM_COLOR = 'Особый цвет',
        CUSTOM_UNIT_LIST = 'Лист особых нпц',
        CUSTOM_UNIT_LIST_TIP = '|nВведите имя или ID нпц.|nВы можете увидеть ID нпц в подсказке нажав кнопку ALT.|nИспользуйте кнопку "ПРОБЕЛ" между именами или ID.|nНажмите кнопку "ENTER" после того как закончили вводить имена или ID.',

        AURA_WHITE_LIST = 'Белый лист',
        AURA_BLACK_LIST = 'Черный лист',
        AURA_WHITE_LIST_TIP = 'Ввод SpellID.',
        AURA_BLACK_LIST_TIP = 'Ввод SpellID.',
        AURA_INCORRECT_ID = 'Некорректный SpellID.',
        AURA_EXISTING_ID = 'Этот SpellID присутствует.',

        CASTBAR_GLOW_SETTING = 'Свечение особых заклинаний',
    },

    ['CREDITS'] = {
        ['NAME'] = 'Благодарности',
        ['CREDITS'] = 'Благодарности',
        ['FEEDBACK'] = 'Обратная связь',
        ['PRIMARY'] = 'Haleth, siweia',
        ['SECONDARY'] = 'Alza, Tukz, Gethe, Elv|nHaste, Lightspark, Zork, Allez|nAlleyKat, Caellian, p3lim, Shantalya|ntekkub, Tuller, Wildbreath, aduth|nsilverwind, Nibelheim, humfras, aliluya555|nPaojy, Rubgrsch, EKE, fang2hou|nlilbitz95',
    },

    ['INSTALLATION'] = {
        ['INSTALL'] = 'Установить',
        ['SKIP'] = 'Пропустить',
        ['CONTINUE'] = 'Продолжить',
        ['FINISH'] = 'Готово',
        ['CANCEL'] = 'Отмена',
        ['HELLO'] = 'Привет',
        ['WELCOME'] = 'Добро пожаловать %AddonName%!|n|nВам нужно провести некоторые настройки, прежде чем начать его использовать.|n|nНажмите кнопку "установить", чтобы перейти к этапу настройки.',
        ['BASIC_HEADER'] = 'Базовые настройки',
        ['BASIC_DESCRIPTION'] = 'Эти шаги позволят настроить различные подходящие настройки для %AddonName%.|n|nПервый шаг будет регулировать некоторые |cffe9c55dCVars|r настройки.|n|nНажмите кнопку "Продолжить", чтобы применить настройки, или нажмите кнопку пропустить, чтобы пропустить эти настройки.',
        ['UISCALE_HEADER'] = 'Маштаб UI',
        ['UISCALE_DESCRIPTION'] = 'Этот шаг установит соответствующий масштаб для интерфейса.',
        ['CHAT_HEADER'] = 'Чат',
        ['CHAT_DESCRIPTION'] = 'Этот шаг позволит настроить параметры, связанные с чатом.',
        ['ACTIONBAR_HEADER'] = 'Панель скилов',
        ['ACTIONBAR_DESCRIPTION'] = 'Этот шаг позволит настроить параметры, связанные с панелью скилов.',
        ['ADDON_HEADER'] = 'Аддоны',
        ['ADDON_DESCRIPTION'] = 'Этот шаг позволит настроить некоторые аддоны в соответствии со стилем интерфейса и %AddonName%.',
        ['COMPLETE_HEADER'] = 'Готово!',
        ['COMPLETE_DESCRIPTION'] = 'Установка успешно завершена.|n|nПожалуйста, нажмите кнопку Готово ниже, чтобы перезагрузить интерфейс.|n|nИмейте в виду, что вы можете ввести |cffe9c55d/free|r, чтобы получить подробную справку, или непосредственно ввести |cffe9c55d/free config|r, чтобы открыть панель конфигурации и изменить различные настройки.',
    },
}

-- Slash commands
L['COMMANDS_LIST_HINT'] = 'Доступные Команды：'
L['COMMANDS_LIST'] = {
    '/free install - Открыть панель установки',
    '/free config - Открыть панель конфигурации',
    '/free unlock - Разблокировать интерфейс, для перемещения элементов UI',
    '/free reset - Сбросbnm все сохраненные параметры до значений по умолчанию.',
    '/rl - Перезагрузить интерфейс',
    '/ss - Сделать скнишот',
    '/rc - Проверить готовность',
    '/rp - Опрос ролей',
    '/lg - Покинуть группу',
    '/rs - Обновить подземелье',
    '/bind - Запуск режима быстрого назначения клавиш',
}
