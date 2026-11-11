local DEFAULT_LANG = "ru" -- "ru" РёР»Рё "en"
local BLOCK_CLICK_WHEN_MENU_OPEN = true -- Р°Рис'Рѕрер "Ререр" Рер " Рер "Рер ° РµС', Рирѕрер° Рјрѕсћ Рѕс'РѕС " С'Рѕ

------------------------------------------------------------------ РЎР * Р Р'РРЎР«
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local alive = true

local function getGuiParent()
 if typeof(gethui) == "function" then
 local ok, r = pcall(gethui)
 if ok and r then return r end
 end
 return player:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()
local old = guiParent:FindFirstChild("SIMA_Menu")
if old then old:Destroy() end

local connections = {}
local function connect(signal, fn)
 local c = signal:Connect(fn)
 table.insert(connections, c)
 return c
end

------------------------------------------------------------------ Р"Рррррѣр" РР—Рѣр¦РРІ
local LANG = DEFAULT_LANG
local TXT = {
 ru = {
    tab_main = "Главная", tab_shaders = "Шейдеры", tab_sky = "Небо",
    tab_player = "Игрок", tab_click = "Автокликер", tab_settings = "Настройки",
    pulse = "Счётчик", fps = "FPS", ping = "Пинг", ms = "мс",
    hint_main = "Это меню SIMA. Чтобы свернуть его в кружок, нажми на «–» справа сверху или RightShift.",
    sec_pretty = "Красивая картинка", pretty = "Красивые шейдеры (закат)",
    reflect = "Поверхности отражают свет",
    vignette = "Затемнение по краям экрана", cinema = "Чёрные полосы как в кино",
    sec_atmo = "Атмосфера", azure = "Синяя атмосфера", frost = "Белая атмосфера", void = "Чёрная атмосфера",
    sec_part = "Частицы", snow = "Включить снег", bluep = "Красивые синие частицы",
    violetp = "Фиолетовые частицы",
    sec_light = "Свет", fullbright = "Максимальная яркость", bloom = "Свечение",
    sunrays = "Лучи солнца",
    sec_fog = "Туман", fog = "Плотность тумана",
    sec_clouds = "Облака", cloud_density = "Плотность облаков", cloud_color = "Цвет облаков",
    sec_space = "Звёзды и время", stars = "Сделать звёзды",
    stars_hint = "Звёзды видно только ночью, так что подвинь время суток.",
    time = "Время суток",
    sec_perf = "Производительность", optimize = "Оптимизация (больше FPS)",
    sec_cam = "Поле зрения", fov = "Поле зрения (FOV)", fovreset = "Сбросить",
    sec_avatar = "Аватар (видно только тебе)", headless = "Headless (без головы)",
    sec_hud = "Экран", crosshair = "Точка в центре экрана",
    sec_aura = "Аура", aura = "Цвет ауры", aura_none = "Сейчас аура выключена",
    aura_blue = "Синяя аура", aura_violet = "Фиолетовая аура", aura_white = "Белая аура",
    aura_black = "Чёрная аура", aura_yellow = "Жёлтая аура", aura_green = "Зелёная аура",
    aura_off = "Выключить ауру",
    sec_move = "Разное", pass_players = "Проходить сквозь игроков",
    anti_afk = "Анти-AFK (что б не кикало за неактивность)",
    clicker = "Автокликер", bind = "Клавиша включения", bind_none = "не задана",
    bind_wait = "нажми клавишу...",
    bind_hint = "Сначала нажми на кнопку выше, потом на нужную клавишу. Esc - отмена, Backspace - убрать клавишу.",
    cps = "Кликов в секунду", cps_ms = "1 клик в миллисекунду",
    st_off = "Статус: выключен", st_on = "Статус: кликает",
    st_pause = "Статус: на паузе, пока открыто меню",
    sec_lang = "Язык", reset = "Сбросить всё", unload = "Выгрузить SIMA", version = "SIMA v1.2",
 },
 en = {
 tab_main = "Main", tab_shaders = "Shaders", tab_sky = "Sky",
 tab_player = "Player", tab_click = "Autoclicker", tab_settings = "Settings",
 pulse = "Stats", fps = "FPS", ping = "Ping", ms = "ms",
 hint_main = "This is the SIMA menu. To minimize it, press the - button at the top right or RightShift.",
 sec_pretty = "Pretty visuals", pretty = "Beautiful shaders (sunset)", reflect = "Surfaces reflect light",
 vignette = "Dark screen edges", cinema = "Cinema black bars",
 sec_atmo = "Atmosphere", azure = "Blue atmosphere", frost = "White atmosphere", void = "Black atmosphere",
 sec_part = "Particles", snow = "Snowfall", bluep = "Pretty blue particles", violetp = "Violet particles",
 sec_light = "Light", fullbright = "Max brightness", bloom = "Bloom", sunrays = "Sun rays",
 sec_fog = "Fog", fog = "Fog density",
 sec_clouds = "Clouds", cloud_density = "Cloud density", cloud_color = "Cloud color",
 sec_space = "Stars and time", stars = "Make stars", stars_hint = "Stars only show at night, so move the time of day.", time = "Time of day",
 sec_perf = "Performance", optimize = "Optimization (more FPS)",
 sec_cam = "Field of view", fov = "Field of view (FOV)", fovreset = "Reset",
 sec_avatar = "Avatar (only you see it)", headless = "Headless (no head)",
 sec_hud = "Screen", crosshair = "Dot in screen center",
 sec_aura = "Aura", aura = "Aura color", aura_none = "Aura is off right now",
 aura_blue = "Blue aura", aura_violet = "Violet aura", aura_white = "White aura",
 aura_black = "Black aura", aura_yellow = "Yellow aura", aura_green = "Green aura",
 aura_off = "Turn aura off",
 sec_move = "Misc", pass_players = "Walk through players", anti_afk = "Anti-AFK (no idle kick)",
 clicker = "Autoclicker", bind = "Toggle key", bind_none = "not set", bind_wait = "press a key...",
 bind_hint = "Press the button above first, then the key you want. Esc cancels, Backspace clears the key.",
 cps = "Clicks per second", cps_ms = "1 click per ms",
 st_off = "Status: off", st_on = "Status: clicking", st_pause = "Status: paused while the menu is open",
 sec_lang = "Language", reset = "Reset all", unload = "Unload SIMA", version = "SIMA v1.2",
 },
}
local function tr(key) return (TXT[LANG] and TXT[LANG][key]) or key end

local bound = {}
local function reg(obj, fn) bound[obj] = fn; obj.Text = fn(); return obj end
local function refreshOne(obj) if bound[obj] then obj.Text = bound[obj]() end end
local function refreshAll() for o, fn in pairs(bound) do if o.Parent then o.Text = fn() end end end

