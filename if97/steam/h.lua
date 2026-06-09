local gamma = require 'if97.steam.Gibbs'.gamma
local get_tau = require 'if97.steam.Gibbs'.get_tau
local R = require 'if97.consts'.R
local maxT = require 'if97.consts'.maxT
local minT = require 'if97.consts'.minT

local steam_s_tp = require 'if97.steam.s'.t_p
local water_s_tp = require 'if97.water.s'.t_p
local sTP = require 'if97.steam.s'.t_p
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
    local t = saturationTemp_p(p)
    local function binary_search(maxT, minT)
        local tR
        local sR
        for _ = 1, 20 do
            tR = (maxT + minT) / 2
            sR = steam_s_tp(tR, p)
            if sR > s then
                maxT = tR
            else
                minT = tR
            end
        end
        return h.t_p(tR, p)
    end
    if t then
        local s1 = water_s_tp(t, p)
        if s1 < s then
            local s2 = steam_s_tp(t, p)
            if s2 > s then
                local h1 = h.t_p(t, p)
                local h2 = water_h_tp(t, p)
                return (s - s1) * (h2 - h1) / (s2 - s1) + h1
            else
                return binary_search(maxT, t)
            end
        else
            return binary_search(t, minT)
        end
    else
        return binary_search(maxT, minT)
    end
end

return h
