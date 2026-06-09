local consts = require 'if97.consts'
local bounds = {}
local sqrt = require 'math'.sqrt

--- Функция линии [4] (пароводяной смеси) в PT диаграмме от температуры
---@param t number [К] Температура
---@return number? [МПа] Давление
function bounds.saturationPressure_t(t)
    if t > consts.t4Max or t < consts.minT then -- Выход за границы
        return false
    end
    local K1 = t - 0.23855557567849 / (t - 650.17534844798)
    local K2 = -17.073846940092 * K1 ^ 2 + 12020.82470247 * K1 - 3232555.0322333
    local K3 = 14.91510861353 * K1 ^ 2 + -4823.2657361591 * K1 + 405113.40542057
    return (2 * K3 / (-K2 + sqrt(K2 ^ 2 - 4 * (K1 ^ 2 + 1167.0521452767 * K1 - 724213.16703206) * K3))) ^ 4
end

--- Функция линии [4] (пароводяной смеси) в PT диаграмме от давления
---@param p_quarter number [МПа] Давление
---@return number [К] Температура
function bounds.saturationTemp_p(p)
    if p > consts.p4Max or p < consts.minP then -- Выход за границы
        return false
    end
    local k1 = 650.17534844798
    local p_quarter = p ^ 0.25
    local K1 = 1167.0521452767 * p_quarter ^ 2 + 12020.82470247 * p_quarter - 4823.2657361591
    local K2 = -724213.16703206 * p_quarter ^ 2 + -3232555.0322333 * p_quarter + 405113.40542057
    local K3 = 2 * K2 / (-K1 - sqrt(K1 ^ 2 - 4 * (p_quarter ^ 2 - 17.073846940092 * p_quarter + 14.91510861353) * K2))
    return (k1 + K3 - sqrt((k1 + K3) ^ 2 - 4 * (k1 * K3 - 0.23855557567849))) / 2
end

--- Функция для поиска давление левой границы пересечение зоны 2 (Перегретый пар)
--- с зонами 4 (Пароводяная смесь), 3 (Сверхкритическая смесь)) через температуру
---@param t number [K] Температура
---@return number [МПа] Давление
function bounds.borderPressure_t(t)
    if t <= consts.t3Min then -- пересечение с 4
        return bounds.saturationPressure_t(t)
    else -- пересечение с 3
        return 348.05185628969 - 1.1671859879975 * t + 1.0192970039326E-03 * t ^ 2
    end
end

--- Функция для поиска температуры левой границы пересечение зоны 2 (Перегретый пар)
--- с зонами 4 (Пароводяная смесь), 3 (Сверхкритическая смесь)) через давление
---@param p number [МПа] Давление
---@return number [K] Температура
function bounds.borderTemp_p(p)
    if p < consts.p3Min then -- пересечение с 4
        return bounds.saturationTemp_p(p)
    else -- пересечение с 3
        return 572.54459862746 + sqrt((p - 13.91883977887) / 1.0192970039326E-03)
    end
end


--- Определяет регион на диаграмме
---@param t number [K] Температура
---@param p number [МПа] Давление
---@return string
function bounds.region_t_p(t, p)
    if p < consts.minP or p > consts.maxP or t < consts.minT or t > consts.maxT then
        return 'error'
    end
    if p < bounds.borderPressure_t(t) and t > bounds.borderTemp_p(p) then
        return 'steam'
    else
        if p == bounds.saturationPressure_t(t) or t == bounds.saturationTemp_p(p) then
            return 'mix'
        else
            return t < consts.t3Min and 'water' or 'fluid'
        end
    end
end

return bounds
