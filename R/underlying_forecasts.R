#' Retrieve underlying forecasts corresponding to the asymmetric filters
#'
#' Function to retrieve the underlying forecasts corresponding to the asymmetric filters:
#' the asymmetric filtering produce the same result than the symmetric filters applied to the extended series.
#'
#' @details Let \eqn{h} be the bandwidth of the symmetric filter,
#' \eqn{v_{-h}, \ldots, v_h} the coefficients of the symmetric filter and
#' \eqn{w_{-h}^q, \ldots, w_h^q} the coefficients of the asymmetric filter used to estimate
#' the trend when \eqn{q} future values are known (with the convention \eqn{w_{q+1}^q=\ldots=w_h^q=0}).
#' Let denote \eqn{y_{-2h+1},\ldots, y_0} the last \eqn{2h} available values of the input times series.
#' The underlying forecast \eqn{y_{1}^*,\dots y_h^*} induced by \eqn{w^0,\dots w^{h-1}}  are defined by:
#' \deqn{
#' \forall q\in\{0,...,h-1\}, \quad \sum_{i=-h}^q v_iy_{i-q} + \sum_{i=q+1}^h v_iy_{i-q}^*
#' =\sum_{i=-h}^q w_i^qy_{i-q}.
#' }
#' Note that this is solved numerically: the solution isn't exact.
#' @inheritParams implicit_forecasts
#' @examples \dontrun{
#'
#' x <- retailsa$AllOtherGenMerchandiseStores
#' ql <- lp_filter(horizon = 6, kernel = "Henderson", endpoints = "QL")
#' lc <- lp_filter(horizon = 6, kernel = "Henderson", endpoints = "LC")
#' f_ql <- underlying_forecasts(x, ql)
#' f_lc <- underlying_forecasts(x, lc)
#'
#' plot(window(x, start = 2007),
#'      xlim = c(2007,2012))
#' lines(ts(c(tail(x,1), f_ql), frequency = frequency(x), start = end(x)),
#'       col = "red", lty = 2)
#' lines(ts(c(tail(x,1), f_lc), frequency = frequency(x), start = end(x)),
#'       col = "blue", lty = 2)
#'}
#' @importFrom stats time
#' @export
underlying_forecasts <- function(x, coefs) {
  UseMethod("underlying_forecasts", x)
}
#' @importFrom stats deltat
#' @export
underlying_forecasts.default <- function(x, coefs) {
  if (!inherits(coefs, "finite_filters")) {
    coefs <- finite_filters(coefs)
  }
  jffilters <- .finite_filters2jd(coefs)
  h <- abs(lower_bound(coefs@sfilter))

  jx <- .r2jd_doubleseq(tail(x,2*h))
  prev <- .jcall("jdplus/toolkit/base/core/math/linearfilters/AsymmetricFiltersFactory",
         "[D","underlyingForecasts",
         jffilters$jsymf,
         jffilters$jrasym,
         jx)
  if (is.ts(x))
    prev <- ts(prev,
       frequency = frequency(x),
       start = time(x)[length(time(x))] + deltat(x))

  prev
}
#' @export
underlying_forecasts.matrix <- function(x, coefs) {
  result <- do.call(cbind, lapply(seq_len(ncol(x)), function(i) underlying_forecasts(x[,i], coefs = coefs)))
  colnames(result) <- colnames(x)
  result
}
