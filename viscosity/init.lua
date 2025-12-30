local u

local data = require 'data.dataViscosity'
local VHi, Vi, Vj, VHij = data.VHi, data.Vi, data.Vj, data.VHij
u = function(tau, delta)
    local mu0 = 0
    for i = 1, 4 do
        mu0 = mu0 + VHi[i] / tau ^ (i - 1)
    end
    local mu1 = 0
    for i = 1, 21 do
        mu1 = mu1 + VHij[i] * (1 / tau - 1) ^ Vi[i] * (delta - 1) ^ Vj[i]
    end
    return tau ^ 0.5 / mu0 * math.exp(delta * mu1) * 0.0001
end

return u
