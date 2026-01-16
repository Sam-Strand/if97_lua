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
