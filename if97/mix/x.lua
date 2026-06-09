local saturationPressure_t = require 'if97.bounds'.saturationPressure_t
local saturationTemp_p = require 'if97.bounds'.saturationTemp_p
local water  = require 'if97.water'
local steam = require 'if97.steam'

local x = {}

function x.t_h(t, h)
    local p = saturationPressure_t(t)
    if p then
        local h1 = water.h.t_p(t, p)
        if h1 < h then
            local h2 = steam.h.t_p(t, p)
            if h2 > h then
                return (h - h1) / (h2 - h1)
            else
                return 1
            end
        else
            return 0
        end
    else
        return 1
    end
end

function x.p_h(p, h)
    local t = saturationTemp_p(p)
    if t then
        local h1 = water.h.t_p(t, p)
        if h1 < h then
            local h2 = steam.h.t_p(t, p)
            if h2 > h then
                return (h - h1) / (h2 - h1)
            else
                return 1
            end
        else
            return 0
        end
    else
        return 1
    end
end

function x.t_s(t, s)
    local p = saturationPressure_t(t)
    if p then
        local s1 = water.s.t_p(t, p)
        if s1 < s then
            local s2 = steam.s.t_p(t, p)
            if s2 > s then
                return (s - s1) / (s2 - s1)
            else
                return 1
            end
        else
            return 0
        end
    else
        return 1
    end
end

function x.p_s(p, s)
    local t = saturationTemp_p(p)
    if t then
        local s1 = water.s.t_p(t, p)
        if s1 < s then
            local s2 = steam.s.t_p(t, p)
            if s2 > s then
                return (s - s1) / (s2 - s1)
            else
                return 1
            end
        else
            return 0
        end
    else
        return 1
    end
end

return x