--[[
	SIMA menu  |  LocalScript (StarterPlayerScripts) РёР»Рё РёСЃРїРѕР»РЅРёС‚РµР»СЊ
	RU / EN, СЃРІРѕСЂР°С‡РёРІР°РЅРёРµ РІ РєСЂСѓР¶РѕРє, С€РµР№РґРµСЂС‹, РЅРµР±Рѕ, РѕРїС‚РёРјРёР·Р°С†РёСЏ, FOV,
	Headless / Korblox, Р°РІС‚РѕРєР»РёРєРµСЂ СЃ Р±РёРЅРґРѕРј, РїСЂРёС†РµР» Рё С‚.Рґ.
	RightShift - Р±С‹СЃС‚СЂРѕ СЃРІРµСЂРЅСѓС‚СЊ / РѕС‚РєСЂС‹С‚СЊ РјРµРЅСЋ.
]]

------------------------------------------------------------------ РќРђРЎРўР РћР™РљР
local DEFAULT_LANG = "ru"               -- "ru" РёР»Рё "en"
local BLOCK_CLICK_WHEN_MENU_OPEN = true -- Р°РІС‚РѕРєР»РёРєРµСЂ РЅРµ РєР»РёРєР°РµС‚, РїРѕРєР° РјРµРЅСЋ РѕС‚РєСЂС‹С‚Рѕ

------------------------------------------------------------------ РЎР•Р Р’РРЎР«
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

------------------------------------------------------------------ Р›РћРљРђР›РР—РђР¦РРЇ
local LANG = DEFAULT_LANG
local TXT = {
	ru = {
		tab_main = "главная", tab_shaders = "шейдеры", tab_sky = "небо",
		tab_player = "проигрыватель", tab_click = "автокликер", tab_settings = "настройки",
		pulse = "пульс", fps = "FPS", ping = "пинг", ms = "мс",
		hint_main = "SIMA - меню визуальных эффектов. свернуть: кнопка \"X\" или сдвиг вправо.",
		sec_atmo = "атмосфера", azure = "лазурный сон", frost = "ледяная вуаль", void = "ночь пустоты",
		sec_part = "частицы", snow = "снег", bluep = "синие частицы", violetp = "фиолетовые частицы",
		sec_light = "свет", fullbright = "солнечные лучи", bloom = "сияние", sunrays = "солнечные зайчики",
		sec_fog = "туман", fog = "плотность тумана",
		sec_clouds = "облака", cloud_density = "плотность облаков", cloud_color = "оттенок облаков",
		sec_space = "пространство", stars = "звездный холст", stars_hint = "звезды видны ночью - перемещение", time = "время",
		sec_perf = "производительность", optimize = "турбо-режим",
		sec_cam = "камера", fov = "широкий обзор", fovreset = "сброс",
		sec_avatar = "аватар (аватар видите только вы)", headless = "Headless", korblox = "Korblox",
		sec_hud = "HUD", crosshair = "точка фокусировки",
		clicker = "быстрое нажатие", bind = "горячая клавиша", bind_wait = "нажать клавишу...", cps = "скорость нажатия",
		st_off = "статус: вкллючен", st_on = "статус: щелчок", st_pause = "статус: приостановлено (меню открыто)",
		sec_lang = "язык", reset = "reset", unload = "выгрузить SIMA", version = "SIMA v1.0",
	},
	en = {
		tab_main = "Main", tab_shaders = "Shaders", tab_sky = "Sky",
		tab_player = "Player", tab_click = "Clicker", tab_settings = "Settings",
		pulse = "Pulse", fps = "FPS", ping = "Ping", ms = "ms",
		hint_main = "SIMA - visual effects menu. Minimize: the \"X“\" button or RightShift.",
		sec_atmo = "Atmosphere", azure = "Azure Dream", frost = "Frost Veil", void = "Void Night",
		sec_part = "Particles", snow = "Winter Whisper", bluep = "Blue Fireflies", violetp = "Violet Spirits",
		sec_light = "Light", fullbright = "Sunburst", bloom = "Dream Glow", sunrays = "Sunbeams",
		sec_fog = "Fog", fog = "Mist Master",
		sec_clouds = "Clouds", cloud_density = "Cloud Weaver", cloud_color = "Cloud Tint",
		sec_space = "Space", stars = "Star Canvas", stars_hint = "Stars show at night - move \"Chrono\".", time = "Chrono",
		sec_perf = "Performance", optimize = "Turbo Mode",
		sec_cam = "Camera", fov = "Wide Eye", fovreset = "Reset",
		sec_avatar = "Avatar (only you see it)", headless = "Headless", korblox = "Korblox",
		sec_hud = "HUD", crosshair = "Focus Dot",
		clicker = "Rapid Tap", bind = "Hotkey", bind_wait = "Press a key...", cps = "Tap Speed",
		st_off = "Status: off", st_on = "Status: clicking", st_pause = "Status: paused (menu open)",
		sec_lang = "Language", reset = "Reset all", unload = "Unload SIMA", version = "SIMA v1.0",
	},
}
local function tr(key) return (TXT[LANG] and TXT[LANG][key]) or key end

