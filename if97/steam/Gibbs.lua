local data = require 'if97.steam.data'

local gamma = {}

-- Вспомогательные функции
local function get_tau(t)
    return 540.0 / t
end

--[[
Часть идеального газ γ^0 безразмерной свободной энергии Гиббса в идеальном газе и ее производные
--]]

local J0 = { 0, 1, -5, -4, -3, -2, -1, 2, 3 }
local n0 = { -9.6927686500217, 10.086655968018, -0.005608791128302, 0.071452738081455, -0.40710498223928,
    1.4240819171444, -4.383951131945, -0.28408632460772, 0.021268463753307 }

    --[1] γ⁰ (полная)
function gamma:ideal(pi, tau)
    local energy = math.log(pi)
    for i = 1, 9 do
        energy = energy + n0[i] * tau ^ J0[i]
    end
    return energy
end

--[2] γ⁰_π
function gamma:ideal_pi(pi)
    return 1 / pi
end

--[3] γ⁰_ππ
function gamma:ideal_pi_pi(pi)
    return -1 / pi ^ 2
end

--[4] γ⁰_τ
function gamma:ideal_tau(tau)
    local energy = 0.0
    for i = 1, 9 do
        energy = energy + n0[i] * J0[i] * tau ^ (J0[i] - 1)
    end
    return energy
end

--[5] γ⁰_ττ
function gamma:ideal_tau_tau(tau)
    local energy = 0.0
    for i = 1, 9 do
        energy = energy + n0[i] * J0[i] * (J0[i] - 1) * tau ^ (J0[i] - 2)
    end
    return energy
end

--[[
Остаточная часть γ^r безразмерной свободной энергии Гиббса в идеальном газе и ее производные
--]]

local nr = { -1.7731742473213E-03, -0.017834862292358, -0.045996013696365, -0.057581259083432, -0.05032527872793,
    -3.3032641670203E-05, -1.8948987516315E-04, -3.9392777243355E-03, -0.043797295650573, -2.6674547914087E-05,
    2.0481737692309E-08, 4.3870667284435E-07, -3.227767723857E-05, -1.5033924542148E-03, -0.040668253562649,
    -7.8847309559367E-10, 1.2790717852285E-08, 4.8225372718507E-07, 2.2922076337661E-06, -1.6714766451061E-11,
    -2.1171472321355E-03, -23.895741934104, -5.905956432427E-18, -1.2621808899101E-06, -0.038946842435739,
    1.1256211360459E-11, -0.082311340897998, 1.9809712802088E-08, 1.0406965210174E-19, -1.0234747095929E-13,
    -1.0018179379511E-09, -8.0882908646985E-11, 0.10693031879409, -0.33662250574171, 8.9185845355421E-25,
    3.0629316876232E-13, -4.2002467698208E-06, -5.9056029685639E-26, 3.7826947613457E-06, -1.2768608934681E-15,
    7.3087610595061E-29, 5.5414715350778E-17, -9.436970724121E-07 }
local Ir = { 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 5, 6, 6, 6, 7, 7, 7, 8, 8, 9, 10, 10, 10, 16, 16, 18,
    20, 20, 20, 21, 22, 23, 24, 24, 24 }
local Jr = { 0, 1, 2, 3, 6, 1, 2, 4, 7, 36, 0, 1, 3, 6, 35, 1, 2, 3, 7, 3, 16, 35, 0, 11, 25, 8, 36, 13, 4, 10, 14, 29,
    50, 57, 20, 35, 48, 21, 53, 39, 26, 40, 58 }

--[6] γʳ
function gamma:residual(pi, tau)
    local energy = 0.0
    for i = 1, 43 do
        energy = energy + nr[i] * pi ^ Ir[i] * (tau - 0.5) ^ Jr[i]
    end
    return energy
end

--[7] γʳ_π
function gamma:residual_pi(pi, tau)
    local energy = 0.0
    for i = 1, 43 do
        energy = energy + nr[i] * Ir[i] * pi ^ (Ir[i] - 1) * (tau - 0.5) ^ Jr[i]
    end
    return energy
end

--[8] γʳ_ππ
function gamma:residual_pi_pi(pi, tau)
    local energy = 0.0
    for i = 1, 43 do
        energy = energy +
            nr[i] * Ir[i] * (Ir[i] - 1) * pi ^ (Ir[i] - 2) * (tau - 0.5) ^ Jr[i]
    end
    return energy
end

--[9] γʳ_τ
function gamma:residual_tau(pi, tau)
    local energy = 0.0
    for i = 1, 43 do
        energy = energy + nr[i] * pi ^ Ir[i] * Jr[i] * (tau - 0.5) ^ (Jr[i] - 1)
    end
    return energy
end

--[10] γʳ_ττ
function gamma:residual_tau_tau(pi, tau)
    local energy = 0.0
    for i = 1, 43 do
        energy = energy +
            nr[i] * pi ^ Ir[i] * Jr[i] * (Jr[i] - 1) * (tau - 0.5) ^ (Jr[i] - 2)
    end
    return energy
end

--[11] γʳ_πτ
function gamma:residual_pi_tau(pi, tau)
    local energy = 0.0
    for i = 1, 43 do
        energy = energy +
            nr[i] * Ir[i] * pi ^ (Ir[i] - 1) * Jr[i] * (tau - 0.5) ^ (Jr[i] - 1)
    end
    return energy
end

local gamma_mt = {
    __call = gamma.__call,
    __index = gamma
}

return {
    gamma = setmetatable({}, gamma_mt),
    get_tau = get_tau
}
