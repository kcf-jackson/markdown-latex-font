# Built with sketch v1.0.4, compiled with basic_rules
#
# As the structure of the file indicates, the
# functionalities are added in an incremental fashion.
# ===================================================
#! load_script("https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css")

# UI
select_dom("body")$style$margin <- "0px"

# Menu bar ----
menu_style <- "display: flex; background: #fff6b2; padding: 6px; align-items: center;"
menu_bar <- dom("div", list(id = "menu_bar", style = menu_style))
print_dom(menu_bar)

# Save button ----
btn_style <- "margin: 6px 6px;"

save_btn <- dom("i", list(
  id = "save_btn",
  className = "fas fa-save fa-lg",
  style = btn_style
))

save_btn$onclick <- function() {
  declare(text, blob)
  text <- editor$getValue()
  blob <- Blob$new(
    Array(text),
    list(type = "text/plain;charset=utf-8")
  )
  saveAs(blob, "Untitled.md")
}

print_dom(save_btn, "#menu_bar")


# Load button ----
load_btn <- dom("i", list(
  id = "load_btn",
  className = "fas fa-upload fa-lg",
  style = btn_style
))

load_btn$onclick <- function() {
  select_dom("#file-selector")$click()
}

print_dom(load_btn, "#menu_bar")

# File input
file_input <- dom("input", list(
  type = "file",
  id = "file-selector",
  style = "display: none;"
))

file_input$onchange <- function() {
  declare(file, reader)
  file <- this$files[0]
  reader <- FileReader$new()
  reader$onload <- function() {
    editor$setValue(reader.result)
  }
  reader$onerror <- function() {
    editor$setValue(reader.error)
  }
  reader$readAsText(file)
}
print_dom(file_input, "#menu_bar")


# Pdf version ----
pdf_btn <- dom("i", list(id = "pdf_btn",
                         className = "fas fa-file-pdf fa-lg",
                         style = btn_style))
pdf_btn$onclick <- function() {
    PDF_FLAG <- !PDF_FLAG
    editor_change()
}
print_dom(pdf_btn, "#menu_bar")


# Markdown flavour ----
md_btn <- dom("select", list(
    id = "md_btn",
    className = "custom-select",
    style = "margin: 0px 6px; width: 100px"
)) %>%
    append_doms(
        dom("option", list(value = "Original", innerText = "Original")),
        dom("option", list(value = "Github", innerText = "Github"))
    )

md_btn$onchange <- function() {
    GFM_FLAG <- select_dom("#md_btn")$options[1]$selected
    editor_change()
}

print_dom(md_btn, "#menu_bar")


# Bold button ----
bold_btn <- dom("i", list(
  id = "bold_btn",
  className = "fas fa-bold fa-lg",
  style = btn_style
))

bold_btn$onclick <- function() {
    declare (cursor, text)
    if (is_selected()) {
        text <- editor$getSelectedText()
        if (text$substring(0, 2) == "**" &&
            text$substring(text$length - 2) == "**") {
          editor$session$replace(
            editor$selection$getRange(),
            text$slice(2, text$length - 2)
          )
        } else {
          editor$session$replace(
            editor$selection$getRange(),
            "**" %+% text %+% "**"
          )
        }
    } else {
        editor$insert("****")
        cursor <- editor$getCursorPosition()
        editor$moveCursorTo(cursor$row, cursor$column - 2)
        editor$focus()
    }
}

is_selected <- function() {
    declare (cursor)
    cursor <- editor$selection$getRange()
    return((cursor$start$row != cursor$end$row) ||
               (cursor$start$column != cursor$end$column))
}

print_dom(bold_btn, "#menu_bar")


# Italic button ----
italic_btn <- dom("i", list(
  id = "italic_btn",
  className = "fas fa-italic fa-lg",
  style = btn_style
))

italic_btn$onclick <- function() {
    declare (cursor, text)
    if (is_selected()) {
        text <- editor$getSelectedText()
        if (text$substring(0, 1) == "*" &&
            text$substring(text$length - 1) == "*") {
          editor$session$replace(
            editor$selection$getRange(),
            text$slice(1, text$length - 1)
          )
        } else {
          editor$session$replace(
            editor$selection$getRange(),
            "*" %+% text %+% "*"
          )
        }
    } else {
        editor$insert("**")
        cursor <- editor$getCursorPosition()
        editor$moveCursorTo(cursor$row, cursor$column - 1)
        editor$focus()
    }
}

