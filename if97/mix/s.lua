local saturationPressure_t = require 'if97.bounds'.saturationPressure_t
local saturationTemp_p = require 'if97.bounds'.saturationTemp_p
local water  = require 'if97.water'
local steam = require 'if97.steam'

local s = {}

function s.t_x(t, x)
    local p = saturationPressure_t(t)
    local s1 = water.s.t_p(t, p)
    local s2 = steam.s.t_p(t, p)
    return (s2 - s1) * x + s1
end

function s.p_x(p, x)
    local t = saturationTemp_p(p)
    local s1 = water.s.t_p(t, p)
    local s2 = steam.s.t_p(t, p)
    return (s2 - s1) * x + s1
end

return s
