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
#' @param \ldots ignored.
#' @keywords text report
#' @export
#' @examples
#' \dontrun{
#' report(presidential_debates_2012, c("person", "time"))
#' ## Just Tables (non-viz report)
#' report(presidential_debates_2012, c("person", "time"), tables.only = TRUE)
#' }
report <- function(data, grouping.var = NULL, tables.only = FALSE, open = TRUE,
    path = "textreport", text.var = TRUE,  ...){

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
    rmarkdown::render("textreport.Rmd", "all")

    if (file.exists("textreport.html") && isTRUE(open)){
        utils::browseURL("textreport.html")
    }

    setwd(WD)

    if (file.exists("textreport/textreport.html")){
        message("See the.pdf, .html, and .docx outputs.")
        message("The `textreport.Rmd` can be used to tweak the reports.")
    } else {
        message("Can't locate `textreport.html`:\nMay have failed to generate reports.")
    }

}
