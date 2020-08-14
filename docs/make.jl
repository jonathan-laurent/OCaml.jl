using Documenter

ENV["OCAML_LIB_DIR"] = "generated"
using OCaml

const PRETTY_URLS = get(ENV, "CI", nothing) == "true"

makedocs(
  sitename = "OCaml.jl",
  authors="Jonathan Laurent",
  format = Documenter.HTML(prettyurls=PRETTY_URLS),
  pages = [
    "Home" => "index.md",
    "Example" => "example.md",
    "How this works" => "how.md"
  ],
  repo="https://github.com/jonathan-laurent/OCaml.jl/blob/{commit}{path}#L{line}"
)

deploydocs(;
  repo="github.com/jonathan-laurent/OCaml.jl",
)
