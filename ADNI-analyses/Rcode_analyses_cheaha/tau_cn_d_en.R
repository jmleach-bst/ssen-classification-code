##########################
# Tau PET: CN vs. D (en) #
##########################

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

# tau data for various visits
tau.bl <- readRDS(file = "/data/user/jleach/adni/data/tau_bl.rds")

# obtain necessary data
tau.bl.cn.d <- tau.bl[tau.bl$DIAGNOSIS != "MCI", ] %>%
  mutate(y = ifelse(DIAGNOSIS == "Dementia", 1, 0))

rm.unknown <- c("CTX_LH_UNKNOWN_SUVR", "CTX_RH_UNKNOWN_SUVR")

tau.bl.cn.d <- tau.bl.cn.d[ , !(names(tau.bl.cn.d) %in% rm.unknown)]

# reproduce results
set.seed(2738764)

# fit model(s)
tau.bl.en <- compare_ssnet(x = 0.2 * scale(as.matrix(tau.bl.cn.d[, grep("CTX.*", names(tau.bl.cn.d),
                                                            perl = TRUE)])),
                      y = tau.bl.cn.d$y, models = c("glmnet", "ss", "ss_iar"),
                      im.res = NULL, alpha = 0.5,
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
saveRDS(tau.bl.en, file = "/data/user/jleach/adni/results/tau_bl_cn_d_en_grid.rds")
