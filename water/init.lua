
local data, kTps, kTph = require 'data.dataReg1'

local case = {
    --[1] γ
    function(t, p, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * p ^ k[1] * t ^ k[2]
        end
        return energy
    end,
    --[2] γ_τ
    function(t, p, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * k[2] * p ^ k[1] * t ^ (k[2] - 1)
        end
        return energy
    end,
    --[3] γ_ττ
    function(t, p, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * k[2] * (k[2] - 1) * p ^ k[1] *
                t ^ (k[2] - 2)
        end
        return energy
    end,
    --[4] γ_πτ
    function(t, p, energy)
        for _, k in ipairs(data) do
            energy = energy - k[3] * k[1] * k[2] * p ^ (k[1] - 1) *
                t ^ (k[2] - 1)
        end
        return energy
    end,
    --[5] γ_πτ
    function(t, p, energy)
        for _, k in ipairs(data) do
            energy = energy - k[3] * k[1] * p ^ (k[1] - 1) * t ^ k[2]
        end
        return energy
    end,
    --[6] γ_πτ
    function(t, p, energy)
        for _, k in ipairs(data) do
            energy = energy + k[3] * k[1] * (k[1] - 1) * p ^ (k[1] - 2) *
                t ^ k[2]
        end
        return energy
    end
}
local function JF(t, p, trigger)
    p = 7.1 - p / (16.53 * 1e6)
    t = 1386 / t - 1.222
    return case[trigger + 1](t, p, 0)
end

local water = {}

water.t = {
    p_s = function(p, s)
        p = p * 1e-6
        local t = 0
        s = s / 1000 + 2
        for _, k in ipairs(kTps) do
            t = t + k[3] * p ^ k[1] * s ^ k[2]
        end
        return t
    end,
    p_h = function(p, i)
        p = p * 1e-6
        i = i / 2500000 + 1
        local t = 0
        for _, k in ipairs(kTph) do
            t = t + k[3] * p ^ k[1] * i ^ k[2]
        end
        return t
    end
}
water.i = {
    t_p = function(t, p)
        return R * 1386 * JF(t, p, 1)
    end
}
water.w = {
    t_p = function(t, p)
        local tf = 1386 / t
        return math.sqrt(R * t * JF(t, p, 4) ^ 2 /
            ((JF(t, p, 4) - tf * JF(t, p, 3)) ^ 2 / (tf ^ 2 * JF(t, p, 2)) - JF(t, p, 5)))
    end
}
water.v = {
    t_p = function(t, p)
        return t * R * JF(t, p, 4) / 16530000
    end
}
water.cv = {
    t_p = function(t, p)
        local tf = 1386 / t
        return R *
            (-tf ^ 2 * JF(t, p, 2) + (JF(t, p, 4) - tf * JF(t, p, 3)) ^ 2 / JF(t, p, 5))
    end
}
water.cp = {
    t_p = function(t, p)
        return -R * (1386 / t) ^ 2 * JF(t, p, 2)
    end
}
water.s = {
    t_p = function(t, p)
        return R * (1386 / t * JF(t, p, 1) - JF(t, p, 0))
    end
}
water.rho = {
    t_p = function(t, p)
        return 1 / (t * R * JF(t, p, 4) / 16530000)
    end
}
water.u = {
    t_rho = u
}

return water
