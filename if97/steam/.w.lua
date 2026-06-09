--[[
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
--]]