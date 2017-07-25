# pandoc-slide-filter

Collection of pandoc-filters for our reveal-js slides.

## How to build

1. [install stack](https://haskell-lang.org/get-started) and do a `stack setup`
2. clone this repository
3. do a `stack build` or `stack install`

`stack build` builds the files but leaves them in `.stack-work/dist/$OS/Cabal-$Cabalversion/build/$exe-dir/$exe-name`.
`stack install` installs them into `$HOME/.local/bin` (or similar on other OSes).

## What is what?

### Media

support for

- `![](foo.aac){#audio}`
- `![](foo.mp4){#video}`
- `![](foo.png){#img}`
- `![](foo.svg){#svg}`
- `![](foo.html){#demo}`

### Styling

support for

- `<div id="col" .w50></div>`
- better code-blocks
- `<div class="fragment"></div>` region revealed after click
- `<div class="frame"></div>` region revealed and then vanishes on next click
- `[]{.fragment}` same for inline-objects
- `[]{.frame}` same for inline-objects
- `[]{#hspace width=100px}` manual spacing
- `[]{#vspace height=100px}` manual spacing

### Quiz

support for

- `[answer-text](tooltip){.answer .right width=100px}`
- `[answer-text](tooltip){.answer .wrong}`

Note: Tooltip is broken for this syntax, so this might be subject to change.

### Clean

Small filter for cleaning empty Blocks if they get generated.
