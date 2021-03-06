#' Title
#'
#' Description
#'
#' @param data A data set with text to analyze.
#' @param grouping.var A character vector naming the grouping variable(s).
#' @param tables.only logical.  If \code{TRUE} the report will not be visual,
#' but a tables only version of the descriptive text analysis.
#' @param open logical.  If \code{TRUE} the \file{textreport.html} file will
#' attempt to be opened in the browser.
#' @param path A path to generate the files in.
#' @param text.var A character vector naming the text variable.  If \code{TRUE}
#' \code{report} will attempt to detect the text variable.
#' @param output.format R Markdown output format to convert to. Pass \code{"all"}
#' to render all formats defined within the file. Pass the name of a format
#' (e.g. \code{"html_document"}) to render a single format or pass a vector of
#' format names to render multiple formats. See \code{\link[rmarkdown]{render}}
#' for more.
#' @param \ldots Other arguments passed to \code{\link[rmarkdown]{render}}.
#' @keywords text report
#' @export
#' @examples
#' \dontrun{
#' report(presidential_debates_2012, c("person", "time"))
#' ## Just Tables (non-viz report)
#' report(presidential_debates_2012, c("person", "time"), tables.only = TRUE)
#' }
#'
#' \dontrun{
#' ## 2015 Vice-Presidential Debates Example
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load(rvest, magrittr, xml2)
#' pacman::p_load_gh("trinkr/textshape")
#'
#' debates <- c(
#'     wisconsin = "110908",
#'     boulder = "110906",
#'     california = "110756",
#'     ohio = "110489"
#' )
#'
#' lapply(debates, function(x){
#'     xml2::read_html(paste0("http://www.presidency.ucsb.edu/ws/index.php?pid=", x)) %>%
#'         rvest::html_nodes("p") %>%
#'         rvest::html_text() %>%
#'         textshape::split_index(., grep("^[A-Z]+:", .)) %>%
#'         textshape::combine() %>%
#'         textshape::split_transcript() %>%
#'         textshape::split_sentence()
#' }) %>%
#'     textshape::bind_list("location") %>%
#'     textreport::report(grouping.var = c("person", "location"))
#' }
report <- function(data, grouping.var = NULL, tables.only = FALSE, open = TRUE,
    path = "textreport", text.var = TRUE, output.format = "all", ...){

    message("Attempting to generate text report...\nMay take a minute or so.")
    message("\nYou have an excuse to grab a coffee!")

    #Generate folder (if empty REPORT.NAME textreport)
    data <- as.data.frame(data, stringsAsFactors = FALSE)

    if (file.exists(path)) {
        message(paste0("\"", path, "\" already exists:\nDo you want to overwrite?\n"))
        ans <- utils::menu(c("Yes", "No"))
        if (ans == "2") {
            stop("`library_template` aborted")
        } else {
            unlink(path, recursive = TRUE, force = FALSE)
            suppressWarnings(dir.create(path))
        }
    } else {
        suppressWarnings(dir.create(path))
    }

    if (isTRUE(text.var)) {
        text.var <- names(which.max(sapply(as.data.frame(data), function(y) {
            if(!is.character(y) && !is.factor(y)) return(0)
            mean(nchar(as.character(y)), na.rm = TRUE)
        }))[1])
        if (nrow(data) == 0) stop("Could not detect `text.var`.  Please supply `text.var` explicitly.")
    }

    if (is.null(grouping.var)){
        group.var <- rep("all", nrow(data))
        gnms <- "all"
        group.vars <- group.var
    } else {
        group.var <- paste2(data[grouping.var])
        gnms <- paste(grouping.var, collapse="&")
        group.vars <- data[, grouping.var, drop=FALSE]
    }

    data <- stats::setNames(data.frame(
        group.var,
        group.vars,
        data[[text.var]],
        stringsAsFactors = FALSE
    ), c(gnms, grouping.var, text.var))

    attributes(data)[['group']] <- gnms
    attributes(data)[['group.combined']] <- grouping.var
    attributes(data)[['text']] <- text.var

    # Generate Data as .rda file
    saveRDS(data, "textreport/report_data.rds")

    # Generate Rmd
    if (isTRUE(tables.only)) {
        temploc <- "templates/just_tables/textreport.Rmd"
    } else {
        temploc <- "templates/textreport.Rmd"
    }
    template <- system.file(temploc, package = "textreport")
    file.copy(template, "textreport")

    ## Change wd
    WD <- getwd()
    on.exit(setwd(WD))
    setwd(path)

    # knit with rmarkdown into pdf, html, and word
    suppressWarnings(rmarkdown::render("textreport.Rmd", output_format = output.format, ...))

    if (file.exists("textreport.html") && isTRUE(open)){
        utils::browseURL("textreport.html")
    }

    setwd(WD)

    if (file.exists("textreport/textreport.html") ){
        message("\n\nSee the.pdf, .html, and .docx outputs.")
        message("The `textreport.Rmd` can be used to tweak the reports.")
    } else {
        message("\n\nCan't locate `textreport.html`:\nMay have failed to generate reports...\nOr `output.format` not set to output an HTML document.")
    }

}
