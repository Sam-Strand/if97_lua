local R = require 'if97.consts'.R
local Gibbs = require 'if97.water.Gibbs'
local s_t_p = require 'if97.water.s'.t_p
local consts = require 'if97.consts'
local bounds = require 'if97.bounds'

local h = {}

function h.t_p(t, p)
    local pi = Gibbs.get_pi(p)
    local tau = Gibbs.get_tau(t)
    local gamma_tau = Gibbs.gamma:tau(pi, tau)
    return 639.675036 * gamma_tau
end

---@param t number температура в K
---@param s number энтропия в кДж/(кг⋅K)
---@param p_guess number|nil начальное приближение давления в МПа (опционально)
---@return number|nil энтальпия в кДж/кг или nil если не найдена
function h.t_s(t, s, p_guess)
    -- Определяем границы давления для поиска
    local p_min, p_max

    -- Регион 1: от давления насыщения до 100 МПа
    local p_sat = bounds.saturationPressure_t(t)
    if not p_sat then
        p_min = consts.minP
    else
        p_min = p_sat
    end
    p_max = consts.maxP

    local function delta_s_t_p(p)
        return s_t_p(t, p) - s
    end

    -- Выбираем начальное приближение
    local p1, p2 = p_min, p_max
    local p_start = p_guess or ((p_min + p_max) / 2)

    local f1 = delta_s_t_p(p1)
    local f2 = delta_s_t_p(p2)
    -- Если знаки одинаковые, ищем интервал с разными знаками
    local iter = 0
    local max_iter = 50

    while f1 * f2 > 0 and iter < max_iter do
        if math.abs(f1) < math.abs(f2) then
            p1 = p1 * 0.7
            if p1 < p_min then
                p1 = p_min
                f1 = delta_s_t_p(p1)
                if f1 * f2 < 0 then break end
                p1 = p_min * 1.1
                if p1 > p_max then p1 = p_max * 0.9 end
            end
            f1 = delta_s_t_p(p1)
        else
            p2 = p2 * 1.3
            if p2 > p_max then
                p2 = p_max
                f2 = delta_s_t_p(p2)
                if f1 * f2 < 0 then break end
                p2 = p_max * 0.9
                if p2 < p_min then p2 = p_min * 1.1 end
            end
            f2 = delta_s_t_p(p2)
        end
        iter = iter + 1
    end

    -- Если знаки всё ещё одинаковые, возвращаем nil
    if f1 * f2 >= 0 then
        return nil
    end

    -- Метод секущей для уточнения корня
    local p = p2
    for i = 1, 40 do
        if math.abs(f2 - f1) < 1e-15 then break end
        p = p2 - f2 * (p2 - p1) / (f2 - f1)

        if p < p_min then p = p_min end
        if p > p_max then p = p_max end

        local f = delta_s_t_p(p)

        if math.abs(f) < 1e-9 then
            p2 = p
            break
        end

        p1 = p2
        f1 = f2
        p2 = p
        f2 = f
    end

    -- Вычисляем энтальпию по найденному давлению
    return h.t_p(t, p2)
end

return h
