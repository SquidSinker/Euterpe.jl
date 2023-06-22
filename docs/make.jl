using Euterpe
using Documenter

DocMeta.setdocmeta!(Euterpe, :DocTestSetup, :(using Euterpe); recursive=true)

makedocs(;
    modules=[Euterpe],
    authors="Avik Sengupta <avik@sengupta.net> and contributors",
    repo="https://github.com/SquidSinker/Euterpe.jl/blob/{commit}{path}#{line}",
    sitename="Euterpe.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