------------------------------------------------------------------ Рур•Рур РГР•р"ррр•р р" UI
local C = {
 bg = Color3.fromRGB(16, 16, 26), panel = Color3.fromRGB(28, 28, 44),
 off = Color3.fromRGB(60, 60, 84), accent = Color3.fromRGB(96, 140, 255),
 text = Color3.fromRGB(238, 238, 248), sub = Color3.fromRGB(150, 152, 178),
 good = Color3.fromRGB(90, 220, 130), warn = Color3.fromRGB(245, 200, 80), bad = Color3.fromRGB(240, 90, 90),
}

local function new(class, props, parent)
 local o = Instance.new(class)
 for k, v in pairs(props) do o[k] = v end
 o.Parent = parent
 return o
end
local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local ord = 0
local function nextOrd() ord += 1; return ord end

local gui = new("ScreenGui", {
 Name = "SIMA_Menu", ResetOnSpawn = false, IgnoreGuiInset = true,
 ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
}, guiParent)

local MENU_W, MENU_H, CIRCLE = 380, 440, 46
local function viewport()
 local v = gui.AbsoluteSize
 if v.X <= 0 or v.Y <= 0 then v = (camera and camera.ViewportSize) or Vector2.new(800, 600) end
 return v
end
local VP0 = viewport()

local main = new("Frame", {
 Name = "Main", Size = UDim2.fromOffset(MENU_W, MENU_H),
 Position = UDim2.fromOffset(math.floor((VP0.X - MENU_W) / 2), math.floor((VP0.Y - MENU_H) / 2)),
 BackgroundColor3 = C.bg, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 10,
}, gui)
corner(main, 12)
new("UIStroke", { Color = C.accent, Transparency = 0.5, Thickness = 1.5 }, main)

local titleBar = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.panel, BorderSizePixel = 0 }, main)
new("TextLabel", {
 Size = UDim2.new(0, 120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
 Text = "SIMA", Font = Enum.Font.SourceSansBold, TextSize = 24, TextColor3 = C.accent,
 TextXAlignment = Enum.TextXAlignment.Left,
}, titleBar)
local minBtn = new("TextButton", {
 Size = UDim2.fromOffset(30, 24), Position = UDim2.new(1, -38, 0, 6), BackgroundColor3 = C.off,
 Text = "X", Font = Enum.Font.SourceSansBold, TextSize = 22, TextColor3 = C.text, AutoButtonColor = true,
}, titleBar)
corner(minBtn, 6)

-- РєСЂСѓРіР»Р°СЏ РєРЅРѕРїРєР° РґР»СЏ СЃРІС'СЂРЅСѓС'РѕРіРѕ РјРµРЅСЋ
local circle = new("TextButton", {
 Name = "Circle", Size = UDim2.fromOffset(CIRCLE, CIRCLE), BackgroundColor3 = C.accent,
 Text = "S", Font = Enum.Font.SourceSansBold, TextSize = 26, TextColor3 = C.text,
 Visible = false, AutoButtonColor = true, ZIndex = 10,
}, gui)
corner(circle, CIRCLE)
new("UIStroke", { Color = C.text, Transparency = 0.6, Thickness = 1.5 }, circle)

local function makeDraggable(handle, target)
 local dragging, startIn, startPos, moved = false, nil, nil, false
 connect(handle.InputBegan, function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
 dragging, moved, startIn, startPos = true, false, i.Position, target.Position
 end
 end)
 connect(UserInputService.InputChanged, function(i)
 if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
 local d = i.Position - startIn
 if d.Magnitude > 4 then moved = true end
 target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end)
 connect(UserInputService.InputEnded, function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
 end)
 return function() return moved end
end

makeDraggable(titleBar, main)
local circleMoved = makeDraggable(circle, circle)

local function minimize()
 local pos = main.Position
 circle.Position = UDim2.fromOffset(pos.X.Offset + MENU_W - CIRCLE, pos.Y.Offset)
 main.Visible = false
 circle.Visible = true
end
local function restore()
 local pos = circle.Position
 local vp = viewport()
 local x = math.clamp(pos.X.Offset + CIRCLE - MENU_W, 0, math.max(0, vp.X - MENU_W))
 local y = math.clamp(pos.Y.Offset, 0, math.max(0, vp.Y - MENU_H))
 main.Position = UDim2.fromOffset(x, y)
 circle.Visible = false
 main.Visible = true
end
connect(minBtn.MouseButton1Click, minimize)
connect(circle.MouseButton1Click, function() if not circleMoved() then restore() end end)

------------------------------------------------------------------ Р'Ррр"Рѣр" Ррр
local pages, tabButtons = {}, {}
local tabBar = new("ScrollingFrame", {
 Size = UDim2.new(1, -16, 0, 28), Position = UDim2.new(0, 8, 0, 42), BackgroundTransparency = 1,
 BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(),
 AutomaticCanvasSize = Enum.AutomaticSize.X, ScrollingDirection = Enum.ScrollingDirection.X,
}, main)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, tabBar)

local function showPage(id)
 for k, p in pairs(pages) do
 p.Visible = (k == id)
 tabButtons[k].BackgroundColor3 = (k == id) and C.accent or C.panel
 tabButtons[k].TextColor3 = (k == id) and C.text or C.sub
 end
end

local function addTab(id, key)
 local page = new("ScrollingFrame", {
 Size = UDim2.new(1, -16, 1, -80), Position = UDim2.new(0, 8, 0, 74), BackgroundTransparency = 1,
 BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(),
 AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false,
 }, main)
 new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, page)
 local b = new("TextButton", {
 Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.panel,
 Font = Enum.Font.SourceSansSemibold, TextSize = 15, TextColor3 = C.sub, Text = "", AutoButtonColor = false,
 }, tabBar)
 corner(b, 6)
 new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, b)
 reg(b, function() return tr(key) end)
 connect(b.MouseButton1Click, function() showPage(id) end)
 pages[id], tabButtons[id] = page, b
 return page
end

------------------------------------------------------------------ Р'РРР " Р-р•РўР«
local allToggles = {}

local function section(page, key)
 local l = new("TextLabel", {
 Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.SourceSansBold, TextSize = 15,
 TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrd(),
 }, page)
 reg(l, function() return tr(key) end)
 return l
end

local function note(page, fn, color)
 local l = new("TextLabel", {
 Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Font = Enum.Font.SourceSans, TextSize = 15,
 TextColor3 = color or C.sub, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
 TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = nextOrd(),
 }, page)
 reg(l, fn)
 return l
end

