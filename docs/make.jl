using ChemParse
using Documenter

DocMeta.setdocmeta!(ChemParse, :DocTestSetup, :(using ChemParse); recursive=true)

makedocs(;
    modules=[ChemParse],
    authors="C. Brenhin Keller <cbkeller@dartmouth.edu> and contributors",
    sitename="ChemParse.jl",
    format=Documenter.HTML(;
        canonical="https://brenhinkeller.github.io/ChemParse.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/brenhinkeller/ChemParse.jl",
    devbranch="main",
)
