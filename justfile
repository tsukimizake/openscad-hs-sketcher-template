set shell := ["nu", "-c"]

default:
    stack build
    stack run

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
