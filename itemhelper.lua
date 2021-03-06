require "lib.moonloader"
local keys = require "vkeys"

script_version("1.1")
script_author("Nagga")
script_description("Contact - vk.com/t_nagga")
local dlstatus = require('moonloader').download_status
local color = 0x348cb2

local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)

local tag = "{C0C0C0}[{9400D3}Item{696969}Helper{C0C0C0}]"
local abcd = {
["Часы"] = "1-12, 503-505",
["Наушники"] = "13-16",
["Бандана"] = "17-26, 107-111, 128-142",
["Очки"] = "27- 44, 39-41",
["Шапка"] = "45-47, 48-50, 117-119, 153-155, 589-591",
["Панамка"] = "51-53",
["Кепка"] = "54-65, 149-152, 156",
["Каска"] = "66-85, 170-171, 177-178",
["Парик"] = "86-87",
["Берет"] = "88-92",
["Шляпа"] = "93-97, 101-106, 143-148, 158-159, 173",
["Рюкзак"] = "98-100, 121-125",
["Усы"] = "112-113",
["Гитара"] = "114-116",
["Повязка на глаз"] = "120",
["Ёлка"] = "126",
["Чемодан"] = "127",
["Маска"] = "157, 166",
["Попугай"] = "160",
["Метла"] = "162",
["Рога"] = "163",
["Голова"] = "161, 164, 167",
["Тыква"] = "165, 525",
["Скейт"] = "168",
["Крест"] = "168",
["Китайский веер"] = "172",
["Звезда"] = "174",
["Сумка для ноутбука"] = "175",
["Респиратор"] = "176",
["Полицейский бронежилет"] = "179",
["Бронежилет"] = "180, 521",
["Бумбокс"] = "181",
["Клюшка"] = "182",
["Бита"] = "183, 580",
["Лопата"] = "184",
["Кий"] = "185",
["Катана"] = "186",
["Трость"] = "187",
["Доска"] = "188-190",
["Шлем"] = "191, 506-509, 585",
["Наркотики"] = "510, 670",
["Материалы"] = "511",
["Чипсы"] = "512",
["Спранк"] = "513",
["Пиво"] = "514",
["Маска"] = "515, 586-588",
["Канистра"] = "516",
["Радио"] = "517",
["Удочка"] = "519",
["Набор для починки"] = "520",
["Семейный талон"] = "522",
["Рыба"] = "523",
["Открытка"] = "524",
["Рецепт"] = "526",
["Ингредиенты"] = "527",
["Семена наркотиков"] = "528",
["Новогодний мешок"] = "529",
["Фишки для казино"] = "530",
["Череп"] = "532",
["Сертификат"] = "533-546, 570, 602",
["Шприц"] = "547",
["Черви"] = "548",
["Жаренная рыба"] = "549",
["Отмычка"] = "550",
["Скидочный талон"] = "551",
["Подарок"] = "552",
["Наклейка"] = "553",
["Twin Turbo"] = "554",
["Рулетка"] = "555-557, 569",
["Скрепки"] = "558",
["Телефон"] = "559",
["Яд"] = "560",
["Сигареты"] = "561",
["Зажигалка"] = "562",
["Телефонная книга"] = "563",
["Таблетки"] = "564",
["Баллончик"] = "565",
["Дрова"] = "566",
["Феерверк"] = "567",
["Пропуск"] = "568",
["Колонка"] = "578",
["Огнетушитель"] = "579",
["Меч"] = "581",
["Молот"] = "582",
["Маска CJ"] = "583",
["Красный чемодан"] = "584",
["Жилет"] = "592",
["Повязка на шею"] = "593",
["Ресурс"] = "594-600, 674",
["Мусор"] = "601",
["Улучшения"] = "603-626",
["Щит"] = "627",
["Рваная"] = "629-669",
["Кирка"] = "671",
["Грабли"] = "672",
["Аптечка"] = "673",
["Xiaomi"] = "675-685",
["Huawei"] = "686-696",
["Google"] = "697-707",
["Samsung"] = "708-718",
["IPhone"] = "719-729"
}

function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://raw.githubusercontent.com/Tony-Nagga/itemhelper/master/updater', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться 
          sampAddChatMessage(('[Testing]: У вас и так последняя версия! Обновление отменено'), color)
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(('[Testing]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), color)
sampAddChatMessage(('[Testing]: Текущая версия: '..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Обновление завершено!'), color)
  thisScript():reload()
end
end)
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	imgui.Process = false
	
	sampAddChatMessage(tag .." {FFFFFF}успешно загружен. Помощь - {FF4500}/nghelp", -1)
	
	sampRegisterChatCommand("ngitem", cmd_sear_number)
	sampRegisterChatCommand("ngmenu", cmd_ngmenu)
	sampRegisterChatCommand("nghelp", giveitemhelp)
	
	while true do wait(0)
		if main_window_state.v == false then
			imgui.Process = false
		end

	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	end
end

local selected_item = imgui.ImInt(0)

function cmd_sear_number(aggr)
	if aggr ~= nil then
		for k, v in pairs(abcd) do
			if k == aggr then
				sampAddChatMessage(tag .. "{FFFFFF}: ID = " .. v .. ".", -1)
			end
		end
	end
end

function giveitemhelp()
	sampAddChatMessage(tag .. "{FFFFFF}: {FF4500}/ngmenu {FFFFFF}- открыть меню выдачи предметов.", -1)
	sampAddChatMessage(tag .. "{FFFFFF}: {FF4500}/ngitem {FFFFFF}[{9ACD32}Name{FFFFFF}] - поиск предмета по Названию.", -1)
	sampAddChatMessage(tag .. "{FFFFFF}: {FFFFFF}Пример: {FF4500}/ngitem {9ACD32}Повязка на глаз {FFFFFF}- выдаст в чат ID = 120.", -1)
end

function cmd_ngmenu(arg)
	main_window_state.v = not main_window_state.v
	imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
	imgui.Begin(u8"ItemHelper by Nagga")
	imgui.Text(u8"Обновление:")
	if imgui.Button(u8"Проверка обновления") then
      printStringNow('Updating!', 1000)
      update()
    end
	imgui.Text("XYI SOSI PIDOR, ERROR TYT!")
	imgui.End()
end
