#' SaveSimpleTable
#'
#' Saves a simple table to disk as docx.
#' @param table.name A character vector of length 1. The name of the table. Will
#'     be used as caption. No default.
#' @param table.objects A list. The tables. No default.
#' @param file.stub A character vector of length 1. The first part of the name
#'     of the file in which to save the table, i.e. without the file
#'     extension. No default.
#' @param append A logical vector of length 1. If TRUE the table is appended to
#'     file.name, if it already exists. Defaults to FALSE.
#' @param remove.if.exists A logical vector of length 1. If TRUE the file
#'     corresponding to file.name is removed. Defaults to FALSE.
#' @export
SaveSimpleTable <- function(table.name, table.objects, file.stub, append = FALSE,
                        remove.if.exists = FALSE) {
    table.object <- table.objects[[table.name]]
    formatted.table <- knitr::kable(table.object, caption = table.name,
                                    row.names = TRUE, format = "pandoc")
    file.names <- paste0(file.stub, ".", c("docx", "md"))
    if (remove.if.exists & any(file.exists(file.names)))
        file.remove(file.names[file.exists(file.names)])
    write(formatted.table, file.names[2], append = append)
    if (append)
        write("\n &nbsp; \n", file.names[2], append = append)
    rmarkdown::render(file.names[2], output_format = "word_document")
}
