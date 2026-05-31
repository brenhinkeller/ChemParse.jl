using ChemParse
using Test

@testset "ChemParse.jl" begin
    # Some example minerals and inorganic compounds
    @test parse_formula("SiO2") == Dict(:Si => 1.0, :O => 2.0) # Quartz
    @test parse_formula("CuSO4·5H2O") == Dict(:H => 10.0, :S => 1.0, :Cu => 1.0, :O => 9.0) # Chalcanthite
    @test parse_formula("(Fe,Mg)2SiO4") == Dict(:Fe => 1.0, :Mg => 1.0, :Si => 1.0, :O => 4.0) # Olivine
    @test parse_formula("(Ca,Na)(Mg,Fe,Al,Ti)(Si,Al)2O6") == Dict(:Al => 1.25, :Fe => 0.25, :Ti => 0.25, :Mg => 0.25, :Ca => 0.5, :Na => 0.5, :Si => 1.0, :O => 6.0) # Augite
    @test parse_formula("(Ca,Na)2−3(Mg,Fe,Al)5(Al,Si)8O22(OH,F)2") == Dict(:Al => 5.666666666666667, :Fe => 1.6666666666666667, :F => 1.0, :H => 1.0, :Mg => 1.6666666666666667, :Ca => 1.0, :Na => 1.0, :Si => 4.0, :O => 23.0) # Hornblende
    @test parse_formula("(Na,K,Ca)24(Na,Ca)4Ca4(Si,Al)48O96(SO4)4(SO3,CO3)2(OH,Cl)2(H2O,OH)4") == Dict(:C => 1.0, :Cl => 1.0, :Al => 24.0, :H => 7.0, :K => 8.0, :S => 5.0, :Ca => 14.0, :Na => 10.0, :O => 123.0, :Si => 24.0)
    @test parse_formula("Ca11(Ce,H2O,Ca)8Mg(Al,Fe)4(Mg,Ti,Fe3+)8[Si2O7]4[(SiO4)8(H4O4)2](OH)9") == Dict(:Al => 2.0, :Fe => 4.666666666666666, :H => 22.333333333333332, :Ti => 2.6666666666666665, :Mg => 3.6666666666666665, :Ca => 13.666666666666666, :Ce => 2.6666666666666665, :Si => 16.0, :O => 79.66666666666667)

    # Some example organic compounds
    @test parse_formula("CH3COOH") == Dict(:H => 4.0, :O => 2.0, :C => 2.0) # Acetic acid
    @test parse_formula("C5H6N2O2") == Dict(:N => 2.0, :H => 6.0, :O => 2.0, :C => 5.0) # Thymine
    @test parse_formula("C11H12N2O2") == Dict(:N => 2.0, :H => 12.0, :O => 2.0, :C => 11.0) # Tryptophan

    # Some example coordination compounds
    @test parse_formula("[Ru((C5H4N)2)3]Cl2·6H2O") == Dict(:Cl => 2.0, :N => 6.0, :Ru => 1.0, :H => 36.0, :O => 6.0, :C => 30.0) # Tris(bipyridine)ruthenium(II) chloride
    @test parse_formula("[(Co(OH2)5)2]Cl4") == Dict(:Cl => 4.0, :H => 20.0, :Co => 2.0, :O => 10.0)

end