local function buttons(page, defs)
 local row = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = nextOrd() }, page)
 new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }, row)
 local made = {}
 for _, d in ipairs(defs) do
 local b = new("TextButton", {
 Size = UDim2.new(1 / #defs, -6 * (#defs - 1) / #defs, 1, 0), BackgroundColor3 = C.panel,
 Font = Enum.Font.SourceSansSemibold, TextSize = 16, TextColor3 = C.text, AutoButtonColor = true,
 }, row)
 corner(b, 8)
 reg(b, d.text)
 connect(b.MouseButton1Click, d.cb)
 table.insert(made, b)
 end
 return made
end

local function toggle(page, key, onChange)
 local row = new("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = nextOrd() }, page)
 corner(row, 8)
 local lbl = new("TextLabel", {
 Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1,
 Font = Enum.Font.SourceSansSemibold, TextSize = 16, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
 TextTruncate = Enum.TextTruncate.AtEnd,
 }, row)
 reg(lbl, function() return tr(key) end)
 local sw = new("TextButton", {
 Size = UDim2.fromOffset(44, 22), Position = UDim2.new(1, -54, 0.5, -11), BackgroundColor3 = C.off,
 Text = "", AutoButtonColor = false,
 }, row)
 corner(sw, 11)
 local knob = new("Frame", { Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = C.text }, sw)
 corner(knob, 9)
 local state = false
 local obj = {}
 function obj.set(v, silent)
 state = v
 TweenService:Create(sw, TweenInfo.new(0.15), { BackgroundColor3 = v and C.accent or C.off }):Play()
 TweenService:Create(knob, TweenInfo.new(0.15), { Position = v and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) }):Play()
 if not silent then onChange(v) end
 end
 function obj.get() return state end
 connect(sw.MouseButton1Click, function() obj.set(not state) end)
 table.insert(allToggles, obj)
 return obj
end

local function slider(page, key, min, max, init, onChange, suffix)
 local row = new("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = nextOrd() }, page)
 corner(row, 8)
 local lbl = new("TextLabel", {
 Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 4), BackgroundTransparency = 1,
 Font = Enum.Font.SourceSansSemibold, TextSize = 16, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
 }, row)
 local track = new("Frame", { Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 34), BackgroundColor3 = C.off, BorderSizePixel = 0 }, row)
 corner(track, 3)
 local fill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = C.accent, BorderSizePixel = 0 }, track)
 corner(fill, 3)
 local hit = new("TextButton", { Size = UDim2.new(1, 0, 0, 26), Position = UDim2.new(0, 0, 0.5, -13), BackgroundTransparency = 1, Text = "" }, track)
 local value = init
 reg(lbl, function() return tr(key) .. ": " .. math.floor(value + 0.5) .. (suffix or "") end)
 local obj = {}
 function obj.set(v, silent)
 value = math.clamp(v, min, max)
 fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
 refreshOne(lbl)
 if not silent then onChange(value) end
 end
 local dragging = false
 local function fromX(x)
 local w = math.max(track.AbsoluteSize.X, 1)
 obj.set(min + (max - min) * math.clamp((x - track.AbsolutePosition.X) / w, 0, 1))
 end
 connect(hit.InputBegan, function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
 dragging = true; fromX(i.Position.X)
 end
 end)
 connect(UserInputService.InputChanged, function(i)
 if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromX(i.Position.X) end
 end)
 connect(UserInputService.InputEnded, function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
 end)
 obj.set(init, true)
 return obj
end

local function swatches(page, key, colors, cb)
 local row = new("Frame", { Size = UDim2.new(1, 0, 0, 64), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = nextOrd() }, page)
 corner(row, 8)
 local lbl = new("TextLabel", {
 Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 4), BackgroundTransparency = 1,
 Font = Enum.Font.SourceSansSemibold, TextSize = 16, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
 }, row)
 reg(lbl, function() return tr(key) end)
 local holder = new("Frame", { Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1 }, row)
 new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8) }, holder)
 local strokes = {}
 for _, col in ipairs(colors) do
 local b = new("TextButton", { Size = UDim2.fromOffset(28, 28), BackgroundColor3 = col, Text = "", AutoButtonColor = true }, holder)
 corner(b, 14)
 local st = new("UIStroke", { Color = C.text, Thickness = 2, Enabled = false }, b)
 table.insert(strokes, st)
 connect(b.MouseButton1Click, function()
 for _, s in ipairs(strokes) do s.Enabled = false end
 st.Enabled = true
 cb(col)
 end)
 end
 return function() for _, s in ipairs(strokes) do s.Enabled = false end end
end

------------------------------------------------------------------ РЎРћРҐР РђРќРЃРќРќР«Р• РРЎРҐРћР”РќР«Р• Р—РќРђР§Р•РќРРЇ
local orig = {
 Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness,
 FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor,
 ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
}
local origFOV = camera and camera.FieldOfView or 70

------------------------------------------------------------------ Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р-Р
local PRESETS = {
 azure = { Color = Color3.fromRGB(110, 165, 255), Decay = Color3.fromRGB(50, 90, 200), Density = 0.38, Haze = 1.8, Glare = 0.35, Offset = 0.2,
 Ambient = Color3.fromRGB(60, 90, 170), Fog = Color3.fromRGB(120, 170, 255) },
 frost = { Color = Color3.fromRGB(245, 248, 255), Decay = Color3.fromRGB(225, 230, 240), Density = 0.45, Haze = 2.2, Glare = 0, Offset = 0.1,
 Ambient = Color3.fromRGB(190, 190, 200), Fog = Color3.fromRGB(240, 244, 255) },
 void = { Color = Color3.fromRGB(8, 8, 14), Decay = Color3.fromRGB(0, 0, 0), Density = 0.5, Haze = 2.5, Glare = 0, Offset = 0,
 Ambient = Color3.fromRGB(15, 15, 25), Fog = Color3.fromRGB(5, 5, 10), Brightness = 0.6 },
}
PRESETS.sunset = { Color = Color3.fromRGB(255, 180, 120), Decay = Color3.fromRGB(255, 110, 80), Density = 0.32, Haze = 1.9, Glare = 0.7, Offset = 0.2,
 Ambient = Color3.fromRGB(120, 90, 110), Fog = Color3.fromRGB(255, 170, 120), Brightness = 3 }
local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
local atmoOrig = atmo and { Color = atmo.Color, Decay = atmo.Decay, Density = atmo.Density, Haze = atmo.Haze, Glare = atmo.Glare, Offset = atmo.Offset }
local atmoCreated = false

