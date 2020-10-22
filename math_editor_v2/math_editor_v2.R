# Built with sketch v1.0.4, compiled with basic_rules
# ===================================================

#! load_library("dom")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.12/ace.min.js")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.12/theme-monokai.min.js")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/marked/1.1.1/marked.min.js")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/fontawesome.min.css")
#! load_script("https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/solid.min.css")
#! load_script("ui.R", rules = basic_rules())

# Server
# Editor set-up ----
editor <- ace::edit(
    "editor",
    list(mode = "ace/mode/markdown")
)
editor$setOptions(list(
    wrap = TRUE,
    indentedSoftWrap = FALSE,
    showLineNumbers = FALSE,
    theme = "ace/theme/monokai"
))

# Hotkey ----
editor$commands$addCommand(list(
    name = "save",
    bindKey = list(win = "Ctrl-1", mac = "Command-1"),
    exec = function() { save_btn$click() }
))

editor$commands$addCommand(list(
  name = "load",
  bindKey = list(win = "Ctrl-2", mac = "Command-2"),
  exec = function() { load_btn$click() }
))

editor$commands$addCommand(list(
  name = "bold",
  bindKey = list(win = "Ctrl-B", mac = "Command-B"),
  exec = function() { bold_btn$click() }
))

editor$commands$addCommand(list(
  name = "italic",
  bindKey = list(win = "Ctrl-I", mac = "Command-I"),
  exec = function() { italic_btn$click() }
))

editor$commands$addCommand(list(
  name = "strikethrough",
  bindKey = list(win = "Ctrl-S", mac = "Command-S"),
  exec = function() { strikethrough_btn$click() }
))


editor$commands$addCommand(list(
  name = "ulist",
  bindKey = list(win = "Ctrl-U", mac = "Command-U"),
  exec = function() { ulist_btn$click() }
))


editor$commands$addCommand(list(
  name = "olist",
  bindKey = list(win = "Ctrl-O", mac = "Command-O"),
  exec = function() { olist_btn$click() }
))


editor$commands$addCommand(list(
  name = "quote",
  bindKey = list(win = "Ctrl-'", mac = "Command-'"),
  exec = function() { quote_btn$click() }
))


editor$commands$addCommand(list(
  name = "code",
  bindKey = list(win = "Ctrl-K", mac = "Command-K"),
  exec = function() { code_btn$click() }
))


editor$commands$addCommand(list(
  name = "table",
  bindKey = list(win = "Ctrl-Y", mac = "Command-Y"),
  exec = function() { table_btn$click() }
))


editor$commands$addCommand(list(
  name = "link",
  bindKey = list(win = "Ctrl-L", mac = "Command-L"),
  exec = function() { link_btn$click() }
))


editor$commands$addCommand(list(
  name = "image",
  bindKey = list(win = "Ctrl-G", mac = "Command-G"),
  exec = function() { image_btn$click() }
))


editor$commands$addCommand(list(
  name = "pdf",
  bindKey = list(win = "Ctrl-3", mac = "Command-3"),
  exec = function() { pdf_btn$click() }
))


editor$commands$addCommand(list(
  name = "md",
  bindKey = list(win = "Ctrl-4", mac = "Command-4"),
  exec = function() { md_btn$click() }
))


# Hotkey hints ----
select_dom("#editor")$addEventListener(
    "keydown", function(event) {
        # console::log(event$code)
        if (event$code == "MetaLeft") {
            btn_list$forEach(function(btn) {
                let (element_id = "#" + btn$id %+% "_help")
                select_dom(element_id)$style$display = "block"
            })
        }
    }
)

select_dom("#editor")$addEventListener(
    "keyup", function(event) {
        if (event$code == "MetaLeft") {
            btn_list$forEach(function(btn) {
                let (element_id = "#" + btn$id %+% "_help")
                select_dom(element_id)$style$display = "none"
            })
        }
    }
)

hotkey_help <- function(button, hotkey) {
    declare (style_transform, style_width, bound)
    console::log(button$id)
    if (button$id == "md_btn") {
        console::log(select_dom("#" %+% button$id)$getBoundingClientRect())
    }
    bound <- select_dom("#" %+% button$id)$getBoundingClientRect()
    style_transform <- "transform: translate(" %+% bound$x %+% "px, 32px);"
    style_width <- "width:" %+% bound$width %+% "px;"
    dom("div", list(
        id = button$id %+% "_help",
        innerText = hotkey,
        style = style_transform %+% style_width %+%
            "top: 0; left: 0; position: absolute;" %+%
            "z-index:100; display:none;" %+% "text-align: center;" %+%
            "padding: 1px 3px 0px; font-size: 16px;" %+%
            "box-shadow: rgba(0, 0, 0, 0.3) 0px 3px 7px 0px;" %+%
            "background: -webkit-gradient(linear, 0% 0%, 0% 100%, from(rgb(255, 247, 133)), to(rgb(255, 197, 66)));" %+%
            "border-width: 1px; border-style: solid;" %+%
            "border-color: rgb(227, 190, 35); border-radius: 3px;"
    )) %>%
        print_dom("#overlay")
}

window$onload <- function() {
    btn_list <- Array(save_btn, load_btn, pdf_btn, md_btn,
                      bold_btn, italic_btn, strikethrough_btn,
                      olist_btn, ulist_btn, quote_btn, code_btn,
                      table_btn, link_btn, image_btn)
    hotkey_list <- Array("1", "2", "3", "4", "B", "I", "S", "O", "U",
                         "'", "K", "Y", "L", "G")
    print_dom(dom("div", list(id = "overlay")))
    R::map2(btn_list, hotkey_list, hotkey_help)
}

GFM_FLAG <- FALSE
PDF_FLAG <- FALSE

# Re-render every time the input is changed / updated ----
editor_change <- function(delta) {
    declare (dom_str, display_1, display_2, cache, current)
    # console::log("Rendering")
    dom_str <- editor$getValue() %>%
        marked(list(gfm = GFM_FLAG)) %>%
        render()

    display_1 <- select_dom("#cache_1")
    display_2 <- select_dom("#cache_2")
    cache <- ifelse(is_hidden(display_1), display_1, display_2)
    current <- ifelse(is_hidden(display_1), display_2, display_1)
    cache$onload <- function() {
        current$style$display <- "none"
        cache$style$display <- "block"
    }
    cache$srcdoc <- dom_str
}

editor$session$on('change', editor_change)

is_hidden <- function(x) {
    return(x$style$display == "none")
}

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
                               src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js")),
            # Add Paged.js
            ifelse(
                PDF_FLAG,
                dom("script", list(src="https://unpkg.com/pagedjs/dist/paged.polyfill.js", async = "async")),
                dom("div", list(style = "display: none;"))
            )
        )
    body <- dom("body", list(innerHTML = dom_str))
    return(head$outerHTML %+% body$outerHTML)
}
