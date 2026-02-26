-- Localization.lua
-- All user-facing strings for CursorBlinkMove
-- Locale is selected automatically via GetLocale()

local locale = GetLocale()
local L = {}

-- -------- English (default fallback: enUS/enGB) --------
L.ADDON_TITLE = "CursorBlinkMove"
L.ADDON_PREFIX = "CursorBlinkMove"
L.DEBUG_PREFIX = "CursorBlinkMove DEBUG"

-- Options UI
L.OPT_ENABLED_NAME = "Enabled"
L.OPT_ENABLED_DESC = "Enable CursorBlinkMove"

L.OPT_THRESHOLD_NAME = "Threshold (px/s)"
L.OPT_THRESHOLD_DESC = "Speed needed to trigger blinking"

L.OPT_DURATION_NAME = "Duration (s)"
L.OPT_DURATION_DESC = "How long it keeps blinking after fast movement stops"

L.OPT_RATE_NAME = "Rate / Period (s)"
L.OPT_RATE_DESC = "Blink period (lower = faster blinking)"

L.OPT_SIZE_NAME = "Size (px)"
L.OPT_SIZE_DESC = "Glow size in pixels"

L.OPT_COLOR_SECTION = "Color"
L.OPT_COLOR_LABEL = "Glow Color"
L.OPT_PICK_COLOR = "Pick Color"
L.OPT_USE_ALPHA = "Use Alpha"
L.OPT_TEST_BLINK = "Test Blink"

L.MSG_SETTINGS_UNAVAILABLE = "Settings UI not available in this client."
L.MSG_TESTBLINK_MISSING = "TestBlink function not found (update CursorBlinkMove.lua)."

-- Slash help (no leading spaces, no alignment padding)
L.CMD_HELP_HEADER = "Commands:"
L.CMD_HELP_COLOR = "/cbm color r g b [a] (0..1)"
L.CMD_HELP_THRESHOLD = "/cbm threshold <px/s>"
L.CMD_HELP_DURATION = "/cbm duration <sec> (afterglow)"
L.CMD_HELP_RATE = "/cbm rate <sec> (blink period, e.g. 0.2)"
L.CMD_HELP_SIZE = "/cbm size <px>"
L.CMD_HELP_ONOFF = "/cbm on | /cbm off"
L.CMD_HELP_TEST = "/cbm test [sec] (test blink)"
L.CMD_HELP_STATUS = "/cbm status"

-- Generic chat texts
L.CMD_UNKNOWN = "Unknown command. Use /cbm help"
L.CMD_DEBUG_IS = "Debug is"
L.CMD_ENABLED = "Enabled"
L.CMD_DISABLED = "Disabled"
L.CMD_TESTBLINK_FOR = "Test blink for"
L.CMD_COLOR_SET = "Color ="
L.CMD_THRESHOLD_SET = "Threshold ="
L.CMD_DURATION_SET = "Duration ="
L.CMD_RATE_SET = "Rate (period) ="
L.CMD_SIZE_SET = "Size ="

-- Status lines
L.STATUS_TITLE = "Status:"
L.STATUS_ENABLED = "Enabled:"
L.STATUS_DEBUG = "Debug:"
L.STATUS_THRESHOLD = "Threshold:"
L.STATUS_DURATION = "Duration:"
L.STATUS_RATE = "Rate (period):"
L.STATUS_SIZE = "Size:"
L.STATUS_COLOR = "Color:"