local opt = { on = false }
local lightState = { preset = nil, fullbright = false }
-- РµРґРеРЅР°СЏ С'РѕС‡Рер° СЃР±РѕСЂРєРе РѕСЃРІРµС‰РµРЅРеСЏ: РѕСЂРеРіРеРЅР°Р" -> РїСЂРµСЃРµС' -> fullbright (+ С'РµРЅРе РѕС' С'СѓСЂР±Рѕ-СЂРµР¶РеРјР°)
local function recomputeLighting()
 local p = lightState.preset and PRESETS[lightState.preset]
 Lighting.Ambient = p and p.Ambient or orig.Ambient
 Lighting.OutdoorAmbient = p and p.Ambient or orig.OutdoorAmbient
 Lighting.FogColor = p and p.Fog or orig.FogColor
 Lighting.Brightness = (p and p.Brightness) or orig.Brightness
 if lightState.fullbright then
 Lighting.Brightness = 2
 Lighting.Ambient = Color3.fromRGB(175, 175, 175)
 Lighting.OutdoorAmbient = Color3.fromRGB(175, 175, 175)
 end
 Lighting.GlobalShadows = (lightState.fullbright or opt.on) and false or orig.GlobalShadows
end

local function applyPreset(name)
 local p = PRESETS[name]
 if not atmo or not atmo.Parent then
 atmo = Instance.new("Atmosphere"); atmo.Parent = Lighting; atmoCreated = true
 end
 atmo.Color, atmo.Decay, atmo.Density = p.Color, p.Decay, p.Density
 atmo.Haze, atmo.Glare, atmo.Offset = p.Haze, p.Glare, p.Offset
 lightState.preset = name
 recomputeLighting()
end
local function restoreAtmo()
 if atmo and atmo.Parent then
 if atmoOrig then
 for k, v in pairs(atmoOrig) do atmo[k] = v end
 elseif atmoCreated then
 atmo:Destroy(); atmo = nil; atmoCreated = false
 end
 end
 lightState.preset = nil
 recomputeLighting()
end

------------------------------------------------------------------ Р§Рѣрўрўрр¦Р«
local effects = {}
local function makeEffect(id, size, offset, build)
 local part = Instance.new("Part")
 part.Name = "SIMA_FX_" .. id
 part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery = true, false, false, false
 part.CastShadow, part.Transparency, part.Size, part.Locked = false, 1, size, true
 local em = Instance.new("ParticleEmitter")
 em.Enabled = false
 em.Shape = Enum.ParticleEmitterShape.Box
 em.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
 build(em)
 em.Parent = part
 part.Parent = Workspace
 effects[id] = { part = part, em = em, offset = offset, on = false }
end
local function NS(...) local k = {} for _, v in ipairs({ ... }) do table.insert(k, NumberSequenceKeypoint.new(v[1], v[2])) end return NumberSequence.new(k) end

local SPARK = "rbxasset://textures/particles/sparkles_main.dds"
local SOFT = "rbxasset://textures/particles/smoke_main.dds"

makeEffect("snow", Vector3.new(90, 2, 90), Vector3.new(0, 35, 0), function(e)
 e.Texture = SOFT; e.Color = ColorSequence.new(Color3.new(1, 1, 1))
 e.Size = NS({ 0, 0.28 }, { 1, 0.28 }); e.Transparency = NS({ 0, 0.1 }, { 0.9, 0.2 }, { 1, 1 })
 e.Lifetime = NumberRange.new(5, 7); e.Speed = NumberRange.new(6, 10); e.Rate = 260
 e.EmissionDirection = Enum.NormalId.Bottom; e.SpreadAngle = Vector2.new(12, 12)
 e.Acceleration = Vector3.new(2, 0, 1); e.LightEmission = 0.3; e.LightInfluence = 0.3
 e.Rotation = NumberRange.new(0, 360); e.RotSpeed = NumberRange.new(-30, 30)
end)
local function glow(c1, c2)
 return function(e)
 e.Texture = SPARK; e.Color = ColorSequence.new(c1, c2)
 e.Size = NS({ 0, 0 }, { 0.3, 0.6 }, { 1, 0 }); e.Transparency = NS({ 0, 1 }, { 0.2, 0.15 }, { 0.8, 0.3 }, { 1, 1 })
 e.Lifetime = NumberRange.new(4, 7); e.Speed = NumberRange.new(0.5, 2); e.Rate = 45
 e.EmissionDirection = Enum.NormalId.Top; e.SpreadAngle = Vector2.new(180, 180)
 e.Acceleration = Vector3.new(0, 0.6, 0); e.Drag = 1; e.LightEmission = 1; e.LightInfluence = 0
 e.Rotation = NumberRange.new(0, 360); e.RotSpeed = NumberRange.new(-40, 40)
 end
end
makeEffect("blue", Vector3.new(70, 30, 70), Vector3.new(0, 5, 0), glow(Color3.fromRGB(70, 140, 255), Color3.fromRGB(120, 230, 255)))
makeEffect("violet", Vector3.new(70, 30, 70), Vector3.new(0, 5, 0), glow(Color3.fromRGB(150, 70, 255), Color3.fromRGB(235, 150, 255)))

local function setEffect(id, on)
 local fx = effects[id]
 fx.on = on; fx.em.Enabled = on
end

------------------------------------------------------------------ Рјрјрњрђ / Рўр'Р"Рўрђрђ / Р-ррр-р "Р"
local function setFog(v)
 Lighting.FogStart = 0
 Lighting.FogEnd = math.max(60, 100000 * (1 - v / 100) ^ 3)
end
local function restoreFog()
 Lighting.FogEnd, Lighting.FogStart = orig.FogEnd, orig.FogStart
end

local terrain = Workspace.Terrain
local clouds = terrain:FindFirstChildOfClass("Clouds")
local cloudsOrig = clouds and { Cover = clouds.Cover, Density = clouds.Density, Color = clouds.Color }
local cloudsCreated = false
local function ensureClouds()
 if not clouds or not clouds.Parent then
 clouds = Instance.new("Clouds"); clouds.Parent = terrain; cloudsCreated = true
 end
 return clouds
end
local function restoreClouds()
 if cloudsCreated and clouds then
 clouds:Destroy(); clouds = nil; cloudsCreated = false
 elseif clouds and cloudsOrig then
 for k, v in pairs(cloudsOrig) do clouds[k] = v end
 end
end

local sky = Lighting:FindFirstChildOfClass("Sky")
local skyOrigStars = sky and sky.StarCount
local skyCreated = false
local function setStars(on)
 if on then
 if not sky or not sky.Parent then
 sky = Instance.new("Sky"); sky.Parent = Lighting; skyCreated = true
 end
 sky.StarCount = 5000; sky.CelestialBodiesShown = true
 elseif skyCreated and sky then
 sky:Destroy(); sky = nil; skyCreated = false
 elseif sky then
 sky.StarCount = skyOrigStars or 3000
 end
end

------------------------------------------------------------------ Р¤р¤р * Рўрўр " РЎР'Р * Рўрў
local function postToggle(class, props)
 local inst
 return function(on)
 if on then
 inst = Instance.new(class)
 for k, v in pairs(props) do inst[k] = v end
 inst.Name = "SIMA_" .. class; inst.Parent = Lighting
 elseif inst then
 inst:Destroy(); inst = nil
 end
 end
end
local bloomFn = postToggle("BloomEffect", { Intensity = 1, Size = 24, Threshold = 0.8 })
local raysFn = postToggle("SunRaysEffect", { Intensity = 0.25, Spread = 1 })

local function setFullbright(on)
 lightState.fullbright = on
 recomputeLighting()
end

------------------------------------------------------------------ РљР РђРЎРР’Р«Р• РЁР•Р™Р”Р•Р Р«
local timeSlider -- Сррѕр * РГР°С'С'ССС Р рѕр° Рирер "Р°Ргрерµ в" Рµрµр±РѕВ»
local pretty = { on = false, fx = {} }
local function setPretty(on)
 if on == pretty.on then return end
 pretty.on = on
 if on then
 local sv = {}
 pcall(function()
 sv.ClockTime = Lighting.ClockTime
 sv.Exposure = Lighting.ExposureCompensation
 sv.Spec = Lighting.EnvironmentSpecularScale
 sv.Diff = Lighting.EnvironmentDiffuseScale
 sv.Soft = Lighting.ShadowSoftness
 sv.WaterRef = terrain.WaterReflectance
 end)
 pretty.saved = sv
 Lighting.ClockTime = 17.7
 if timeSlider then timeSlider.set(17.7, true) end
 pcall(function() Lighting.ExposureCompensation = 0.25 end)
 pcall(function() Lighting.EnvironmentSpecularScale = 1 end)
 pcall(function() Lighting.EnvironmentDiffuseScale = 1 end)
 pcall(function() Lighting.ShadowSoftness = 0.25 end)
 pcall(function() terrain.WaterReflectance = 1 end)
 local function add(class, props)
 local i = Instance.new(class)
 i.Name = "SIMA_Pretty_" .. class
 for k, v in pairs(props) do pcall(function() i[k] = v end) end
 i.Parent = Lighting
 table.insert(pretty.fx, i)
 end
 add("ColorCorrectionEffect", { Contrast = 0.12, Saturation = 0.25, Brightness = 0.02, TintColor = Color3.fromRGB(255, 236, 218) })
 add("BloomEffect", { Intensity = 0.9, Size = 30, Threshold = 0.85 })
 add("SunRaysEffect", { Intensity = 0.3, Spread = 0.8 })
 add("DepthOfFieldEffect", { FarIntensity = 0.25, FocusDistance = 70, InFocusRadius = 45, NearIntensity = 0 })
 else
 for _, i in ipairs(pretty.fx) do if i.Parent then i:Destroy() end end
 table.clear(pretty.fx)
 local sv = pretty.saved
 if sv then
 if sv.ClockTime then Lighting.ClockTime = sv.ClockTime; if timeSlider then timeSlider.set(sv.ClockTime, true) end end
 if sv.Exposure then pcall(function() Lighting.ExposureCompensation = sv.Exposure end) end
 if sv.Spec then pcall(function() Lighting.EnvironmentSpecularScale = sv.Spec end) end
 if sv.Diff then pcall(function() Lighting.EnvironmentDiffuseScale = sv.Diff end) end
 if sv.Soft then pcall(function() Lighting.ShadowSoftness = sv.Soft end) end
 if sv.WaterRef then pcall(function() terrain.WaterReflectance = sv.WaterRef end) end
 pretty.saved = nil
 end
 end
end

-- Рѕс'с °р°р°р ° СССΜ РеРµ Рирѕрирµсђс ... Рѕрѕссс'Рер
local refl = { on = false }
local function setReflect(on)
 if on == refl.on then return end
 refl.on = on
 if on then
 local token, s = {}, { parts = {} }
 refl.token, refl.saved = token, s
 pcall(function() s.spec = Lighting.EnvironmentSpecularScale; Lighting.EnvironmentSpecularScale = 1 end)
 task.spawn(function()
 local n = 0
 for _, d in ipairs(Workspace:GetDescendants()) do
 if refl.token ~= token or not alive then break end
 if d:IsA("BasePart") and not d:IsA("Terrain") and d.Transparency < 0.5 and d.Reflectance < 0.12 then
 local m = d:FindFirstAncestorOfClass("Model")
 if not (m and m:FindFirstChildOfClass("Humanoid")) then
 s.parts[d] = d.Reflectance
 pcall(function() d.Reflectance = 0.12 end)
 end
 end
 n += 1
 if n % 400 == 0 then task.wait() end
 end
 end)
 else
 refl.token = nil
 local s = refl.saved
 if not s then return end
 for d, r in pairs(s.parts) do if d.Parent then pcall(function() d.Reflectance = r end) end end
 if s.spec then pcall(function() Lighting.EnvironmentSpecularScale = s.spec end) end
 refl.saved = nil
 end
end

-- Р * Р°Сµрѕрѕрѕрѕрерµ Рерѕр°Сјрј Ре Рерѕрѕ-Рерѕр"Рѕссс"
local function edgeFrame(size, pos, rot, parent)
 local f = new("Frame", { Size = size, Position = pos, BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 1, Active = false }, parent)
 new("UIGradient", { Rotation = rot, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) }) }, f)
 return f
