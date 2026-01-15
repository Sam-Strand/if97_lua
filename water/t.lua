local t = {}

function t.p_s(p, s)
    p = p * 1e-6
    local t = 0
    s = s / 1000 + 2
    for _, k in ipairs(kTps) do
        t = t + k[3] * p ^ k[1] * s ^ k[2]
    end
    return t
end

function t.p_h(p, i)
    p = p * 1e-6
    i = i / 2500000 + 1
    local t = 0
    for _, k in ipairs(kTph) do
        t = t + k[3] * p ^ k[1] * i ^ k[2]
    end
    return t
end

return t
