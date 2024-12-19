# What's this?
project template for [openscad-hs-sketcher](https://github.com/tsukimizake/openscad-hs-sketcher)

It requires [haskell-stack](https://docs.haskellstack.org/en/stable/), and utilitiy commands in justfile requires [just](https://github.com/casey/just) and [nushell](https://github.com/nushell/nushell)

# How to use

This command might work.
```
git clone https://github.com/tsukimizake/openscad-hs-sketcher-template
stack build
```

If it errors like this,
```
Error: [S-636]
       Stack looks for packages in the directories configured in the packages and extra-deps fields defined in its project-level configuration file (usually stack.yaml). The current entry points to
       /Users/tsukimizake/openscad-hs-sketcher-template/openscad-hs-sketcher/ but no Cabal file or package.yaml could be found there.
```

Retry `stack build` after `git submodule update --init` .