local bound = {}
local function reg(obj, fn) bound[obj] = fn; obj.Text = fn(); return obj end
local function refreshOne(obj) if bound[obj] then obj.Text = bound[obj]() end end
local function refreshAll() for o, fn in pairs(bound) do if o.Parent then o.Text = fn() end end end

------------------------------------------------------------------ РўР•РњРђ Р РҐР•Р›РџР•Р Р« UI
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

local main = new("Frame", {
	Name = "Main", Size = UDim2.fromOffset(MENU_W, MENU_H),
	Position = UDim2.new(0.5, -MENU_W / 2, 0.5, -MENU_H / 2),
	BackgroundColor3 = C.bg, BorderSizePixel = 0, ClipsDescendants = true,
}, gui)
corner(main, 12)
new("UIStroke", { Color = C.accent, Transparency = 0.5, Thickness = 1.5 }, main)

local titleBar = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.panel, BorderSizePixel = 0 }, main)
new("TextLabel", {
	Size = UDim2.new(0, 120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1,
	Text = "SIMA", Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = C.accent,
	TextXAlignment = Enum.TextXAlignment.Left,
}, titleBar)
local minBtn = new("TextButton", {
	Size = UDim2.fromOffset(30, 24), Position = UDim2.new(1, -38, 0, 6), BackgroundColor3 = C.off,
	Text = "X", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = C.text, AutoButtonColor = true,
}, titleBar)
corner(minBtn, 6)

-- РєСЂСѓРіР»Р°СЏ РєРЅРѕРїРєР° РґР»СЏ СЃРІС‘СЂРЅСѓС‚РѕРіРѕ РјРµРЅСЋ
local circle = new("TextButton", {
	Name = "Circle", Size = UDim2.fromOffset(CIRCLE, CIRCLE), BackgroundColor3 = C.accent,
	Text = "S", Font = Enum.Font.GothamBlack, TextSize = 22, TextColor3 = C.text,
	Visible = false, AutoButtonColor = true,
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
	local p, s = main.AbsolutePosition, main.AbsoluteSize
	circle.Position = UDim2.fromOffset(p.X + s.X - CIRCLE, p.Y)
	main.Visible = false
	circle.Visible = true
end
local function restore()
	local p = circle.AbsolutePosition
	local vp = gui.AbsoluteSize
	local x = math.clamp(p.X + CIRCLE - MENU_W, 0, math.max(0, vp.X - MENU_W))
	local y = math.clamp(p.Y, 0, math.max(0, vp.Y - MENU_H))
	main.Position = UDim2.fromOffset(x, y)
	circle.Visible = false
	main.Visible = true
end
connect(minBtn.MouseButton1Click, minimize)
connect(circle.MouseButton1Click, function() if not circleMoved() then restore() end end)

------------------------------------------------------------------ Р’РљР›РђР”РљР
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
		Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.sub, Text = "", AutoButtonColor = false,
	}, tabBar)
	corner(b, 6)
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, b)
	reg(b, function() return tr(key) end)
	connect(b.MouseButton1Click, function() showPage(id) end)
	pages[id], tabButtons[id] = page, b
	return page
