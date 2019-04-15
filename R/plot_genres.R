#' Generalized residual quantile plot
#' @description
#' Use to compare the generalized residuals to the uniform quantiles. Obvious departures indicate
#' a lack of fit.
#'
#' @param model Model fit using \code{lmer}.
#'
#' @export
#'
#' @importFrom ggplot2 aes_string ggplot theme_bw xlab ylab
#' @importFrom qqplotr stat_qq_band stat_qq_line stat_qq_point
#'
#' @details
#'
#' First section what is a generalized residual. Reiterate diagnostics.
#' Second section assumptions of lmer model

plot_genres <- function(model){

  # Return an error if an acceptable model type is not entered in the function
  if(!(class(model)[1]=="lmerMod")){
    stop("The current version of plot_genres requires a model input.
         Accepted model type is currently 'lmer'.")
  }

  # building dataframe
  g_df <- data.frame(y = model@resp$y, Residual = genres(model))

  # quantile plot from qqplotr
  ggplot(data = g_df, aes_string(sample = "Residual")) +
    qqplotr::stat_qq_band(bandType = "pointwise", distribution = "unif",
                          fill = "#FBB4AE", alpha = 0.4) +
    qqplotr::stat_qq_line(distribution = "unif", colour = "#FBB4AE") +
    qqplotr::stat_qq_point(distribution = "unif") +
    xlab("Uniform quantiles") +
    ylab("Generalized residuals") +
    theme_bw()
}