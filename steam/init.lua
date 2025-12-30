local steam = {}
local data = require 'steam.data'
local N0, J0, Nr, Ir, Jr, kT2aps, kT2bps, kT2cps, kT2aph, kT2bph, kT2cph =
    data.N02, data.J02, data.Nr2, data.Ir2, data.Jr2, data.kT2aps, data.kT2bps, data.kT2cps, data.kT2aph, data
    .kT2bph, data.kT2cph
local case = {
    --[1] γ0
    function(tau, pi, energy)
        energy = math.log(pi)
        for i = 1, 9 do
            energy = energy + N0[i] * tau ^ J0[i]
        end
        return energy
    end,
    --[2] γ0_π
    function(tau, pi)
        return 1 / pi
    end,
    --[3] γ0_ππ
    function(tau, pi)
        return -1 / pi ^ 2
    end,
    --[4] γ0_τ
    function(tau, pi, energy)
        for i = 1, 9 do
            energy = energy + N0[i] * J0[i] * tau ^ (J0[i] - 1)
        end
        return energy
    end,
    --[5] γ0_ττ
    function(tau, pi, energy)
        for i = 1, 9 do
            energy = energy + N0[i] * J0[i] * (J0[i] - 1) * tau ^ (J0[i] - 2)
        end
        return energy
    end,
    --[6] γr
    function(tau, pi, energy)
        for i = 1, 43 do
            energy = energy + Nr[i] * pi ^ Ir[i] * (tau - 0.5) ^ Jr[i]
        end
        return energy
    end,
    --[7] γr_π
    function(tau, pi, energy)
        for i = 1, 43 do
            energy = energy + Nr[i] * Ir[i] * pi ^ (Ir[i] - 1) * (tau - 0.5) ^ Jr[i]
        end
        return energy
    end,
    --[8] γr_ππ
    function(tau, pi, energy)
        for i = 1, 43 do
            energy = energy +
                Nr[i] * Ir[i] * (Ir[i] - 1) * pi ^ (Ir[i] - 2) * (tau - 0.5) ^ (Jr[i])
        end
        return energy
    end,
    --[9] γr_τ
    function(tau, pi, energy)
        for i = 1, 43 do
            energy = energy +
                Nr[i] * pi ^ Ir[i] * Jr[i] * (tau - 0.5) ^ (Jr[i] - 1)
        end
        return energy
    end,
    --[10] γr_ττ
    function(tau, pi, energy)
        for i = 1, 43 do
            energy = energy +
                Nr[i] * pi ^ Ir[i] * Jr[i] * (Jr[i] - 1) * (tau - 0.5) ^ (Jr[i] - 2)
        end
        return energy
    end,
    --[11] γπτ
    function(tau, pi, energy)
        for i = 1, 43 do
            energy = energy +
                Nr[i] * Ir[i] * pi ^ (Ir[i] - 1) * Jr[i] * (tau - 0.5) ^ (Jr[i] - 1)
        end
        return energy
    end,
}
local function JF(tau, pi, trigger)
    return case[trigger](tau, pi, 0)
end
--t = t + CtoK
--local tau = 540 / (t + CtoK)
--local pi = p * 1e-6


steam.t = {
    p_s = function(p, s)
        p = p * 1e-6
        if p > 4 then
            if s < 5850 then
                local t = 0
                s = 2 - s / 925.1
                for _, k in ipairs(data.kT2cps) do
                    t = t + k[3] * p ^ k[1] * s ^ k[2]
                end
                return t
            else
                s = 10 - s / 785.3
                local t = 0 -- Начальное значение температуры
                for _, k in ipairs(data.kT2bps) do
                    t = t + k[3] * p ^ k[1] * s ^ k[2]
                end
                return t
            end
        else
            s = s / 2000 - 2
            local t = 0
            for _, k in ipairs(data.kT2aps) do
                t = t + k[3] * p ^ k[1] * s ^ k[2]
            end
            return t
        end
    end,
    p_i = function(p, i)
        p = p * 1e-6
        if p > 4 then
            if (0.26526571908428E4 + ((p - 0.45257578905948E1) / 0.12809002730136E-3) ^ 0.5) * 1000 < i then
                p = p - 2
                i = i / 2000000 - 2.6
                local t = 0
                for _, k in ipairs(data.kT2bph) do
                    t = t + k[3] * p ^ k[1] * i ^ k[2]
                end
                return t
            else
                p = p + 25
                i = i / 2000000 - 1.8
                local t = 0
                for _, k in ipairs(data.kT2cph) do
                    t = t + k[3] * p ^ k[1] * i ^ k[2]
                end
                return t
            end
        else
            i = i / 2000000 - 2.1
            local t = 0
            for _, k in ipairs(data.kT2aph) do
                t = t + k[3] * p ^ k[1] * i ^ k[2]
            end
            return t
        end
    end
}
steam.i = {
    t_p = function(t, p)
        t = t + CtoK
        local tau = 540 / t
        local pi = p * 1e-6
        return R * t * tau * (JF(tau, pi, 4) + JF(tau, pi, 9))
    end
}
steam.w = {
    t_p = function(t, p)
        t = t + CtoK
        local tau = 540 / t
        local pi = p * 1e-6
        return (
            R * t * (
                (1 + 2 * pi * JF(tau, pi, 7) + pi ^ 2 * JF(tau, pi, 7)) /
                (
                    1 - pi ^ 2 * JF(tau, pi, 8) + (1 + pi * JF(tau, pi, 7) - tau * pi * JF(tau, pi, 11)) ^ 2 /
                    (tau ^ 2 * (JF(tau, pi, 5) + JF(tau, pi, 10)))
                )
            )
        ) ^ 0.5
    end
}
steam.v = {
    t_p = function(t, p)
        return t * R * JF(t, p, 4) / 1000000
    end
}
steam.cv = {
    t_p = function(t, p)
        local tf = 540 / t
        return R *
            (-tf ^ 2 * JF(t, p, 2) + (JF(t, p, 4) - tf * JF(t, p, 3)) ^ 2 / JF(t, p, 5))
    end
}
steam.cp = {
    t_p = function(t, p)
        return -R * (540 / t) ^ 2 * JF(t, p, 2)
    end
}
steam.s = {
    t_p = function(t, p)
        local tau = 540 / (t + CtoK)
        local pi = p * 1e-6
        return R * (tau * JF(tau, pi, 2) - JF(tau, pi, 1))
    end
}
steam.rho = {
    t_p = function(t, p)
        t = t + CtoK
        local tau = 540 / t
        local pi = p * 1e-6
        return p / (t * R * pi * JF(tau, pi, 5))
    end
}
steam.u = {
    t_rho = u
}

return steam
