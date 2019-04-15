#' Plot Diagnostic Plots with Resoduals
#' @description
#' Residual Plots with multiple residual types choices given a model.
#' Now have "lm", "glm", "lmer" three kinds of models, except the residual
#' types included in those models, we also have other residual types, such as
#' conditional residual, generalized residual and standrized residual.
#'
#' @param model Model fit using either \code{lm}, \code{glm}, \code{lmer},
#'   \code{redres}.
#' @param type Type of residuals to plot. For model \code{lm}, we have
#' "response", "pearson", "standardized"; for \code{glm}, we have "response",
#' "pearson", "deviance"; for \code{lmer}, we have "raw_cond", "raw_mar", "pearson_cond",
#' "pearson_mar", "std_cond", "std_mar", "genres".
#'
#' @export
#'
#' @importFrom broom augment
#' @importFrom ggplot2 aes_string geom_point ggplot xlab ylab geom_hline theme_bw
#'
#' @return A residual plot.
#'
#' @examples
#' # Fit a linear mixed effect model with a default (raw conditional) residual type.
#' library(lme4)
#' fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
#' plot_redres(fm1)
#' # Fit a linear mixed effect model with a conditional residual type.
#' plot_redres(fm1, type = "raw_cond")

plot_redres <- function(model, type = "raw_cond") {

  # Stop if not an lmer model
  if(!(class(model)[1]=="lmerMod")){
    stop("The current version of plot_genres requires a model input.
         Accepted model type is currently 'lmer'.")
  }

  # Stop if residual type is not specified correctly
  type <- tolower(type)
  if(!(type %in% c("raw_cond", "raw_mar", "pearson_cond", "pearson_mar", "std_cond", "std_mar"))){
        stop("Residual type requested is not provided by redres. Please see the documentation for the available types.")
  }

  # Put residuals and fitted values in a data frame
  df <- data.frame(Residual = redres(model = model, type = type),
                   Fitted = broom::augment(model)$.fitted)

  # Create the residual vs fitted plot
  ggplot(df, aes_string(x = "Fitted", y = "Residual")) +
    geom_point() +
    xlab(label = "fitted") +
    ylab(paste0(type, " residuals")) +
    geom_hline(yintercept = 0)
    theme_bw()
}