end
local vignette = new("Frame", { Name = "Vignette", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Active = false, ZIndex = 1 }, gui)
edgeFrame(UDim2.new(1, 0, 0.3, 0), UDim2.new(0, 0, 0, 0), 90, vignette)
edgeFrame(UDim2.new(1, 0, 0.3, 0), UDim2.new(0, 0, 0.7, 0), 270, vignette)
edgeFrame(UDim2.new(0.25, 0, 1, 0), UDim2.new(0, 0, 0, 0), 0, vignette)
edgeFrame(UDim2.new(0.25, 0, 1, 0), UDim2.new(0.75, 0, 0, 0), 180, vignette)
local cinemaBars = new("Frame", { Name = "Cinema", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Active = false, ZIndex = 1 }, gui)
new("Frame", { Size = UDim2.new(1, 0, 0.11, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 1, Active = false }, cinemaBars)
new("Frame", { Size = UDim2.new(1, 0, 0.11, 0), Position = UDim2.new(0, 0, 0.89, 0), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, ZIndex = 1, Active = false }, cinemaBars)

------------------------------------------------------------------ Рўрўрўррњрр-РѢР¦РРІ
local function setOptimize(on)
 if on == opt.on then return end
 opt.on = on
 recomputeLighting()
 if on then
 local s = { mats = {}, em = {}, post = {} }
 opt.saved = s
 pcall(function()
 s.quality = settings().Rendering.QualityLevel
 settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
 end)
 local function killPost(parent)
 for _, v in ipairs(parent:GetChildren()) do
 if v:IsA("PostEffect") and v.Enabled then s.post[v] = true; v.Enabled = false end
 end
 end
 killPost(Lighting)
 if camera then killPost(camera) end
 task.spawn(function()
 local n = 0
 for _, d in ipairs(Workspace:GetDescendants()) do
 if not opt.on or not alive then break end
 if d:IsA("BasePart") and not d:IsA("Terrain") then
 if d.Material ~= Enum.Material.SmoothPlastic then
 s.mats[d] = { d.Material, d.Reflectance }
 pcall(function() d.Material = Enum.Material.SmoothPlastic; d.Reflectance = 0 end)
 end
 elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") or d:IsA("Beam") then
 local par = d.Parent
 if not (par and string.sub(par.Name, 1, 8) == "SIMA_FX_") and d.Enabled then
 s.em[d] = true
 pcall(function() d.Enabled = false end)
 end
 end
 n += 1
 if n % 400 == 0 then task.wait() end
 end
 end)
 else
 local s = opt.saved
 if not s then return end
 if s.quality then pcall(function() settings().Rendering.QualityLevel = s.quality end) end
 for v in pairs(s.post) do if v.Parent then v.Enabled = true end end
 for d, m in pairs(s.mats) do if d.Parent then pcall(function() d.Material = m[1]; d.Reflectance = m[2] end) end end
 for d in pairs(s.em) do if d.Parent then pcall(function() d.Enabled = true end) end end
 opt.saved = nil
 end
end

------------------------------------------------------------------ FOV
local fovTarget = nil

------------------------------------------------------------------ РЎРљРРќ: HEADLESS
local cosmetics = { headless = false }
local headSaved = setmetatable({}, { __mode = "k" })
local function applyCosmetics()
 local char = player.Character
 if not char then return end
 local head = char:FindFirstChild("Head")
 if not head then return end
 local face = head:FindFirstChildOfClass("Decal")
 if cosmetics.headless then
 if not headSaved[head] then headSaved[head] = { head.Transparency, face and face.Transparency or 0 } end
 if head.Transparency ~= 1 then head.Transparency = 1 end
 if face and face.Transparency ~= 1 then face.Transparency = 1 end
 elseif headSaved[head] then
 head.Transparency = headSaved[head][1]
 if face then face.Transparency = headSaved[head][2] end
 headSaved[head] = nil
 end
end
connect(player.CharacterAdded, function()
 task.delay(1.5, function() if alive then applyCosmetics() end end)
end)
task.spawn(function()
 while alive do
 task.wait(1)
 if cosmetics.headless then applyCosmetics() end
 end
end)

------------------------------------------------------------------ Рѣрјр Рѣ
local AURA_ORDER = { "blue", "violet", "white", "black", "yellow", "green" }
local AURAS = {
 blue = { c1 = Color3.fromRGB(60, 130, 255), c2 = Color3.fromRGB(140, 220, 255) },
 violet = { c1 = Color3.fromRGB(150, 60, 255), c2 = Color3.fromRGB(230, 150, 255) },
 white = { c1 = Color3.fromRGB(255, 255, 255), c2 = Color3.fromRGB(200, 220, 255) },
 black = { c1 = Color3.fromRGB(45, 45, 52), c2 = Color3.fromRGB(5, 5, 8) },
 yellow = { c1 = Color3.fromRGB(255, 215, 40), c2 = Color3.fromRGB(255, 250, 150) },
 green = { c1 = Color3.fromRGB(40, 220, 90), c2 = Color3.fromRGB(160, 255, 180) },
}
local auraCurrent = nil
local auraObjs = {}
local auraNote, clearAuraSwatch

local function clearAuraObjs()
 for _, o in ipairs(auraObjs) do if o.Parent then o:Destroy() end end
 table.clear(auraObjs)
end
local function applyAura()
 clearAuraObjs()
 if not auraCurrent then return end
 local char = player.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 if not root then return end
 local a = AURAS[auraCurrent]
 local dark = (auraCurrent == "black")

 local core = Instance.new("ParticleEmitter")
 core.Name = "SIMA_Aura"
 core.Texture = dark and SOFT or SPARK
 core.Color = ColorSequence.new(a.c1, a.c2)
 core.LightEmission = dark and 0 or 1
 core.Size = NS({ 0, 0.9 }, { 1, 0 })
 core.Transparency = NS({ 0, 0.2 }, { 1, 1 })
 core.Lifetime = NumberRange.new(1, 1.6)
 core.Speed = NumberRange.new(2, 4)
 core.Rate = 70
 core.Shape = Enum.ParticleEmitterShape.Cylinder
 core.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
 core.EmissionDirection = Enum.NormalId.Top
 core.SpreadAngle = Vector2.new(15, 15)
 core.Acceleration = Vector3.new(0, 2, 0)
 core.Rotation = NumberRange.new(0, 360)
 core.Parent = root
 table.insert(auraObjs, core)

 local glowE = Instance.new("ParticleEmitter")
 glowE.Name = "SIMA_AuraGlow"
 glowE.Texture = SOFT
 glowE.Color = ColorSequence.new(a.c1)
 glowE.LightEmission = dark and 0 or 0.6
 glowE.Size = NS({ 0, 7 }, { 1, 7 })
 glowE.Transparency = NS({ 0, 0.88 }, { 1, 0.88 })
 glowE.Lifetime = NumberRange.new(1, 1)
 glowE.Speed = NumberRange.new(0, 0)
 glowE.Rate = 4
 glowE.LockedToPart = true
 glowE.Parent = root
 table.insert(auraObjs, glowE)

 if not dark then
 local light = Instance.new("PointLight")
 light.Name = "SIMA_AuraLight"
 light.Color = a.c1; light.Range = 14; light.Brightness = 1.6
 light.Parent = root
 table.insert(auraObjs, light)
 end
end
local function setAura(id)
 auraCurrent = id
 applyAura()
 if auraNote then refreshOne(auraNote) end
end
connect(player.CharacterAdded, function()
 task.delay(1, function() if alive then applyAura() end end)
end)

------------------------------------------------------------------ РџР РћРҐРћР” РЎРљР'РћР—Г ГГ“Г РћРљРћР’
local passPlayers = false
connect(RunService.Stepped, function()
 if not passPlayers then return end
 for _, pl in ipairs(Players:GetPlayers()) do
 if pl ~= player and pl.Character then
 for _, p in ipairs(pl.Character:GetChildren()) do
 if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
 end
 end
 end
end)

------------------------------------------------------------------ Рўрўрўрўрљ Рљ
local antiAfkConn
local function setAntiAfk(on)
 if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
 if on then
 antiAfkConn = player.Idled:Connect(function()
 pcall(function()
 local vu = game:GetService("VirtualUser")
 vu:CaptureController()
 vu:ClickButton2(Vector2.new())
 end)
 end)
 end
end

------------------------------------------------------------------ Рўр'Рўрўр"Ррўр * Р 
local clickerOn, cps, bindKey, listening = false, 1000, nil, false

local hasM1 = typeof(mouse1click) == "function"
local vim
pcall(function() vim = game:GetService("VirtualInputManager") end)
local function doClick()
 if hasM1 then
 pcall(mouse1click)
 return
 end
 if vim then
 local ok = pcall(function()
 local pos = UserInputService:GetMouseLocation()
 vim:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
 vim:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
 end)
 if ok then return end
 end
 local char = player.Character
 local tool = char and char:FindFirstChildOfClass("Tool")
 if tool then pcall(function() tool:Activate() end) end
end

------------------------------------------------------------------ Рўрўрр¦Р«
local pMain = addTab("main", "tab_main")
local pShade = addTab("shaders", "tab_shaders")
local pSky = addTab("sky", "tab_sky")
local pPlayer = addTab("player", "tab_player")
local pClick = addTab("click", "tab_click")
local pSet = addTab("settings", "tab_settings")

-- Р»Р " Р°РЅР°СЏ
section(pMain, "pulse")
local statRow = new("Frame", { Size = UDim2.new(1, 0, 0, 74), BackgroundTransparency = 1, LayoutOrder = nextOrd() }, pMain)
local function card(x, key)
 local f = new("Frame", {
 Size = UDim2.new(0.5, -3, 1, 0), Position = UDim2.new(x, x == 0 and 0 or 3, 0, 0),
 BackgroundColor3 = C.panel, BorderSizePixel = 0,
 }, statRow)
 corner(f, 8)
 local t = new("TextLabel", { Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1,
 Font = Enum.Font.SourceSansSemibold, TextSize = 15, TextColor3 = C.sub }, f)
 reg(t, function() return tr(key) end)
 return new("TextLabel", { Size = UDim2.new(1, 0, 0, 36), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 1,
 Font = Enum.Font.SourceSansBold, TextSize = 30, Text = "--", TextColor3 = C.text }, f)
end
local fpsLabel = card(0, "fps")
local pingLabel = card(0.5, "ping")
note(pMain, function() return tr("hint_main") end)

-- Рер№РГР"
local presetToggles = {}
local function presetToggle(key, name, extra)
 local t
 t = toggle(pShade, key, function(on)
 if on then
 for _, o in pairs(presetToggles) do if o ~= t and o.get() then o.set(false) end end
 applyPreset(name)
 else
 restoreAtmo()
 end
 if extra then extra(on) end
 end)
 presetToggles[name] = t
 return t
end
local optToggle, reflToggle
section(pShade, "sec_pretty")
presetToggle("pretty", "sunset", setPretty)
reflToggle = toggle(pShade, "reflect", function(on)
 if on and optToggle and optToggle.get() then optToggle.set(false) end
 setReflect(on)
end)
toggle(pShade, "vignette", function(on) vignette.Visible = on end)
toggle(pShade, "cinema", function(on) cinemaBars.Visible = on end)
section(pShade, "sec_atmo")
presetToggle("azure", "azure")
presetToggle("frost", "frost")
presetToggle("void", "void")
section(pShade, "sec_part")
toggle(pShade, "snow", function(on) setEffect("snow", on) end)
toggle(pShade, "bluep", function(on) setEffect("blue", on) end)
toggle(pShade, "violetp", function(on) setEffect("violet", on) end)
section(pShade, "sec_light")
toggle(pShade, "fullbright", setFullbright)
toggle(pShade, "bloom", bloomFn)
toggle(pShade, "sunrays", raysFn)

-- Рµрµр±Рѕ
section(pSky, "sec_fog")
local fogSlider = slider(pSky, "fog", 0, 100, 0, setFog, "%")
section(pSky, "sec_clouds")
local cloudSlider = slider(pSky, "cloud_density", 0, 100, 0, function(v)
 local c = ensureClouds(); c.Cover = v / 100; c.Density = v / 100
end, "%")
local clearCloudSwatch = swatches(pSky, "cloud_color", {
 Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 170, 200), Color3.fromRGB(120, 180, 255),
 Color3.fromRGB(180, 120, 255), Color3.fromRGB(255, 170, 90), Color3.fromRGB(90, 90, 110),
}, function(col) ensureClouds().Color = col end)
section(pSky, "sec_space")
toggle(pSky, "stars", setStars)
timeSlider = slider(pSky, "time", 0, 24, orig.ClockTime, function(v) Lighting.ClockTime = v end, "")
note(pSky, function() return tr("stars_hint") end)