-- -------- German (deDE) --------
if locale == "deDE" then
  L.ADDON_TITLE = "CursorBlinkMove"
  L.ADDON_PREFIX = "CursorBlinkMove"
  L.DEBUG_PREFIX = "CursorBlinkMove DEBUG"

  L.OPT_ENABLED_NAME = "Aktiviert"
  L.OPT_ENABLED_DESC = "CursorBlinkMove aktivieren"

  L.OPT_THRESHOLD_NAME = "Schwelle (px/s)"
  L.OPT_THRESHOLD_DESC = "Bewegungsgeschwindigkeit, die das Blinken auslöst"

  L.OPT_DURATION_NAME = "Dauer (s)"
  L.OPT_DURATION_DESC = "Wie lange nach schnellem Bewegen weiter geblinkt wird"

  L.OPT_RATE_NAME = "Rate / Periode (s)"
  L.OPT_RATE_DESC = "Blinkperiode (kleiner = schnelleres Blinken)"

  L.OPT_SIZE_NAME = "Größe (px)"
  L.OPT_SIZE_DESC = "Glow-Größe in Pixeln"

  L.OPT_COLOR_SECTION = "Farbe"
  L.OPT_COLOR_LABEL = "Glow-Farbe"
  L.OPT_PICK_COLOR = "Farbe wählen"
  L.OPT_USE_ALPHA = "Alpha nutzen"
  L.OPT_TEST_BLINK = "Test-Blinken"

  L.MSG_SETTINGS_UNAVAILABLE = "Settings-UI ist in diesem Client nicht verfügbar."
  L.MSG_TESTBLINK_MISSING = "TestBlink-Funktion nicht gefunden (CursorBlinkMove.lua aktualisieren)."

  -- Slash help (clean, no padding)
  L.CMD_HELP_HEADER = "Befehle:"
  L.CMD_HELP_COLOR = "/cbm color r g b [a] (0..1)"
  L.CMD_HELP_THRESHOLD = "/cbm threshold <px/s>"
  L.CMD_HELP_DURATION = "/cbm duration <sec> (Nachlauf)"
  L.CMD_HELP_RATE = "/cbm rate <sec> (Blink-Periode, z.B. 0.2)"
  L.CMD_HELP_SIZE = "/cbm size <px>"
  L.CMD_HELP_ONOFF = "/cbm on | /cbm off"
  L.CMD_HELP_TEST = "/cbm test [sec] (Test Blink)"
  L.CMD_HELP_STATUS = "/cbm status"

  L.CMD_UNKNOWN = "Unbekannter Befehl. Nutze /cbm help"
  L.CMD_DEBUG_IS = "Debug ist"
  L.CMD_ENABLED = "Aktiviert"
  L.CMD_DISABLED = "Deaktiviert"
  L.CMD_TESTBLINK_FOR = "Test-Blinken für"
  L.CMD_COLOR_SET = "Farbe ="
  L.CMD_THRESHOLD_SET = "Schwelle ="
  L.CMD_DURATION_SET = "Dauer ="
  L.CMD_RATE_SET = "Rate (Periode) ="
  L.CMD_SIZE_SET = "Größe ="

  L.STATUS_TITLE = "Status:"
  L.STATUS_ENABLED = "Aktiviert:"
  L.STATUS_DEBUG = "Debug:"
  L.STATUS_THRESHOLD = "Schwelle:"
  L.STATUS_DURATION = "Dauer:"
  L.STATUS_RATE = "Rate (Periode):"
  L.STATUS_SIZE = "Größe:"
  L.STATUS_COLOR = "Farbe:"
end

-- -------- French (frFR) --------
if locale == "frFR" then
  L.OPT_ENABLED_NAME = "Activé"
  L.OPT_ENABLED_DESC = "Activer CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "Seuil (px/s)"
  L.OPT_THRESHOLD_DESC = "Vitesse requise pour déclencher le clignotement"
  L.OPT_DURATION_NAME = "Durée (s)"
  L.OPT_DURATION_DESC = "Durée du clignotement après l'arrêt du mouvement rapide"
  L.OPT_RATE_NAME = "Rythme / Période (s)"
  L.OPT_RATE_DESC = "Période de clignotement (plus bas = plus rapide)"
  L.OPT_SIZE_NAME = "Taille (px)"
  L.OPT_SIZE_DESC = "Taille du halo en pixels"
  L.OPT_COLOR_SECTION = "Couleur"
  L.OPT_COLOR_LABEL = "Couleur du halo"
  L.OPT_PICK_COLOR = "Choisir la couleur"
  L.OPT_USE_ALPHA = "Utiliser l'alpha"
  L.OPT_TEST_BLINK = "Test clignotement"
  L.MSG_SETTINGS_UNAVAILABLE = "Interface des paramètres indisponible sur ce client."
  L.MSG_TESTBLINK_MISSING = "Fonction TestBlink introuvable (mettez à jour CursorBlinkMove.lua)."
  L.CMD_UNKNOWN = "Commande inconnue. Utilisez /cbm help"
end

-- -------- Spanish (esES / esMX) --------
if locale == "esES" or locale == "esMX" then
  L.OPT_ENABLED_NAME = "Activado"
  L.OPT_ENABLED_DESC = "Activar CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "Umbral (px/s)"
  L.OPT_THRESHOLD_DESC = "Velocidad necesaria para activar el parpadeo"
  L.OPT_DURATION_NAME = "Duración (s)"
  L.OPT_DURATION_DESC = "Cuánto tiempo sigue parpadeando tras dejar de mover rápido"
  L.OPT_RATE_NAME = "Ritmo / Período (s)"
  L.OPT_RATE_DESC = "Período de parpadeo (más bajo = más rápido)"
  L.OPT_SIZE_NAME = "Tamaño (px)"
  L.OPT_SIZE_DESC = "Tamaño del brillo en píxeles"
  L.OPT_COLOR_SECTION = "Color"
  L.OPT_COLOR_LABEL = "Color del brillo"
  L.OPT_PICK_COLOR = "Elegir color"
  L.OPT_USE_ALPHA = "Usar alfa"
  L.OPT_TEST_BLINK = "Probar parpadeo"
  L.MSG_SETTINGS_UNAVAILABLE = "La interfaz de ajustes no está disponible en este cliente."
  L.MSG_TESTBLINK_MISSING = "Función TestBlink no encontrada (actualiza CursorBlinkMove.lua)."
  L.CMD_UNKNOWN = "Comando desconocido. Usa /cbm help"
