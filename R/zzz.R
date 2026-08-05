#' @import rJava
#' @importFrom graphics axis lines plot matplot
#' @importFrom stats frequency ts
#' @importFrom rjd3toolkit .proc_data .proc_dictionary .jd2r_matrix .r2jd_matrix
NULL

#' @importFrom rjd3jars check_java_version
.onAttach <- function(libname, pkgname) {
    # Check java version
    rjd3jars::check_java_version(silent = FALSE, startup = TRUE)
}

.onLoad <- function(libname, pkgname) {
    # Loading dependencies
    if (!requireNamespace("rjd3jars", quietly = TRUE)) {
        stop("Loading {rjd3jars} failed", call. = FALSE)
    }
    if (!requireNamespace("rjd3toolkit", quietly = TRUE)) {
        stop("Loading {rjd3toolkit} failed", call. = FALSE)
    }

    # Loading Java class
    jar_dir <- file.path(libname, pkgname, "inst", "java")
    jars_inst <- list.files(
        jar_dir,
        pattern = "\\.jar$",
        full.names = TRUE,
        all.files = TRUE
    )
    result <- rJava::.jpackage(
        pkgname,
        lib.loc = libname,
        morePaths = jars_inst
    )
    if (!result) {
        stop("Loading java packages failed")
    }

    # If java >= 21, then reload dictionnaries
    has_java <- rjd3jars::check_java_version(silent = TRUE)
    if (has_java) {
        rjd3jars::reload_dictionaries()
    }
}

#' Seasonally Adjusted Retail Sales
#'
#' A dataset containing monthly seasonally adjusted retailed sales
#'
#' @docType data
#' @format A \code{list} of \code{ts} objects from january 1992 to december 2010.
"retailsa"
