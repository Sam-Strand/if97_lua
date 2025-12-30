local mix = {}
mix.x = {
    t_h = function(t, i)
        local p = mt.saturationPressureT(t)
        if p then
            local h1 = water.i.t_p(t, p)
            if h1 < i then
                local h2 = steam.i.t_p(t, p)
                if h2 > i then
                    return (i - h1) / (h2 - h1)
                else
                    return 1
                end
            else
                return 0
            end
        else
            return 1
        end
    end,
    p_h = function(p, i)
        local t = mt.saturationTempP(p)
        if t then
            local h1 = if97.water.i.t_p(t, p)
            if h1 < i then
                local h2 = if97.steam.i.t_p(t, p)
                if h2 > i then
                    return (i - h1) / (h2 - h1)
                else
                    return 1
                end
            else
                return 0
            end
        else
            return 1
        end
    end,
    t_s = function(t, s)
        local p = mt.saturationPressureT(t)
        if p then
            local s1 = if97.water.s.t_p(t, p)
            if s1 < s then
                local s2 = if97.steam.s.t_p(t, p)
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
    end,
    p_s = function(p, s)
        local t = mt.saturationTempP(p)
        if t then
            local s1 = if97.water.s.t_p(t, p)
            if s1 < s then
                local s2 = if97.steam.s.t_p(t, p)
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
}
mix.i = {
    t_x = function(t, x)
        local p = mt.saturationPressureT(t)
        local h1 = if97.water.i.t_p(t, p)
        local h2 = if97.steam.i.t_p(t, p)
        return (h2 - h1) * x + h1
    end,
    p_x = function(p, x)
        local t = mt.saturationTempP(p)
        local h1 = if97.water.i.t_p(t, p)
        local h2 = if97.steam.i.t_p(t, p)
        return (h2 - h1) * x + h1
    end
}
mix.s = {
    t_x = function(t, x)
        local p = mt.saturationPressureT(t)
        local s1 = if97.water.s.t_p(t, p)
        local s2 = if97.steam.s.t_p(t, p)
        return (s2 - s1) * x + s1
    end,
    p_x = function(p, x)
        local t = mt.saturationTempP(p)
        local s1 = if97.water.s.t_p(t, p)
        local s2 = if97.steam.s.t_p(t, p)
        return (s2 - s1) * x + s1
    end
}

return mix
