local gamma = require 'if97.steam.Gibbs'.gamma
local get_tau = require 'if97.steam.Gibbs'.get_tau
local R = require 'if97.consts'.R
local maxT = require 'if97.consts'.maxT
local minT = require 'if97.consts'.minT

local steam_s_tp = require 'if97.steam.s'.t_p
local water_s_tp = require 'if97.water.s'.t_p
local water_h_tp = require 'if97.water.h'.t_p
local saturationTemp_p = require 'if97.bounds'.saturationTemp_p

local h = {}

function h.t_p(t, p)
    local tau = get_tau(t)
    local pi = p
    local gamma_0_tau = gamma:ideal_tau(tau)
    local gamma_r_tau = gamma:residual_tau(pi, tau)
    return R * t * tau * (gamma_0_tau + gamma_r_tau)
end

function h.p_s(p, s)
    local t_sat = saturationTemp_p(p)

    local function binary_search(maxT, minT, region)
        local tR
        local sR
        for _ = 1, 50 do
            tR = (maxT + minT) / 2
            -- Выбираем функцию в зависимости от региона
            if region == 'water' then
                sR = water_s_tp(tR, p)
            elseif region == 'mix' then
                -- Для влажного пара используем энтропию насыщенного пара
                sR = steam_s_tp(tR, p)
            elseif region == 'steam' then
                sR = steam_s_tp(tR, p)
            end

            print('не ориг', sR)
            if sR > s then
                maxT = tR
            else
                minT = tR
            end
        end
        return h.t_p(tR, p)
    end

    if t_sat then
        local s_f = water_s_tp(t_sat, p)
        local s_g = steam_s_tp(t_sat, p)

        if s_f < s and s < s_g then
            -- Регион 4: влажный пар (интерполяция)
            print('тут 1 - влажный пар')
            local h_f = water_h_tp(t_sat, p)
            local h_g = h.t_p(t_sat, p)
            local x = (s - s_f) / (s_g - s_f)
            return h_f + x * (h_g - h_f)
        elseif s >= s_g then
            -- Регион 3: перегретый пар
            print('тут 2 - перегретый пар')
            return binary_search(maxT, t_sat, 'steam')
        else -- s <= s_f
            -- Регион 1: вода
            print('тут 3 - вода')
            return binary_search(t_sat, minT, 'water')
        end
    else
        -- Давление выше критического
        print('тут 4 - сверхкритический')
        return binary_search(maxT, minT, 'fluid')
    end
end

return h
