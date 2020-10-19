#! load_library("dom")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.12/ace.min.js")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.12/theme-monokai.min.js")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/marked/1.1.1/marked.min.js")

# UI
style <- "width: 48%; height:800px; margin:10px;"
iframe_style <- "width:100%; height:100%; border:none;"

dom("div", list(id = "container", style = "display:flex;")) %>% append_doms(
    dom("div", list(id = "editor", style = style %+% "font-size: 20px;")),
    dom("div", list(id = "renderer", style = style)) %>% append_doms(
        # Need one extra iframe for caching to avoid flickering on update
        dom("iframe", list(id = "cache_1", srcdoc = "", style = iframe_style)),
        dom("iframe", list(id = "cache_2", srcdoc = "", style = iframe_style %+% "display: none;")))
) %>%
    print_dom()

# Server
editor <- ace::edit("editor", list(mode = "ace/mode/markdown"))
editor$setOptions(list(
    wrap = TRUE,
    indentedSoftWrap = FALSE,
    showLineNumbers = FALSE,
    theme = "ace/theme/monokai"
))

is_hidden <- function(x) {
    return(x$style$display == "none")
}

# Re-render every time the input is changed / updated
editor$session$on('change', function(delta) {
    declare (dom_str, display_1, display_2, cache, current)
    dom_str <- editor$getValue() %>% marked() %>% render()

    display_1 <- select_dom("#cache_1")
    display_2 <- select_dom("#cache_2")
    cache <- ifelse(is_hidden(display_1), display_1, display_2)
    current <- ifelse(is_hidden(display_1), display_2, display_1)
    cache$onload <- function() {
        current$style$display <- "none"
        cache$style$display <- "block"
    }
    cache$srcdoc <- dom_str
})

render <- function(dom_str) {
    declare (head, body)
    head <- dom("head") %>%
        append_doms(
            # Add LaTeX fonts
            dom("link", list(rel = "stylesheet",
                             href = "https://cdn.jsdelivr.net/gh/aaaakshat/cm-web-fonts@latest/fonts.css")),
            dom("style", list(innerText = 'body {font-family: "Computer Modern Serif", sans-serif;}')),
            # Add MathJax
            dom("script", list(src="https://polyfill.io/v3/polyfill.min.js?features=es6")),
            dom("script", list(innerText = "MathJax = {tex: {inlineMath: [['$', '$']]}};")),
            dom("script", list(id = "MathJax-script", async = "async",
                               src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"))
        )
    body <- dom("body", list(innerHTML = dom_str))
    return(head$outerHTML %+% body$outerHTML)
}
