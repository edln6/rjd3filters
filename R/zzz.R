#' @import rJava
#' @importFrom graphics axis lines plot matplot
#' @importFrom stats frequency ts
#' @importFrom rjd3toolkit .proc_data .proc_dictionary .jd2r_matrix .r2jd_matrix
NULL

.onLoad <- function(libname, pkgname) {
    # Chargement des classes Java
    jar_dir <- file.path(libname, pkgname, "inst", "java")
    jars_inst <- list.files(jar_dir, pattern = "\\.jar$", full.names = TRUE, all.files = TRUE)
    # rJava::.jaddClassPath(jars_inst)

    result <- rJava::.jpackage(
        pkgname,
        lib.loc = libname,
        morePaths = jars_inst
    )
    if (!result) {
        stop("Loading java packages failed", call. = FALSE)
    }

    # Chargement des extracteurs
    if (rjd3toolkit::get_java_version() >= rjd3toolkit::minimal_java_version) {
        rjd3toolkit::reload_dictionaries()
    }
}

#' Seasonally Adjusted Retail Sales
#'
#' A dataset containing monthly seasonally adjusted retailed sales
#'
#' @docType data
#' @format A \code{list} of \code{ts} objects from january 1992 to december 2010.
"retailsa"
