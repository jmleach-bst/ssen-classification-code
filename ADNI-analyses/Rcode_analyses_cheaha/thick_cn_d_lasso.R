########################
# CT: CN vs. D (lasso) #
########################

library(tidyverse)
library(sim2Dpredictr)
library(BhGLM)
library(rstan)
rstan_options(auto_write = TRUE)
library(ssnet)

# neighborhood information for Desikan-Killiany Atlas
dk_nb <- readRDS(file = "/data/user/jleach/adni/data/dk_nb.rds")

## pre-specify stan model
sm <- stan_model(file = "/data/user/jleach/adni/data/iar_incl_prob_notau.stan")

# cortical thickness data for various visits
thick.sc <- readRDS(file = "/data/user/jleach/adni/data/thick_sc.rds")

# obtain necessary data
sc.cn.d <- thick.sc[thick.sc$DIAGNOSIS != "MCI", ] %>%
  mutate(y = ifelse(DIAGNOSIS == "Dementia", 1, 0))

# reproduce results
set.seed(28372)

# fit model(s)
sc.l <- compare_ssnet(x = 0.2 * scale(as.matrix(sc.cn.d[, grep("ST.*", names(sc.cn.d), perl = TRUE)])),
                      y = sc.cn.d$y, models = c("glmnet", "ss", "ss_iar"),
                      im.res = NULL, alpha = 1,
                      family = "binomial", model_fit = "all",
                      variable_selection = FALSE, verbose = FALSE,
                      classify = TRUE, classify.rule = 0.5,
                      type_error = "kcv", nfolds = 5, ncv = 10,
                      fold.seed = 819187,
                      iar.data = dk_nb,
                      # tau.prior = "none",
                      stan_manual = sm,
                      s0 = seq(0.01, 0.5, 0.01),
                      s1 = seq(1, 10, 0.5),
                      output_param_est = TRUE,
                      output_cv = TRUE)

# save
saveRDS(sc.l, file = "/data/user/jleach/adni/results/thickness_sc_cn_d_lasso_grid.rds")
