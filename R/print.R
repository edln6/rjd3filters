#' @rdname moving_average
#' @importFrom methods show
#' @export
setMethod(
    f = "show",
    signature = "moving_average",
    definition = function(object) {
        print(.jcall(.ma2jd(object), "S", "toString"))
        invisible(object)
    }
)

#' @importFrom methods show
#' @rdname finite_filters
#' @export
setMethod(
    f = "show",
    signature = "finite_filters",
    definition = function(object) {
        x <- as.matrix(object)
        print(x)
    }
)
