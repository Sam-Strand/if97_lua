--[[
steam.cv = {
    t_p = function(t, p)
        local tf = 540 / t
        return R *
            (-tf ^ 2 * JF(t, p, 2) + (JF(t, p, 4) - tf * JF(t, p, 3)) ^ 2 / JF(t, p, 5))
    end
}
--]]