-- Ррисѣрѕре
section(pPlayer, "sec_perf")
optToggle = toggle(pPlayer, "optimize", function(on)
 if on and reflToggle and reflToggle.get() then reflToggle.set(false) end
 setOptimize(on)
end)
section(pPlayer, "sec_cam")
local fovSets = {}
local fovSlider
local function markFov(v)
 local r = math.floor(v + 0.5)
 for _, set in ipairs(fovSets) do
 set[1].BackgroundColor3 = (fovTarget and r == 90) and C.accent or C.panel
 set[2].BackgroundColor3 = (fovTarget and r == 120) and C.accent or C.panel
 end
end
local function resetFov()
 fovTarget = nil
 if camera then camera.FieldOfView = origFOV end
 fovSlider.set(origFOV, true)
 markFov(-1)
end
fovSlider = slider(pPlayer, "fov", 40, 120, origFOV, function(v) fovTarget = v; markFov(v) end, "")
local function fovButtons(page)
 local set = buttons(page, {
 { text = function() return "FOV 90" end, cb = function() fovSlider.set(90) end },
 { text = function() return "FOV 120" end, cb = function() fovSlider.set(120) end },
 { text = function() return tr("fovreset") end, cb = resetFov },
 })
 table.insert(fovSets, set)
end
fovButtons(pPlayer)
-- Рµ Рµ Рµ Рерѕрѕрере FOV 90 / 120 рѕр° Рир "Р°Рирѕрѕр№ Рирер" Р ° Ргрерµ
section(pMain, "sec_cam")
fovButtons(pMain)
section(pPlayer, "sec_avatar")
toggle(pPlayer, "headless", function(on) cosmetics.headless = on; applyCosmetics() end)
section(pPlayer, "sec_hud")
local dot = new("Frame", {
 Size = UDim2.fromOffset(5, 5), Position = UDim2.new(0.5, -2, 0.5, -2), BackgroundColor3 = Color3.fromRGB(80, 220, 255),
 BorderSizePixel = 0, Visible = false,
}, gui)
corner(dot, 3)
new("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1 }, dot)
toggle(pPlayer, "crosshair", function(on) dot.Visible = on end)
section(pPlayer, "sec_aura")
local auraColors = {}
for _, id in ipairs(AURA_ORDER) do table.insert(auraColors, AURAS[id].c1) end
clearAuraSwatch = swatches(pPlayer, "aura", auraColors, function(col)
 for _, id in ipairs(AURA_ORDER) do
 if AURAS[id].c1 == col then setAura(id) end
 end
end)
auraNote = note(pPlayer, function()
 return auraCurrent and tr("aura_" .. auraCurrent) or tr("aura_none")
end)
buttons(pPlayer, { { text = function() return tr("aura_off") end, cb = function() setAura(nil); clearAuraSwatch() end } })
section(pPlayer, "sec_move")
toggle(pPlayer, "pass_players", function(on) passPlayers = on end)
toggle(pPlayer, "anti_afk", setAntiAfk)

-- Ррр "Ререр"
local clickToggle
local statusLbl
section(pClick, "clicker")
clickToggle = toggle(pClick, "clicker", function(on) clickerOn = on end)
local bindBtn
bindBtn = buttons(pClick, {
 { text = function() return tr("bind") .. ": " .. (listening and tr("bind_wait") or (bindKey and bindKey.Name or tr("bind_none"))) end,
 cb = function() listening = true; refreshOne(bindBtn) end },
})[1]
local cpsSlider = slider(pClick, "cps", 1, 1000, cps, function(v) cps = math.floor(v + 0.5) end, "")
buttons(pClick, {
 { text = function() return tr("cps_ms") end, cb = function() cpsSlider.set(1000) end },
 { text = function() return "100" end, cb = function() cpsSlider.set(100) end },
 { text = function() return "10" end, cb = function() cpsSlider.set(10) end },
})
note(pClick, function() return tr("bind_hint") end)
statusLbl = new("TextLabel", {
 Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Font = Enum.Font.SourceSansSemibold, TextSize = 15,
 TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrd(),
}, pClick)
reg(statusLbl, function()
 if not clickerOn then return tr("st_off") end
 if BLOCK_CLICK_WHEN_MENU_OPEN and main.Visible then return tr("st_pause") end
 return tr("st_on")
end)

-- Р °р°Ссс'Срѕр№Рере
section(pSet, "sec_lang")
local langBtns
local function setLang(l) LANG = l; refreshAll() end
buttons(pSet, {
 { text = function() return "русский" end, cb = function() setLang("ru") end },
 { text = function() return "English" end, cb = function() setLang("en") end },
})

local function resetAll()
 for _, t in ipairs(allToggles) do if t.get() then t.set(false) end end
 restoreFog(); fogSlider.set(0, true)
 restoreClouds(); cloudSlider.set(0, true)
 Lighting.ClockTime = orig.ClockTime; timeSlider.set(orig.ClockTime, true)
 resetFov()
 clearCloudSwatch()
 setAura(nil); clearAuraSwatch()
 cosmetics.headless = false
 applyCosmetics()
 clickerOn = false
end
local function unload()
 resetAll()
 alive = false
 for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
 for _, fx in pairs(effects) do fx.part:Destroy() end
 gui:Destroy()
 table.clear(bound)
 table.clear(allToggles)
 table.clear(effects)
end
buttons(pSet, { { text = function() return tr("reset") end, cb = resetAll } })
buttons(pSet, { { text = function() return tr("unload") end, cb = unload } })
note(pSet, function() return tr("version") end)

showPage("main")

------------------------------------------------------------------ Р / РРљР "Р"
local frames, acc, fps = 0, 0, 60
connect(RunService.RenderStepped, function(dt)
 camera = Workspace.CurrentCamera
 if camera then
 if fovTarget then camera.FieldOfView = fovTarget end
 local pos = camera.CFrame.Position
 for _, fx in pairs(effects) do
 if fx.on then fx.part.CFrame = CFrame.new(pos + fx.offset) end
 end
 end
 frames += 1; acc += dt
 if acc >= 0.5 then fps = math.floor(frames / acc + 0.5); frames, acc = 0, 0 end
end)

local function getPing()
 local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
 return ok and math.floor(v + 0.5) or nil
end
task.spawn(function()
 while alive do
 fpsLabel.Text = tostring(fps)
 fpsLabel.TextColor3 = fps >= 50 and C.good or (fps >= 30 and C.warn or C.bad)
 local p = getPing()
 pingLabel.Text = p and (p .. " " .. tr("ms")) or "--"
 pingLabel.TextColor3 = (not p) and C.text or (p <= 80 and C.good or (p <= 150 and C.warn or C.bad))
 refreshOne(statusLbl)
 task.wait(0.5)
 end
end)

-- Р°Рис'Рѕрер"Ререрµµ: ССС Рес Рес'Р ° Рµ Рер" Ререре Рірѕ Рерѕ Рерѕ Рѕрѕрѕрѕре Ре Ргрµр "Р ° Рµ Рер°с ° Рес Р Р * р° Рер°Ргсђ (1000 Рер"Рерѕри / с = = ~16 Р * Р°Рер ° Рѕрре Рер ° 60 FPS ) 
local clickAcc = 0
connect(RunService.Heartbeat, function(dt)
 local blocked = BLOCK_CLICK_WHEN_MENU_OPEN and main.Visible
 if not clickerOn or blocked or listening then clickAcc = 0; return end
 clickAcc += dt
 local interval = 1 / math.max(cps, 1)
 local n = math.floor(clickAcc / interval)
 if n > 0 then
 clickAcc -= n * interval
 for _ = 1, math.min(n, 40) do doClick() end
 end
end)

-- Рер " Р°Рирес€Ре
connect(UserInputService.InputBegan, function(input, gp)
 if listening then
 if input.UserInputType == Enum.UserInputType.Keyboard then
 if input.KeyCode == Enum.KeyCode.Backspace then bindKey = nil
 elseif input.KeyCode ~= Enum.KeyCode.Escape then bindKey = input.KeyCode end
 listening = false
 refreshOne(bindBtn)
 end
 return
 end
 if gp then return end
 if input.KeyCode == Enum.KeyCode.RightShift then
 if main.Visible then minimize() else restore() end
 elseif bindKey and input.KeyCode == bindKey then
 clickToggle.set(not clickToggle.get())
 end
end)
