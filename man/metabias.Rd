% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/metabias.R
\name{metabias}
\alias{metabias}
\alias{metabias.meta}
\alias{metabias.default}
\alias{print.metabias}
\title{Test for funnel plot asymmetry}
\usage{
metabias(x, ...)

\method{metabias}{default}(
  x,
  seTE,
  method.bias = "linreg",
  plotit = FALSE,
  correct = FALSE,
  k.min = 10,
  ...
)

\method{metabias}{meta}(
  x,
  method.bias = x$method.bias,
  plotit = FALSE,
  correct = FALSE,
  k.min = 10,
  ...
)

\method{print}{metabias}(x, ...)
}
\arguments{
\item{x}{An object of class \code{meta} or estimated treatment
effect in individual studies.}

\item{\dots}{Additional arguments (ignored at the moment).}

\item{seTE}{Standard error of estimated treatment effect (mandatory
if \code{x} not of class \code{meta}).}

\item{method.bias}{A character string indicating which test is to
be used.  Either \code{"rank"}, \code{"linreg"}, \code{"mm"},
\code{"count"}, \code{"score"}, or \code{"peters"}, can be
abbreviated.}

\item{plotit}{A logical indicating whether a plot should be
produced for method.bias \code{"rank"}, \code{"linreg"},
\code{"mm"}, or \code{"score"}.}

\item{correct}{A logical indicating whether a continuity corrected
statistic is used for rank correlation methods \code{"rank"} and
\code{"count"}.}

\item{k.min}{Minimum number of studies to perform test for funnel
plot asymmetry.}
}
\value{
A list with class \code{htest} containing the following components
if a test for funnel plot asymmetry is conducted:
\item{estimate}{The estimated degree of funnel plot asymmetry, with
  name \code{"ks"} or \code{"bias"} corresponding to the method
  employed, i.e., rank correlation or regression method.}
\item{statistic}{The value of the test statistic.}
\item{parameters}{The degrees of freedom of the test statistic in
  the case that it follows a t distribution.}
\item{p.value}{The p-value for the test.}
\item{alternative}{A character string describing the alternative
  hypothesis.}
\item{method}{A character string indicating what type of test was
  used.}
\item{data.name}{A character string giving the names of the data.}
  \item{title}{Title of Cochrane review.}
\item{complab}{Comparison label.}
\item{outclab}{Outcome label.}
\item{version}{Version of R package \bold{meta} used to create
  object.}

Or a list with the following elements if test is not conducted due
to the number of studies:
\item{k}{Number of studies in meta-analysis.}
\item{k.min}{Minimum number of studies to perform test for funnel
  plot asymmetry.}
\item{version}{Version of R package \bold{meta} used to create
  object.}
}
\description{
Test for funnel plot asymmetry, based on rank correlation or linear
regression method.
}
\details{
Functions to conduct rank correlation or linear regression tests
for funnel plot asymmetry.

Following recommendations by Sterne et al. (2011), by default, a
test for funnel plot asymmetry is only conducted if the number of
studies is ten or larger (argument \code{k.min = 10}). This
behaviour can be changed by setting a smaller value for argument
\code{k.min}. Note, the minimum number of studies is three.

If argument \code{method.bias} is \code{"rank"}, the test statistic
is based on the rank correlation between standardised treatment
estimates and variance estimates of estimated treatment effects;
Kendall's tau is used as correlation measure (Begg & Mazumdar,
1994). The test statistic follows a standard normal
distribution. By default (if \code{correct} is FALSE), no
continuity correction is utilised (Kendall & Gibbons, 1990).

If argument \code{method.bias} is \code{"linreg"}, the test
statistic is based on a weighted linear regression of the treatment
effect on its standard error (Egger et al., 1997). The test
statistic follows a t distribution with \code{number of studies -
2} degrees of freedom.

If argument \code{method.bias} is \code{"mm"}, the test statistic
is based on a weighted linear regression of the treatment effect on
its standard error using the method of moments estimator for the
additive between-study variance component (method 3a in Thompson,
Sharp, 1999). The test statistic follows a t distribution with
\code{number of studies - 2} degrees of freedom.

If argument \code{method.bias} is \code{"peters"}, the test
statistic is based on a weighted linear regression of the treatment
effect on the inverse of the total sample size using the variance
of the average event rate as weights (Peters et al., 2006). The
test statistic follows a t distribution with \code{number of
studies - 2} degrees of freedom. This test is available for
meta-analyses comparing two binary outcomes or combining single
proportions, i.e.  generated with functions \code{metabin} and
\code{metaprop}.