end

-- -------- Italian (itIT) --------
if locale == "itIT" then
  L.OPT_ENABLED_NAME = "Abilitato"
  L.OPT_ENABLED_DESC = "Abilita CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "Soglia (px/s)"
  L.OPT_THRESHOLD_DESC = "Velocità necessaria per attivare il lampeggio"
  L.OPT_DURATION_NAME = "Durata (s)"
  L.OPT_DURATION_DESC = "Quanto lampeggia dopo aver smesso di muovere velocemente"
  L.OPT_RATE_NAME = "Ritmo / Periodo (s)"
  L.OPT_RATE_DESC = "Periodo lampeggio (più basso = più veloce)"
  L.OPT_SIZE_NAME = "Dimensione (px)"
  L.OPT_SIZE_DESC = "Dimensione del bagliore in pixel"
  L.OPT_COLOR_SECTION = "Colore"
  L.OPT_COLOR_LABEL = "Colore bagliore"
  L.OPT_PICK_COLOR = "Scegli colore"
  L.OPT_USE_ALPHA = "Usa alpha"
  L.OPT_TEST_BLINK = "Test lampeggio"
  L.MSG_SETTINGS_UNAVAILABLE = "Interfaccia impostazioni non disponibile in questo client."
  L.MSG_TESTBLINK_MISSING = "Funzione TestBlink non trovata (aggiorna CursorBlinkMove.lua)."
  L.CMD_UNKNOWN = "Comando sconosciuto. Usa /cbm help"
end

-- -------- Portuguese (ptBR) --------
if locale == "ptBR" then
  L.OPT_ENABLED_NAME = "Ativado"
  L.OPT_ENABLED_DESC = "Ativar CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "Limite (px/s)"
  L.OPT_THRESHOLD_DESC = "Velocidade necessária para ativar o piscar"
  L.OPT_DURATION_NAME = "Duração (s)"
  L.OPT_DURATION_DESC = "Por quanto tempo continua piscando após parar de mover rápido"
  L.OPT_RATE_NAME = "Taxa / Período (s)"
  L.OPT_RATE_DESC = "Período do piscar (menor = mais rápido)"
  L.OPT_SIZE_NAME = "Tamanho (px)"
  L.OPT_SIZE_DESC = "Tamanho do brilho em pixels"
  L.OPT_COLOR_SECTION = "Cor"
  L.OPT_COLOR_LABEL = "Cor do brilho"
  L.OPT_PICK_COLOR = "Escolher cor"
  L.OPT_USE_ALPHA = "Usar alpha"
  L.OPT_TEST_BLINK = "Testar piscar"
  L.MSG_SETTINGS_UNAVAILABLE = "Interface de configurações indisponível neste cliente."
  L.MSG_TESTBLINK_MISSING = "Função TestBlink não encontrada (atualize CursorBlinkMove.lua)."
  L.CMD_UNKNOWN = "Comando desconhecido. Use /cbm help"
end

-- -------- Russian (ruRU) --------
if locale == "ruRU" then
  L.OPT_ENABLED_NAME = "Включено"
  L.OPT_ENABLED_DESC = "Включить CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "Порог (px/s)"
  L.OPT_THRESHOLD_DESC = "Скорость, необходимая для мигания"
  L.OPT_DURATION_NAME = "Длительность (с)"
  L.OPT_DURATION_DESC = "Сколько мигает после прекращения быстрого движения"
  L.OPT_RATE_NAME = "Частота / Период (с)"
  L.OPT_RATE_DESC = "Период мигания (меньше = быстрее)"
  L.OPT_SIZE_NAME = "Размер (px)"
  L.OPT_SIZE_DESC = "Размер свечения в пикселях"
  L.OPT_COLOR_SECTION = "Цвет"
  L.OPT_COLOR_LABEL = "Цвет свечения"
  L.OPT_PICK_COLOR = "Выбрать цвет"
  L.OPT_USE_ALPHA = "Исп. альфа"
  L.OPT_TEST_BLINK = "Тест мигания"
  L.MSG_SETTINGS_UNAVAILABLE = "Интерфейс настроек недоступен в этом клиенте."
  L.MSG_TESTBLINK_MISSING = "Функция TestBlink не найдена (обновите CursorBlinkMove.lua)."
  L.CMD_UNKNOWN = "Неизвестная команда. Используйте /cbm help"
