local data = require 'if97.steam.data'

local t = {}

function t.p_s(p, s)
    if p > 4 then
        if s < 5.850 then
            local t = 0.0
            s = 2 - s / 925.1
            for _, k in ipairs(data.kT2cps) do
                t = t + k[3] * p ^ k[1] * s ^ k[2]
            end
            return t
        else
            s = 10 - s / 785.3
            local t = 0.0
            for _, k in ipairs(data.kT2bps) do
                t = t + k[3] * p ^ k[1] * s ^ k[2]
            end
            return t
        end
    else
        s = s / 2000 - 2
        local t = 0.0
        for _, k in ipairs(data.kT2aps) do
            t = t + k[3] * p ^ k[1] * s ^ k[2]
        end
        return t
    end
end

function t.p_h(p, h)
    if p > 4 then
        if 0.26526571908428E4 + ((p - 0.45257578905948E1) / 0.12809002730136E-3) ^ 0.5 < h then
            p = p - 2
            h = h / 2000 - 2.6
            local t = 0
            for _, k in ipairs(data.kT2bph) do
                t = t + k[3] * p ^ k[1] * h ^ k[2]
            end
            return t
        else
            p = p + 25
            h = h / 2000 - 1.8
            local t = 0
            for _, k in ipairs(data.kT2cph) do
                t = t + k[3] * p ^ k[1] * h ^ k[2]
            end
            return t
        end
    else
        h = h / 2000 - 2.1
        local t = 0
        for _, k in ipairs(data.kT2aph) do
            t = t + k[3] * p ^ k[1] * h ^ k[2]
        end
        return t
    end
end

return t
