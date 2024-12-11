set shell := ["nu", "-c"]

default:
    stack build
    # stack run
    /Users/tsukimizake/openscad-proj/.stack-work/install/aarch64-osx/af2f735c875ccf31d38a50cbc7eef92885da4c775f6f51a65dc1e762cc347e2d/9.8.2/bin/openscad-proj-exe

test:
    stack test

watch:
    watch --debounce-ms 1000 . --glob=**/*.hs {|| just default }

new_module name:
    open app/template.hs | str replace --all "TEMPLATE" {{ name }} | save app/{{ name }}.hs
    open app/Main.hs | lines | insert 2 "import {{ name }}" | append "  {{ name }}.run" | collect {|| save -f app/Main.hs}

set_module:
    source set_module.nu

gc:
    ls | where name =~ ".scad$" or name =~ ".stl$" or name =~ ".3mf$" | get name | each {|| rm $in}
