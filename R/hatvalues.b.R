
# This file is a generated template, your changes will not be overwritten

hatvaluesClass <- if (requireNamespace('jmvcore', quietly=TRUE)) R6::R6Class(
    "hatvaluesClass",
    inherit = hatvaluesBase,
    private = list(
        .run = function() {
            lm_mod <- jmvcore::constructFormula(self$options$dv,
                                                 self$options$iv)
            lm_mod <- stats::as.formula(lm_mod)
            lm_out <- stats::lm(lm_mod, self$data)
            lm_summary <- summary(lm_out)
            textres <- paste0(capture.output(print(lm_summary)), collapse = "\n")
            lm_coef <- lm_summary$coefficients
            coeftable <- self$results$coeftable
            lm_term<- rownames(lm_coef)
            names(lm_term) <- rownames(lm_coef)
            coeftable$setRow(rowNo = 1,
                values = list(
                            term = "Constant",
                            coef = lm_coef["(Intercept)", "Estimate"],
                            se = lm_coef["(Intercept)", "Std. Error"],
                            t = lm_coef["(Intercept)", "t value"],
                            p = lm_coef["(Intercept)", "Pr(>|t|)"]
                          )
              )
            for (i in lm_term[-1]) {
                coeftable$addRow(
                    rowKey = i,
                    values = list(
                        term = i,
                        coef = lm_coef[i, "Estimate"],
                        se = lm_coef[i, "Std. Error"],
                        t = lm_coef[i, "t value"],
                        p = lm_coef[i, "Pr(>|t|)"]
                      )
                  )
                }
            lm_hat <- stats::hatvalues(lm_out)
            if (self$results$hv$isNotFilled()) {
                self$results$hv$setRowNums(rownames(self$data))
                # self$results$hv$setValues(rep(0, nrow(self$data)))
                self$results$hv$setValues(lm_hat)
              }
            textres <- paste0(c(textres,
                              capture.output(head(lm_hat))),
                              collapse = "\n")
            self$results$text$setContent(textres)
          }
    )
)
