-- bundler.lua (Запуск в терминале: lune run bundler)
local fs = require("@lune/fs")

local function build()
    print("Compiling libu.net...")

    -- Считываем содержимое всех файлов
    local acrylicCode = fs.readFile("src/Acrylic.lua")
    local creatorCode = fs.readFile("src/Creator.lua")
    local elementsCode = fs.readFile("src/Elements.lua")
    local initCode = fs.readFile("src/init.lua")

    -- Убираем из init.lua стандартные строки "require", так как мы собираем всё в один файл
    initCode = initCode:gsub("local Acrylic = require%(script%.Parent%.Acrylic%)", "local Acrylic = {}")
    initCode = initCode:gsub("local Creator = require%(script%.Parent%.Creator%)", "local Creator = {}")
    initCode = initCode:gsub("local Elements = require%(script%.Parent%.Elements%)", "local Elements = {}")

    -- Собираем итоговый монолитный скрипт
    local bundle = {}
    table.insert(bundle, "-- libu.net compiled release bundle")
    table.insert(bundle, "local Acrylic = (function()")
    table.insert(bundle, acrylicCode)
    table.insert(bundle, "end)()")
    
    table.insert(bundle, "local Creator = (function()")
    table.insert(bundle, creatorCode)
    table.insert(bundle, "end)()")

    table.insert(bundle, "local Elements = (function()")
    table.insert(bundle, elementsCode)
    table.insert(bundle, "end)()")

    table.insert(bundle, initCode)

    local finalSource = table.concat(bundle, "\n\n")
    fs.writeFile("compiled.lua", finalSource)

    print("Success! Output written to compiled.lua")
end

build()
