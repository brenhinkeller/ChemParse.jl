# ChemParse

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://brenhinkeller.github.io/ChemParse.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://brenhinkeller.github.io/ChemParse.jl/dev/)
[![Build Status](https://github.com/brenhinkeller/ChemParse.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/brenhinkeller/ChemParse.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/brenhinkeller/ChemParse.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/brenhinkeller/ChemParse.jl)

Simple parsing of chemical formulae into Julia dictionaries, 
inspired by the Python package [chemparse](https://pypi.org/project/chemparse/)
```
julia> parse_formula("SiO2")
Dict(:Si => 1.0, :O => 2.0)
```
Supports parentheses and square brackets, up to at least three levels of nesting each
```
julia> parse_formula("[Ru((C5H4N)2)3]Cl2·6H2O")
Dict(:Ru => 1.0, :N => 6.0, :Cl => 2.0, :H => 36.0, :O => 6.0, :C => 30.0)
```
Supports decimal subscripts
```
julia> parse_formula("Cu0.2Al0.8")
Dict(:Al => 1.0, :Cu => 0.2)
```
Sites containing an unspecified mixture of atoms will be treated as an equal mixture of each
```
julia> parse_formula("(Fe,Mg)SiO3")
Dict(:Fe => 0.5, :Mg => 0.5, :Si => 1.0, :O => 3.0)
```
Variable subscripts (e.g. "Cu1-xAlx") are not supported generally will not be parsed correctly; such formulae must be restated either with explicit decimal subscripts (e.g. "Cu0.2Al0.8") or as mixtures (e.g. "(Cu,Al)")