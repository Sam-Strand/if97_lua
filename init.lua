---@version 1.11 30.12.2025

--[[
    p   [Па] Давление
    s   [Дж/(кг∙К)] Удельная энтропия
    i   [Дж/кг] Удельная энтальпия
    t   [°C] Температура
    rho [кг/м³] Плотность
    u   [Па∙с] Вязкость
    w   [м/с] Скорость звука
    v   [м³/кг] Удельный объем
    x   [доля] Влажность
--]]

---@class mt
local mt = {
    minP = 611.213,
    maxP = 1e8,
    minT = 0,
    maxT = 800,
    t4Max = 373.946,
    p4Max = 22.064,
    p3Min = 16.5292,
    t3Min = 350,
}
mt.__index = mt

local CtoK = 273.15
local R = 461.526

--- Определяет регион на диаграмме
---@param t number [°C] Температура
---@param p number [Па] Давление
---@return string
function mt.regionTP(t, p)
    assert(p >= mt.minP and p <= mt.maxP and t >= mt.minT and t <= mt.maxT,
        'Недопустимые исходные данные ' .. t .. ' [°C], ' .. p .. '[Па]')
    if p < mt.borderPressureT(t) and t > mt.borderTempP(p) then
        return 'steam'
    else
        if p == mt.saturationPressureT(t) or t == mt.saturationTempP(p) then
            return 'mix'
        else
            if t < 350 then
                return 'water'
            else
                return 'fluid'
            end
        end
    end
end

--- Функция для поиска давление левой границы пересечение зоны 2 (Перегретый пар)
--- с зонами 4 (Пароводяная смесь), 3 (Сверхкритическая смесь)) через температуру
---@param t number [°C] Температура
---@return number? [Па] Давление
function mt.borderPressureT(t)
    if t <= mt.t3Min then -- пересечение с 4
        return mt.saturationPressureT(t)
    else                  -- пересечение с 3
        t = t + CtoK
        return (348.05185628969 - 1.1671859879975 * t + 1.0192970039326E-03 * t ^ 2) * 1e6
    end
end

--- Функция для поиска температуры левой границы пересечение зоны 2 (Перегретый пар)
--- с зонами 4 (Пароводяная смесь), 3 (Сверхкритическая смесь)) через давление
---@param p number [Па] Давление
---@return number? [°C] Температура
function mt.borderTempP(p)
    p = p * 1e-6
    if p < mt.p3Min then -- пересечение с 4
        return mt.saturationTempP(p)
    else                 -- пересечение с 3
        return 572.54459862746 + ((p - 13.91883977887) / 1.0192970039326E-03) ^ 0.5 - CtoK
    end
end

--- Функция линии [4] (пароводяной смеси) в PT диаграмме от температуры
---@param t number [К] Температура
---@return number? [Па] Давление
function mt.saturationPressureT(t)
    t = t + CtoK
    if t <= mt.t4Max then
        local K1 = t - 0.23855557567849 / (t - 650.17534844798)
        local K2 = -17.073846940092 * K1 ^ 2 + 12020.82470247 * K1 - 3232555.0322333
        local K3 = 14.91510861353 * K1 ^ 2 + -4823.2657361591 * K1 + 405113.40542057
        return (2 * K3 / (-K2 + (K2 ^ 2 - 4 * (K1 ^ 2 + 1167.0521452767 * K1 - 724213.16703206) * K3) ^ 0.5)) ^ 4 * 1e6
    end
end

--- Функция линии [4] (пароводяной смеси) в PT диаграмме от давления
---@param p number [Па] Давление
---@return number? [К] Температура
function mt.saturationTempP(p)
    p = p * 1e-6
    local k1 = 650.17534844798
    if p <= mt.t4Max then
        p = p ^ 0.25
        local K1 = 1167.0521452767 * p ^ 2 + 12020.82470247 * p - 4823.2657361591
        local K2 = -724213.16703206 * p ^ 2 + -3232555.0322333 * p + 405113.40542057
        local K3 = 2 * K2 / (-K1 - (K1 ^ 2 - 4 * (p ^ 2 - 17.073846940092 * p + 14.91510861353) * K2) ^ 0.5)
        return (k1 + K3 - ((k1 + K3) ^ 2 - 4 * (k1 * K3 - 0.23855557567849)) ^ 0.5) / 2 - CtoK
    end
end

---@class if97
local if97 = setmetatable({}, mt)

---вода [1]
if97.water = require 'water'

---пар [2]
if97.steam = require 'steam'

---сверхкритичная смесь [3]
if97.fluid = require 'fluid'

---пароводяная смесь [4]
if97.mix = require 'mix'

return if97
