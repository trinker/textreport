report <- function(data, text.var = TRUE, grouping.var, path = "textreport", ...){

#Generate folder (if empty REPORT.NAME textreport)

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

# Generate Data as .rda file
    saveRDS(data, "textreport/report_data.rds")

# Generate Rmd

# knit with rmarkdown into pdf, html, and word
    rmarkdown::render("textreport/textreport.Rmd", "all")

}
