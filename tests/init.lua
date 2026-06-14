-- Функция для цветного вывода разницы
local function check(calc, need)
    local RED = '\27[91m'
    local GREEN = '\27[92m'
    local RESET = '\27[0m'

    if string.format('%.9g', calc) == string.format('%.9g', need) then
        return GREEN .. string.format('%.9g', calc) .. RESET
    else
        return RED .. string.format('%.9g', calc) .. ' должно быть: ' .. string.format('%.9g', need) .. RESET
    end
end

print 'Регион 1'
print 'Тестовые данные'
print()

-- Тестовые данные для региона 1
local t_values = { 300, 300, 500 }
local p_values = { 3, 80, 3 }

local v_expected = { 0.100215168e-2, 0.971180894e-3, 0.120241800e-2 }
local h_expected = { 0.115331273e3,  0.184142828e3,  0.975542239e3 }
local s_expected = { 0.392294792,    0.368563852,    0.258041912e1 }
local w_expected = { 0.150773921e4,  0.163469054e4,  0.124071337e4 }

-- Импорт модуля water
local water = require 'if97.water'
print 'water'

do
    local results = {}
    for i = 1, 3 do
        results[i] = check(water.h.t_p(t_values[i], p_values[i]), h_expected[i])
    end
    print('enthalpy:', table.concat(results, ' | '))
end

do
    local results = {}
    for i = 1, 3 do
        results[i] = check(water.v.t_p(t_values[i], p_values[i]), v_expected[i])
    end
    print('volume:', table.concat(results, ' | '))
end

do
    local results = {}
    for i = 1, 3 do
        results[i] = check(water.s.t_p(t_values[i], p_values[i]), s_expected[i])
    end
    print('entropy:', table.concat(results, ' | '))
end

do
    local results = {}
    for i = 1, 3 do
        results[i] = check(water.w.t_p(t_values[i], p_values[i]), w_expected[i])
    end
    print('sound_speed:', table.concat(results, ' | '))
end
--[[
--]]

print 'Регион 2'
print 'Тестовые данные'
print()

-- Тестовые данные для региона 2
t_values = { 300, 700, 700 }
p_values = { 0.0035, 0.0035, 30 }

v_expected = { 0.394913866e2, 0.923015898e2, 0.542946619e-2 }
h_expected = { 0.254991145e4, 0.333568375e4, 0.263149474e4 }
s_expected = { 0.852238967e1, 0.101749996e2, 0.517540298e1 }
w_expected = { 0.427920172e3, 0.644289068e3, 0.480386523e3 }

-- Импорт модуля steam
local steam = require 'if97.steam'
print 'steam'
--[[
-- Вызываем для каждого элемента отдельно
do
    local results = {}
    for i = 1, 3 do
        results[i] = check(steam.v.t_p(t_values[i], p_values[i]), v_expected[i])
    end
    print('volume:', table.concat(results, ' | '))
end

--]]
do
    local results = {}
    for i = 1, 3 do
        results[i] = check(steam.h.t_p(t_values[i], p_values[i]), h_expected[i])
    end
    print('enthalpy:', table.concat(results, ' | '))
end
do
    local results = {}
    for i = 1, 3 do
        results[i] = check(steam.s.t_p(t_values[i], p_values[i]), s_expected[i])
    end
    print('entropy:', table.concat(results, ' | '))
end

do
    local results = {}
    for i = 1, 3 do
        results[i] = check(steam.w.t_p(t_values[i], p_values[i]), w_expected[i])
    end
    print('sound_speed:', table.concat(results, ' | '))
end
--[[
-- Импорт модуля fluid
local fluid = require'if97.fluid'
print(fluid.h.t_rho(650, 500))
-- 1863.43019
--]]