print_dom(italic_btn, "#menu_bar")


# Strikethrough button ----
strikethrough_btn <- dom("i", list(
  id = "strikethrough_btn",
  className = "fas fa-strikethrough fa-lg",
  style = btn_style
))

strikethrough_btn$onclick <- function() {
    declare (cursor, text)
    if (is_selected()) {
        text <- editor$getSelectedText()
        if (text$substring(0, 1) == "~" &&
            text$substring(text$length - 1) == "~") {
          editor$session$replace(
            editor$selection$getRange(),
            text$slice(1, text$length - 1)
          )
        } else {
          editor$session$replace(
            editor$selection$getRange(),
            "~" %+% text %+% "~"
          )
        }
    } else {
        editor$insert("~~")
        cursor <- editor$getCursorPosition()
        editor$moveCursorTo(cursor$row, cursor$column - 1)
        editor$focus()
    }
}

print_dom(strikethrough_btn, "#menu_bar")


# Unordered list ----
ulist_btn <- dom("i", list(
    id = "ulist_btn",
    className = "fas fa-list-ul fa-lg",
    style = btn_style
))

ulist_btn$onclick <- function() {
    if (current_line() %>% begin_with("- ")) {
      set_current_line(current_line()$slice(2))
    } else {
      set_current_line("- " %+% current_line())
    }
}

previous_line <- function() {
  if (current_row() == 0) return(null)
  return(editor$session$getLine(current_row() - 1))
}

current_line <- function() {
    return(editor$session$getLine(current_row()))
}

set_current_line <- function(text) {
  editor$session$replace(
    ace::Range$new(current_row(), 0, current_row(), Number$MAX_VALUE),
    text
  )
}

get_line <- function(row_ind) {
  return(editor$session$getLine(row_ind))
}

set_line <- function(row_ind, text) {
  editor$session$replace(
    ace::Range$new(row_ind, 0, row_ind, Number$MAX_VALUE),
    text
  )
}

begin_with <- function(a, b) {
  let (m = Math::min(a$length, b$length))
  if (m == 0) return(FALSE)  # Safeguard
  return(a$slice(0, m) == b$slice(0, m))
}

current_row <- function() {
  return(editor$getCursorPosition()$row)
}

current_col <-  function() {
  return(editor$getCursorPosition()$column)
}

print_dom(ulist_btn, "#menu_bar")


# Ordered list ----
olist_btn <- dom("i", list(
  id = "olist_btn",
  className = "fas fa-list-ol fa-lg",
  style = btn_style
))

olist_btn$onclick <- function() {
  declare (numbered, match, text)
  numbered <- raw_str(r"(/^[0-9]+.[ ]/)")
  text <- current_line()
  if (numbered$test(text)) {
    # remove number if there is already one
    match <- numbered$exec(text)[0]
    set_current_line(text$slice(match$length))
  } else {
    # add number if it does not exist yet
    if (numbered$test(previous_line())) {
      number <- raw_str(r"(/^[0-9]+/)")$exec(previous_line())[0]
      number <- parseInt(number) + 1
      set_current_line(number %+% ". " %+% text)
    } else {
      set_current_line("1. " %+% text)
    }
  }
}

print_dom(olist_btn, "#menu_bar")


# blockquote ----
quote_btn <- dom("i", list(id = "quote_btn",
                            className = "fas fa-quote-right fa-lg",
                            style = btn_style))
quote_btn$onclick <- function() {
  declare (range0, indices)
  if (is_selected()) {
    range0 <- editor$getSelectionRange()
    all_block <- TRUE
    indices <- R::seq(range0$start$row, range0$end$row, 1)
    for (i in indices) {
      if (!begin_with(current_line(), "> ")) {
        all_block <- FALSE
        break
      }
    }
    if (all_block) {
      indices$forEach(i %=>% set_line(i, get_line(i)$slice(2)))
    } else {
      indices$forEach(i %=>% set_line(i, "> " %+% get_line(i)))
    }
  } else {
    if (current_line() %>% begin_with("> ")) {
      set_current_line(current_line()$slice(2))
    } else {
      set_current_line("> " %+% current_line())
    }
  }
}
print_dom(quote_btn, "#menu_bar")


