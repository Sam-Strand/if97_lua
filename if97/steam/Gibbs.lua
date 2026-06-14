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
local n0 = { -0.96927686500217E+01, 0.10086655968018E+02, -0.56087911283020E-02, 0.71452738081455E-01,
      -0.40710498223928E+00, 0.14240819171444E+01, -0.43839511319450E+01, -0.28408632460772E+00, 0.21268463753307E-01 }

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

local nr = {     -0.0017731742473212999, -0.017834862292357999,
-0.045996013696365003, -0.057581259083432, -0.050325278727930002,
    -3.3032641670203e-05, -0.00018948987516315, -0.0039392777243355001,
    -0.043797295650572998, -2.6674547914087001e-05,
    2.0481737692308999e-08, 4.3870667284435001e-07,
    -3.2277677238570002e-05, -0.0015033924542148, -0.040668253562648998,
    -7.8847309559367001e-10, 1.2790717852285001e-08, 4.8225372718507002e-07, 2.2922076337661001e-06,
    -1.6714766451061001e-11,
    -0.0021171472321354998, -23.895741934103999,
    -5.9059564324270004e-18, -1.2621808899101e-06, -0.038946842435739003,
    1.1256211360459e-11, -8.2311340897998004, 1.9809712802088e-08, 1.0406965210174e-19,
    -1.0234747095929e-13, -1.0018179379511e-09,
    -8.0882908646984998e-11, 0.10693031879409,
    -0.33662250574170999, 8.9185845355420999e-25, 3.0629316876231997e-13,
    -4.2002467698208001e-06, -5.9056029685639003e-26, 3.7826947613457002e-06,
    -1.2768608934681e-15, 7.3087610595061e-29,
    5.5414715350778001e-17, -9.4369707241209998e-07 }
local Ir = { 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 5, 6, 6, 6, 7,
     7, 7, 8, 8, 9, 10, 10, 10, 16, 16, 18, 20, 20, 20, 21, 22, 23, 24, 24, 24 }
local Jr = { 0, 1, 2, 3, 6, 1, 2, 4, 7, 36, 0, 1, 3, 6, 35, 1, 2, 3, 7, 3, 16, 35, 0,
     11, 25, 8, 36, 13, 4, 10, 14, 29, 50, 57, 20, 35, 48, 21, 53, 39, 26, 40, 58 }

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
