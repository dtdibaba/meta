#' Conversion from standardised mean difference to log odds ratio
#' 
#' @description
#' Conversion from standardised mean difference to log odds ratio
#' using method by Hasselblad & Hedges (1995) or Cox (1970).
#' 
#' @param smd Standardised mean difference(s) (SMD) or meta-analysis
#'   object.
#' @param se.smd Standard error(s) of SMD.
#' @param method A character string indicating which method is used to
#'   convert SMDs to log odds ratios. Either \code{"HH"} or
#'   \code{"CS"}, can be abbreviated.
#' @param backtransf A logical indicating whether odds ratios (if
#'   TRUE) or log odds ratios (if FALSE) should be shown in printouts
#'   and plots.
#' @param \dots Additional arguments (not considered if argument
#'   \code{smd} is a meta-analysis object).
#' 
#' @details
#' This function implements the following methods for the conversion
#' from standardised mean difference to log odds ratio:
#' \itemize{
#' \item Hasselblad & Hedges (1995) assuming logistic distributions
#'   (\code{method == "HH"})
#' \item Cox (1970) and Cox & Snell (1989) assuming normal
#'   distributions (\code{method == "CS"})
#' }
#' Internally, \code{\link{metagen}} is used to conduct a
#' meta-analysis with the odds ratio as summary measure.
#' 
#' Argument \code{smd} can be either a vector of standardised mean
#' differences or a meta-analysis object created with
#' \code{\link{metacont}} or \code{\link{metagen}} and the
#' standardised mean difference as summary measure.
#'
#' Argument \code{se.smd} is mandatory if argument \code{smd} is a
#' vector and ignored otherwise. Additional arguments in \code{\dots}
#' are only passed on to \code{\link{metagen}} if argument \code{smd}
#' is a vector.
#' 
#' @return
#' An object of class \code{"meta"} and \code{"metagen"}; see
#' \code{\link{metagen}}.
#' 
#' @author Guido Schwarzer \email{sc@@imbi.uni-freiburg.de}
#'
#' @seealso \code{\link{or2smd}}, \code{\link{metacont}},
#'   \code{\link{metagen}}, \code{\link{metabin}}
#' 
#' @references
#' Borenstein M, Hedges LV, Higgins JPT, Rothstein HR (2009):
#' \emph{Introduction to Meta-Analysis}.
#' Chichester: Wiley
#'
#' Cox DR (1970):
#' \emph{Analysis of Binary Data}.
#' London: Chapman and Hall / CRC
#'
#' Cox DR, Snell EJ (1989):
#' \emph{Analysis of Binary Data} (2nd edition).
#' London: Chapman and Hall / CRC
#'
#' Hasselblad V, Hedges LV (1995):
#' Meta-analysis of screening and diagnostic tests.
#' \emph{Psychological Bulletin},
#' \bold{117}, 167--78
#' 
#' @examples
#' # Example from Borenstein et al. (2010), Chapter 7
#' #
#' mb <- smd2or(0.5, sqrt(0.0205), backtransf = FALSE)
#' # TE = log odds ratio; seTE = standard error of log odds ratio
#' data.frame(lnOR = round(mb$TE, 4), varlnOR = round(mb$seTE^2, 4))
#'
#' # Use dataset from Fleiss (1993)
#' #
#' data(Fleiss93cont)
#' m1 <- metacont(n.e, mean.e, sd.e, n.c, mean.c, sd.c, study,
#'                data = Fleiss93cont, sm = "SMD")
#' smd2or(m1)
#' 
#' @export smd2or


smd2or <- function(smd, se.smd, method = "HH",
                   backtransf = gs("backtransf"), ...) {
  
  
  is.meta <- inherits(smd, "meta")
  ##
  if (is.meta) {
    if (smd$sm != "SMD")
      stop("Effect measure must be equal to 'SMD'.", call. = FALSE)
    else {
      mdat <- smd
      smd <- mdat$TE
      se.smd <- mdat$seTE
    }
  }
  
  
  method <- setchar(method, c("HH", "CS"))
  ##
  if (method == "HH") {
    lnOR <- smd * pi / sqrt(3)
    selnOR <- sqrt(se.smd^2 * pi^2 / 3)
  }
  else if (method == "CS") {
    lnOR <- smd * 1.65
    selnOR <- sqrt(se.smd^2 * 1.65)
  }
  ##
  chklogical(backtransf)
  
  
  if (is.meta) {
    if (is.null(mdat$byvar))
      res <- metagen(lnOR, selnOR, sm = "OR",
                     data = mdat,
                     studlab = mdat$studlab,
                     subset = mdat$subset, exclude = mdat$exclude,
                     level = mdat$level, level.comb = mdat$level.comb,
                     comb.fixed = mdat$comb.fixed,
                     comb.random = mdat$comb.random,
                     hakn = mdat$hakn, method.tau = mdat$method.tau,
                     tau.common = mdat$tau.common,
                     prediction = mdat$prediction,
                     level.predict = mdat$level.predict,
                     null.effect = 0,
                     method.bias = mdat$method.bias,
                     backtransf = backtransf,
                     title = mdat$title, complab = mdat$complab,
                     outclab = mdat$outclab,
                     label.c = mdat$label.c, label.e = mdat$label.e,
                     label.left = mdat$label.left,
                     label.right = mdat$label.right,
                     control = mdat$control)
    else
      res <- metagen(lnOR, selnOR, sm = "OR",
                     data = mdat,
                     studlab = mdat$studlab,
                     subset = mdat$subset, exclude = mdat$exclude,
                     level = mdat$level, level.comb = mdat$level.comb,
                     comb.fixed = mdat$comb.fixed,
                     comb.random = mdat$comb.random,
                     hakn = mdat$hakn, method.tau = mdat$method.tau,
                     tau.common = mdat$tau.common,
                     prediction = mdat$prediction,
                     level.predict = mdat$level.predict,
                     null.effect = 0,
                     method.bias = mdat$method.bias,
                     backtransf = backtransf,
                     title = mdat$title, complab = mdat$complab,
                     outclab = mdat$outclab,
                     label.c = mdat$label.c,
                     label.e = mdat$label.e,
                     label.left = mdat$label.left,
                     label.right = mdat$label.right,
                     byvar = mdat$byvar, bylab = mdat$bylab,
                     print.byvar = mdat$print.byvar,
                     byseparator = mdat$byseparator,
                     control = mdat$control)
  }
  else {
    dat <- data.frame(smd, se.smd, lnOR, selnOR, OR = exp(lnOR))
    res <- metagen(lnOR, selnOR, data = dat, sm = "OR",
                   backtransf = backtransf, ...)
  }
  
  
  res
}