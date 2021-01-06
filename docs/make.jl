using CometLogger
using Documenter

DocMeta.setdocmeta!(CometLogger, :DocTestSetup, :(using CometLogger); recursive=true)

makedocs(;
    modules=[CometLogger],
    authors="rejuvyesh <mail@rejuvyesh.com> and contributors",
    repo="https://github.com/rejuvyesh/CometLogger.jl/blob/{commit}{path}#{line}",
    sitename="CometLogger.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://rejuvyesh.github.io/CometLogger.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/rejuvyesh/CometLogger.jl",
)
