local saturationPressure_t = require 'if97.bounds'.saturationPressure_t
local saturationTemp_p = require 'if97.bounds'.saturationTemp_p
local water  = require 'if97.water'
local steam = require 'if97.steam'

local h = {}

function h.t_x(t, x)
    local p = saturationPressure_t(t)
    local h1 = water.h.t_p(t, p)
    local h2 = steam.h.t_p(t, p)
    return (h2 - h1) * x + h1
end

function h.p_x(p, x)
    local t = saturationTemp_p(p)
    local h1 = water.h.t_p(t, p)
    local h2 = steam.h.t_p(t, p)
    return (h2 - h1) * x + h1
end

return h
