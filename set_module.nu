#!/usr/bin/env nu
let modname = ls app/ 
  | get name 
  | each {|| str trim } 
  | to text 
  | fzf
  | str trim
  | path basename
  | split row "." | get 0

open app/Main.hs
  | lines
  | each {|| str replace --regex ".*\\.run" $"  ($modname).run" }
  | collect {|| save -f app/Main.hs}