end

-- -------- Korean (koKR) --------
if locale == "koKR" then
  L.OPT_ENABLED_NAME = "활성화"
  L.OPT_ENABLED_DESC = "CursorBlinkMove 사용"
  L.OPT_THRESHOLD_NAME = "임계값 (px/s)"
  L.OPT_THRESHOLD_DESC = "깜빡임을 시작하는 속도"
  L.OPT_DURATION_NAME = "지속시간 (초)"
  L.OPT_DURATION_DESC = "빠른 이동이 끝난 뒤 계속 깜빡이는 시간"
  L.OPT_RATE_NAME = "속도/주기 (초)"
  L.OPT_RATE_DESC = "깜빡임 주기 (작을수록 더 빠름)"
  L.OPT_SIZE_NAME = "크기 (px)"
  L.OPT_SIZE_DESC = "글로우 크기(픽셀)"
  L.OPT_COLOR_SECTION = "색상"
  L.OPT_COLOR_LABEL = "글로우 색상"
  L.OPT_PICK_COLOR = "색상 선택"
  L.OPT_USE_ALPHA = "알파 사용"
  L.OPT_TEST_BLINK = "테스트 깜빡임"
  L.MSG_SETTINGS_UNAVAILABLE = "이 클라이언트에서는 설정 UI를 사용할 수 없습니다."
  L.MSG_TESTBLINK_MISSING = "TestBlink 함수를 찾을 수 없습니다 (CursorBlinkMove.lua 업데이트 필요)."
  L.CMD_UNKNOWN = "알 수 없는 명령어입니다. /cbm help"
end

-- -------- Simplified Chinese (zhCN) --------
if locale == "zhCN" then
  L.OPT_ENABLED_NAME = "启用"
  L.OPT_ENABLED_DESC = "启用 CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "阈值 (px/s)"
  L.OPT_THRESHOLD_DESC = "触发闪烁所需的速度"
  L.OPT_DURATION_NAME = "持续时间 (秒)"
  L.OPT_DURATION_DESC = "停止快速移动后继续闪烁的时间"
  L.OPT_RATE_NAME = "频率/周期 (秒)"
  L.OPT_RATE_DESC = "闪烁周期（越小越快）"
  L.OPT_SIZE_NAME = "大小 (px)"
  L.OPT_SIZE_DESC = "光效大小（像素）"
  L.OPT_COLOR_SECTION = "颜色"
  L.OPT_COLOR_LABEL = "光效颜色"
  L.OPT_PICK_COLOR = "选择颜色"
  L.OPT_USE_ALPHA = "使用透明度"
  L.OPT_TEST_BLINK = "测试闪烁"
  L.MSG_SETTINGS_UNAVAILABLE = "此客户端不支持设置界面。"
  L.MSG_TESTBLINK_MISSING = "未找到 TestBlink 函数（请更新 CursorBlinkMove.lua）。"
  L.CMD_UNKNOWN = "未知命令。使用 /cbm help"
end

-- -------- Traditional Chinese (zhTW) --------
if locale == "zhTW" then
  L.OPT_ENABLED_NAME = "啟用"
  L.OPT_ENABLED_DESC = "啟用 CursorBlinkMove"
  L.OPT_THRESHOLD_NAME = "閾值 (px/s)"
  L.OPT_THRESHOLD_DESC = "觸發閃爍所需速度"
  L.OPT_DURATION_NAME = "持續時間 (秒)"
  L.OPT_DURATION_DESC = "停止快速移動後繼續閃爍的時間"
  L.OPT_RATE_NAME = "頻率/週期 (秒)"
  L.OPT_RATE_DESC = "閃爍週期（越小越快）"
  L.OPT_SIZE_NAME = "大小 (px)"
  L.OPT_SIZE_DESC = "光效大小（像素）"
  L.OPT_COLOR_SECTION = "顏色"
  L.OPT_COLOR_LABEL = "光效顏色"
  L.OPT_PICK_COLOR = "選擇顏色"
  L.OPT_USE_ALPHA = "使用透明度"
  L.OPT_TEST_BLINK = "測試閃爍"
  L.MSG_SETTINGS_UNAVAILABLE = "此用戶端不支援設定介面。"
  L.MSG_TESTBLINK_MISSING = "找不到 TestBlink 函式（請更新 CursorBlinkMove.lua）。"
  L.CMD_UNKNOWN = "未知指令。使用 /cbm help"
end

-- Export
_G.CursorBlinkMove_L = L