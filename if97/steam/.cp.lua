--[[
steam.cp = {
    t_p = function(t, p)
        return -R * (540 / t) ^ 2 * JF(t, p, 2)
    end
}
--]]