---@version 2.0.0 30.06.2026

--[[
    p   [Па] Давление
    s   [Дж/(кг∙К)] Удельная энтропия
    h   [Дж/кг] Удельная энтальпия
    t   [°C] Температура
    rho [кг/м³] Плотность
    u   [Па∙с] Вязкость
    w   [м/с] Скорость звука
    v   [м³/кг] Удельный объем
    x   [доля] Влажность
--]]

---@class if97
local if97 = {
    saturationPressure_t = require 'if97.bounds'.saturationPressure_t,
    saturationTemp_p = require 'if97.bounds'.saturationTemp_p,
    borderPressure_t = require 'if97.bounds'.borderPressure_t,
    borderTemp_p = require 'if97.bounds'.borderTemp_p,
    region_t_p = require 'if97.bounds'.region_t_p,

    ---вода [1]
    water = require 'if97.water',

    ---пар [2]
    steam = require 'if97.steam',

    ---сверхкритичная смесь [3]
    fluid = require 'if97.fluid',

    ---пароводяная смесь [4]
    mix = require 'if97.mix'
}

return if97
