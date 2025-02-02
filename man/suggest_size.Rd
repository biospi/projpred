% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R
\name{suggest_size}
\alias{suggest_size}
\alias{suggest_size.vsel}
\title{Suggest submodel size}
\usage{
suggest_size(object, ...)

\method{suggest_size}{vsel}(
  object,
  stat = "elpd",
  pct = 0,
  type = "upper",
  warnings = TRUE,
  ...
)
}
\arguments{
\item{object}{An object of class \code{vsel} (returned by \code{\link[=varsel]{varsel()}} or
\code{\link[=cv_varsel]{cv_varsel()}}).}

\item{...}{Arguments passed to \code{\link[=summary.vsel]{summary.vsel()}}, except for \code{object}, \code{stats}
(which is set to \code{stat}), \code{type}, and \code{deltas} (which is set to \code{TRUE}).
See section "Details" below for some important arguments which may be
passed here.}

\item{stat}{Statistic used for the decision. See \code{\link[=summary.vsel]{summary.vsel()}} for
possible choices.}

\item{pct}{A number giving the relative proportion (\emph{not} percents) between
baseline model and null model utilities one is willing to sacrifice. See
section "Details" below for more information.}

\item{type}{Either \code{"upper"} or \code{"lower"} determining whether the decision is
based on the upper or lower confidence interval bound, respectively. See
section "Details" below for more information.}

\item{warnings}{Mainly for internal use. A single logical value indicating
whether to throw warnings if automatic suggestion fails. Usually there is
no reason to set this to \code{FALSE}.}
}
\description{
This function can suggest an appropriate submodel size based on a decision
rule described in section "Details" below. Note that this decision is quite
heuristic and should be interpreted with caution. It is recommended to
examine the results via \code{\link[=plot.vsel]{plot.vsel()}} and/or \code{\link[=summary.vsel]{summary.vsel()}} and to make the
final decision based on what is most appropriate for the problem at hand.
}
\details{
The suggested model size is the smallest model size for which either
the lower or upper bound (depending on argument \code{type}) of the
normal-approximation confidence interval (with nominal coverage \code{1 - alpha}, see argument \code{alpha} of \code{\link[=summary.vsel]{summary.vsel()}}) for \eqn{u_k -
  u_{\mbox{base}}}{u_k - u_base} (with \eqn{u_k} denoting the \eqn{k}-th
submodel's utility and \eqn{u_{\mbox{base}}}{u_base} denoting the baseline
model's utility) falls above (or is equal to) \deqn{\mbox{pct} * (u_0 -
  u_{\mbox{base}})}{pct * (u_0 - u_base)} where \eqn{u_0} denotes the null
model utility. The baseline is either the reference model or the best
submodel found (see argument \code{baseline} of \code{\link[=summary.vsel]{summary.vsel()}}).

For example, \code{alpha = 0.32}, \code{pct = 0}, and \code{type = "upper"} means that we
select the smallest model size for which the upper bound of the confidence
interval for \eqn{u_k - u_{\mbox{base}}}{u_k - u_base} with coverage 68\%
exceeds (or is equal to) zero, that is, for which the submodel's utility is
at most one standard error smaller than the baseline model's utility.
}
\note{
Loss statistics like the root mean-squared error (RMSE) and the
mean-squared error (MSE) are converted to utilities by multiplying them by
\code{-1}, so a call such as \code{suggest_size(object, stat = "rmse", type = "upper")} finds the smallest model size whose upper confidence interval
bound for the \emph{negative} RMSE or MSE exceeds the cutoff (or, equivalently,
has the lower confidence interval bound for the RMSE or MSE below the
cutoff). This is done to make the interpretation of argument \code{type} the
same regardless of argument \code{stat}.

The intercept is not counted by \code{\link[=suggest_size]{suggest_size()}}, so a suggested size of
zero stands for the intercept-only model.
}
\examples{
if (requireNamespace("rstanarm", quietly = TRUE)) {
  # Data:
  dat_gauss <- data.frame(y = df_gaussian$y, df_gaussian$x)

  # The "stanreg" fit which will be used as the reference model (with small
  # values for `chains` and `iter`, but only for technical reasons in this
  # example; this is not recommended in general):
  fit <- rstanarm::stan_glm(
    y ~ X1 + X2 + X3 + X4 + X5, family = gaussian(), data = dat_gauss,
    QR = TRUE, chains = 2, iter = 500, refresh = 0, seed = 9876
  )

  # Variable selection (here without cross-validation and with small values
  # for `nterms_max`, `nclusters`, and `nclusters_pred`, but only for the
  # sake of speed in this example; this is not recommended in general):
  vs <- varsel(fit, nterms_max = 3, nclusters = 5, nclusters_pred = 10,
               seed = 5555)
  print(suggest_size(vs))
}

}