end

------------------------------------------------------------------ Р’РР”Р–Р•РўР«
local allToggles = {}

local function section(page, key)
	local l = new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 12,
		TextColor3 = C.accent, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrd(),
	}, page)
	reg(l, function() return string.upper(tr(key)) end)
	return l
end

local function note(page, fn, color)
	local l = new("TextLabel", {
		Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 12,
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
			Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, AutoButtonColor = true,
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
		Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
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
		Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
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
		Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
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

------------------------------------------------------------------ РЎРћРҐР РђРќРЃРќРќР«Р• РРЎРҐРћР”РќР«Р• Р—РќРђР§Р•РќРРЇ
local orig = {
	Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness,
	FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor,
	ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
}
local origFOV = camera and camera.FieldOfView or 70

------------------------------------------------------------------ РђРўРњРћРЎР¤Р•Р Рђ
local PRESETS = {
	azure = { Color = Color3.fromRGB(110, 165, 255), Decay = Color3.fromRGB(50, 90, 200), Density = 0.38, Haze = 1.8, Glare = 0.35, Offset = 0.2,
		Ambient = Color3.fromRGB(60, 90, 170), Fog = Color3.fromRGB(120, 170, 255) },
	frost = { Color = Color3.fromRGB(245, 248, 255), Decay = Color3.fromRGB(225, 230, 240), Density = 0.45, Haze = 2.2, Glare = 0, Offset = 0.1,
		Ambient = Color3.fromRGB(190, 190, 200), Fog = Color3.fromRGB(240, 244, 255) },
	void = { Color = Color3.fromRGB(8, 8, 14), Decay = Color3.fromRGB(0, 0, 0), Density = 0.5, Haze = 2.5, Glare = 0, Offset = 0,
		Ambient = Color3.fromRGB(15, 15, 25), Fog = Color3.fromRGB(5, 5, 10), Brightness = 0.6 },
}
local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
local atmoOrig = atmo and { Color = atmo.Color, Decay = atmo.Decay, Density = atmo.Density, Haze = atmo.Haze, Glare = atmo.Glare, Offset = atmo.Offset }
local atmoCreated = false

local opt = { on = false }
local lightState = { preset = nil, fullbright = false }
-- РµРґРёРЅР°СЏ С‚РѕС‡РєР° СЃР±РѕСЂРєРё РѕСЃРІРµС‰РµРЅРёСЏ: РѕСЂРёРіРёРЅР°Р» -> РїСЂРµСЃРµС‚ -> fullbright (+ С‚РµРЅРё РѕС‚ С‚СѓСЂР±Рѕ-СЂРµР¶РёРјР°)
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

------------------------------------------------------------------ Р§РђРЎРўРР¦Р«
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

------------------------------------------------------------------ РўРЈРњРђРќ / РћР‘Р›РђРљРђ / Р—Р’РЃР—Р”Р«
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

------------------------------------------------------------------ РР¤Р¤Р•РљРўР« РЎР’Р•РўРђ
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

------------------------------------------------------------------ РћРџРўРРњРР—РђР¦РРЇ
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

------------------------------------------------------------------ РЎРљРРќ: HEADLESS / KORBLOX
local cosmetics = { headless = false, korblox = false }
local korbloxSaved = setmetatable({}, { __mode = "k" })
local headSaved = setmetatable({}, { __mode = "k" })
local KORBLOX = {
	RightUpperLeg = { "902942096", "902843398" },
	RightLowerLeg = { "902942093", "902843398" },
	RightFoot = { "902942089", "902843398" },
}
local function applyCosmetics()
	local char = player.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if head then
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
	for _, name in ipairs({ "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg" }) do
		local part = char:FindFirstChild(name)
		if part and part:IsA("BasePart") then
			if cosmetics.korblox then
				local sv = korbloxSaved[part]
				if not sv then
					sv = { Transparency = part.Transparency, meshOk = false }
					if part:IsA("MeshPart") then sv.MeshId = part.MeshId; sv.TextureID = part.TextureID end
					korbloxSaved[part] = sv
					local ids = KORBLOX[name]
					if ids and part:IsA("MeshPart") then
						sv.meshOk = pcall(function()
							part.MeshId = "rbxassetid://" .. ids[1]
							part.TextureID = "rbxassetid://" .. ids[2]
						end)
					end
				end
				-- Р·Р°РїР°СЃРЅРѕР№ РІР°СЂРёР°РЅС‚: В«РїСЂРёР·СЂР°С‡РЅР°СЏВ» РЅРѕРіР°, РґРµСЂР¶РёС‚СЃСЏ РїРѕСЃС‚РѕСЏРЅРЅРѕ
				if not sv.meshOk and part.Transparency ~= 0.55 then part.Transparency = 0.55 end
			elseif korbloxSaved[part] then
				local sv = korbloxSaved[part]
				pcall(function()
					part.Transparency = sv.Transparency
					if sv.MeshId then part.MeshId = sv.MeshId; part.TextureID = sv.TextureID end
				end)
				korbloxSaved[part] = nil
			end
		end
	end
end
connect(player.CharacterAdded, function()
	task.delay(1.5, function() if alive then applyCosmetics() end end)
end)
task.spawn(function()
	while alive do
		task.wait(1)
		if cosmetics.headless or cosmetics.korblox then applyCosmetics() end
	end
end)

------------------------------------------------------------------ РђР’РўРћРљР›РРљР•Р 
local clickerOn, cps, bindKey, listening = false, 10, Enum.KeyCode.F, false

local function doClick()
	if typeof(mouse1click) == "function" then
		pcall(mouse1click)
		return
	end
	local ok = pcall(function()
		local vim = game:GetService("VirtualInputManager")
		local pos = UserInputService:GetMouseLocation()
		vim:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
		vim:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
	end)
	if ok then return end
	local char = player.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	if tool then pcall(function() tool:Activate() end) end
end

------------------------------------------------------------------ РЎРўР РђРќРР¦Р«
local pMain = addTab("main", "tab_main")
local pShade = addTab("shaders", "tab_shaders")
local pSky = addTab("sky", "tab_sky")
local pPlayer = addTab("player", "tab_player")
local pClick = addTab("click", "tab_click")
local pSet = addTab("settings", "tab_settings")

-- Р“Р»Р°РІРЅР°СЏ
section(pMain, "pulse")
local statRow = new("Frame", { Size = UDim2.new(1, 0, 0, 74), BackgroundTransparency = 1, LayoutOrder = nextOrd() }, pMain)
local function card(x, key)
	local f = new("Frame", {
		Size = UDim2.new(0.5, -3, 1, 0), Position = UDim2.new(x, x == 0 and 0 or 3, 0, 0),
		BackgroundColor3 = C.panel, BorderSizePixel = 0,
	}, statRow)
	corner(f, 8)
	local t = new("TextLabel", { Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0, 6), BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.sub }, f)
	reg(t, function() return tr(key) end)
	return new("TextLabel", { Size = UDim2.new(1, 0, 0, 36), Position = UDim2.new(0, 0, 0, 28), BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold, TextSize = 26, Text = "--", TextColor3 = C.text }, f)
end
local fpsLabel = card(0, "fps")
local pingLabel = card(0.5, "ping")
note(pMain, function() return tr("hint_main") end)

-- РЁРµР№РґРµСЂС‹
section(pShade, "sec_atmo")
local presetToggles = {}
local function presetToggle(key, name)
	local t
	t = toggle(pShade, key, function(on)
		if on then
			for _, o in pairs(presetToggles) do if o ~= t and o.get() then o.set(false, true) end end
			applyPreset(name)
		else
			restoreAtmo()
		end
	end)
	presetToggles[name] = t
end
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

-- РќРµР±Рѕ
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
local timeSlider = slider(pSky, "time", 0, 24, orig.ClockTime, function(v) Lighting.ClockTime = v end, "")
note(pSky, function() return tr("stars_hint") end)

-- РРіСЂРѕРє
section(pPlayer, "sec_perf")
toggle(pPlayer, "optimize", setOptimize)
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
-- С‚Рµ Р¶Рµ РєРЅРѕРїРєРё FOV 90 / 120 РЅР° РіР»Р°РІРЅРѕР№ РІРєР»Р°РґРєРµ
section(pMain, "sec_cam")
fovButtons(pMain)
section(pPlayer, "sec_avatar")
toggle(pPlayer, "headless", function(on) cosmetics.headless = on; applyCosmetics() end)
toggle(pPlayer, "korblox", function(on) cosmetics.korblox = on; applyCosmetics() end)
section(pPlayer, "sec_hud")
local dot = new("Frame", {
	Size = UDim2.fromOffset(5, 5), Position = UDim2.new(0.5, -2, 0.5, -2), BackgroundColor3 = Color3.fromRGB(80, 220, 255),
	BorderSizePixel = 0, Visible = false,
}, gui)
corner(dot, 3)
new("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1 }, dot)
toggle(pPlayer, "crosshair", function(on) dot.Visible = on end)

-- РљР»РёРєРµСЂ
local clickToggle
local statusLbl
section(pClick, "clicker")
clickToggle = toggle(pClick, "clicker", function(on) clickerOn = on end)
local bindBtn
bindBtn = buttons(pClick, {
	{ text = function() return tr("bind") .. ": " .. (listening and tr("bind_wait") or bindKey.Name) end,
		cb = function() listening = true; refreshOne(bindBtn) end },
})[1]
slider(pClick, "cps", 1, 30, cps, function(v) cps = math.floor(v + 0.5) end, "")
statusLbl = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 12,
	TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrd(),
}, pClick)
reg(statusLbl, function()
	if not clickerOn then return tr("st_off") end
	if BLOCK_CLICK_WHEN_MENU_OPEN and main.Visible then return tr("st_pause") end
	return tr("st_on")
end)

-- РќР°СЃС‚СЂРѕР№РєРё
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
	cosmetics.headless, cosmetics.korblox = false, false
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

------------------------------------------------------------------ Р¦РРљР›Р«
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

-- Р°РІС‚РѕРєР»РёРєРµСЂ: РЅРµ РєР»РёРєР°РµС‚, РїРѕРєР° РјРµРЅСЋ РѕС‚РєСЂС‹С‚Рѕ
task.spawn(function()
	while alive do
		local blocked = BLOCK_CLICK_WHEN_MENU_OPEN and main.Visible
		if clickerOn and not blocked and not listening then
			doClick()
			task.wait(1 / math.max(cps, 1))
		else
			task.wait(0.1)
		end
	end
end)

-- РєР»Р°РІРёС€Рё
connect(UserInputService.InputBegan, function(input, gp)
	if listening then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode ~= Enum.KeyCode.Escape then bindKey = input.KeyCode end
			listening = false
			refreshOne(bindBtn)
		end
		return
	end
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		if main.Visible then minimize() else restore() end
	elseif input.KeyCode == bindKey then
		clickToggle.set(not clickToggle.get())
	end
end)
