local data = require 'if97.water.data'

local t = {}

function t.p_s(p, s)
    p = p
    local t = 0
    s = s + 2
    for _, k in ipairs(data.kTps) do
        t = t + k[3] * p ^ k[1] * s ^ k[2]
    end
    return t
end

function t.p_h(p, h)
    p = p
    h = h / 2500 + 1
    local t = 0
    for _, k in ipairs(data.kTph) do
        t = t + k[3] * p ^ k[1] * h ^ k[2]
    end
    return t
end

return t