The following tests for funnel plot asymmetry are only available
for meta-analyses comparing two binary outcomes, i.e. meta-analyses
generated with the \code{metabin} function.

If argument \code{method.bias} is \code{"count"}, the test
statistic is based on the rank correlation between a standardised
cell frequency and the inverse of the variance of the cell
frequency; Kendall's tau is used as correlation measure (Schwarzer
et al., 2007). The test statistic follows a standard normal
distribution. By default (if \code{correct} is FALSE), no
continuity correction is utilised (Kendall & Gibbons, 1990).

If argument \code{method.bias} is \code{"score"}, the test
statistic is based on a weighted linear regression utilising
efficient score and score variance (Harbord et al., 2006,
2009). The test statistic follows a t distribution with
\code{number of studies - 2} degrees of freedom.

In order to calculate an arcsine test for funnel plot asymmetry
(Rücker et al., 2008), one has to use the \code{metabin} function
with argument \code{sm = "ASD"} as input to the \code{metabias}
command. The three arcsine tests described in Rücker et al. (2008)
can be calculated by setting \code{method.bias} to \code{"rank"},
\code{"linreg"} and \code{"mm"}, respectively.

If argument \code{method.bias} is missing, the Harbord test
(\code{method.bias = "score"}) is used for the odds ratio as effect
measure and the Egger test (\code{method.bias = "linreg"}) for
other effect measures (Sterne et al., 2011).

No test for funnel plot asymmetry is conducted in meta-analyses
with subgroups.
}
\examples{
data(Olkin95)
m1 <- metabin(event.e, n.e, event.c, n.c,
              data = Olkin95, subset = 1:10,
              sm = "RR", method = "I")

metabias(m1)
metabias(m1, plotit = TRUE)

metabias(m1, method.bias = "rank")
metabias(m1, method.bias = "rank", correct = TRUE)

metabias(m1, method.bias = "count")
metabias(m1, method.bias = "linreg")$p.value

# Arcsine test (based on linear regression)
#
m1.as <- update(m1, sm = "ASD")
metabias(m1.as)
# Same result (using function metabias.default)
metabias(m1.as$TE, m1.as$seTE)

# No test for funnel plot asymmetry calculated
#
m2 <- update(m1, subset = 1:5)
metabias(m2)

m3 <- update(m1, subset = 1:2)
metabias(m3)

# Test for funnel plot asymmetry calculated (use of argument k.min)
#
metabias(m2, k.min = 5)

}
\references{
Begg CB & Mazumdar M (1994):
Operating characteristics of a rank correlation test for
publication bias.
\emph{Biometrics},
\bold{50}, 1088--101

Egger M, Smith GD, Schneider M & Minder C (1997):
Bias in meta-analysis detected by a simple, graphical test.
\emph{British Medical Journal},
\bold{315}, 629--34

Harbord RM, Egger M & Sterne J (2006):
A modified test for small-study effects in meta-analyses of
controlled trials with binary endpoints.
\emph{Statistics in Medicine},
\bold{25}, 3443--57

Harbord RM, Harris RJ, Sterne JAC (2009):
Updated tests for small-study effects in meta–analyses.
\emph{The Stata Journal},
\bold{9}, 197--210

Kendall M & Gibbons JD (1990):
\emph{Rank Correlation Methods}.
London: Edward Arnold

Peters JL, Sutton AJ, Jones DR, Abrams KR & Rushton L (2006):
Comparison of two methods to detect publication bias in
meta-analysis.
\emph{Journal of the American Medical Association},
\bold{295}, 676--80

Rücker G, Schwarzer G, Carpenter JR (2008):
Arcsine test for publication bias in meta-analyses with binary
outcomes.
\emph{Statistics in Medicine},
\bold{27}, 746--63

Schwarzer G, Antes G & Schumacher M (2007):
A test for publication bias in meta-analysis with sparse binary
data.
\emph{Statistics in Medicine},
\bold{26}, 721--33

Sterne, JAC et al. (2011):
Recommendations for examining and interpreting funnel plot
asymmetry in meta-analyses of randomised controlled trials.
\emph{BMJ (Clinical research ed.)},
\bold{343}, 1

Thompson SG & Sharp, SJ (1999):
Explaining heterogeneity in meta-analysis: a comparison of methods,
\emph{Statistics in Medicine},
\bold{18}, 2693--708
}
\seealso{
\code{\link{funnel}}, \code{\link{funnel.meta}},
  \code{\link{metabin}}, \code{\link{metacont}},
  \code{\link{metagen}}
}
\author{
Guido Schwarzer \email{sc@imbi.uni-freiburg.de}
}
\keyword{htest}