# code ----
code_btn <- dom("i", list(id = "code_btn",
                            className = "fas fa-code fa-lg",
                            style = btn_style))
code_btn$onclick <- function() {
  declare (range0, indices)
  if (is_selected()) {
    range0 <- editor$getSelectionRange()
    all_block <- TRUE
    indices <- R::seq(range0$start$row, range0$end$row, 1)
    for (i in indices) {
      if (!begin_with(current_line(), "    ")) {
        all_block <- FALSE
        break
      }
    }
    if (all_block) {
      indices$forEach(i %=>% set_line(i, get_line(i)$slice(4)))
    } else {
      indices$forEach(i %=>% set_line(i, "    " %+% get_line(i)))
    }
  } else {
    if (current_line() %>% begin_with("    ")) {
      set_current_line(current_line()$slice(4))
    } else {
      set_current_line("    " %+% current_line())
    }
  }
}
print_dom(code_btn, "#menu_bar")


# table ----
table_btn <- dom("i", list(id = "table_btn",
                          className = "fas fa-table fa-lg",
                          style = btn_style))
table_btn$onclick <- function() {
  declare (table_str)
  table_str <- "|       |       |\n|:-----:|:-----:|\n|       |       |\n"
  if (current_col() == 0) {
    editor$session$insert(
      list(row = current_row(), column = 0),
      table_str
    )
  } else {
    editor$session$insert(
      list(row = current_row(), column = Number$MAX_VALUE),
      "\n" %+% table_str
    )
  }
  cursor <- editor$getCursorPosition()
  editor$moveCursorTo(cursor$row - 3, cursor$column + 2)
  editor$focus()
}
print_dom(table_btn, "#menu_bar")

# link ----
link_btn <- dom("i", list(id = "link_btn",
                          className = "fas fa-link fa-lg",
                          style = btn_style))
link_btn$onclick <- function() {
  declare (cursor, text)
  if (is_selected()) {
    text <- editor$getSelectedText()
    editor$session$replace(
      editor$selection$getRange(),
      "[" %+% text %+% "]()"
    )
    cursor <- editor$getCursorPosition()
    editor$moveCursorTo(cursor$row, cursor$column + 1)
  } else {
    editor$insert("[]()")
    cursor <- editor$getCursorPosition()
    editor$moveCursorTo(cursor$row, cursor$column - 3)
    editor$focus()
  }
}
print_dom(link_btn, "#menu_bar")

# image ----
image_btn <- dom("i", list(id = "image_btn",
                          className = "fas fa-image fa-lg",
                          style = btn_style))
image_btn$onclick <- function() {
  declare (cursor, text)
  if (is_selected()) {
    text <- editor$getSelectedText()
    editor$session$replace(
      editor$selection$getRange(),
      "![](" %+% text %+% ")"
    )
    cursor <- editor$getCursorPosition()
    editor$moveCursorTo(cursor$row, cursor$column + 1)
  } else {
    editor$insert("![]()")
    cursor <- editor$getCursorPosition()
    editor$moveCursorTo(cursor$row, cursor$column - 1)
    editor$focus()
  }
}
print_dom(image_btn, "#menu_bar")




# Editor and Display ----
menu_h <- select_dom("#menu_bar")$getBoundingClientRect()$height
style <- "width: 50%;"
container_style <- "display:flex; height: calc(100vh - " %+% menu_h %+% "px);"
iframe_style <- "width:100%; height:100%; border:none;"

dom("div", list(id = "container", style = container_style)) %>%
  append_doms(
    dom("div", list(id = "editor", style = style %+% "font-size: 20px;")),
    dom("div", list(id = "renderer", style = style)) %>% append_doms(
      # Need one extra iframe for caching to avoid flickering on update
      dom("iframe", list(id = "cache_1", srcdoc = "", style = iframe_style)),
      dom("iframe", list(id = "cache_2", srcdoc = "", style = iframe_style %+% "display: none;"))
    )
  ) %>%
  print_dom()

