
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CroptimizR: An R package for parameter estimation, uncertainty analysis and sensitivity analysis for Crop Models

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Travis build
status](https://travis-ci.org/SticsRPacks/CroptimizR.svg?branch=master)](https://travis-ci.org/SticsRPacks/CroptimizR)
[![Codecov test
coverage](https://codecov.io/gh/SticsRPacks/CroptimizR/branch/master/graph/badge.svg)](https://codecov.io/gh/SticsRPacks/CroptimizR?branch=master)

## Overview

This package is dedicated to Probabilistic Uncertainty analysis,
Sensitivity analysis and Parameter estimation for crop models.

It is under intensive development, so you can fill an issue or request a
feature [here](https://github.com/SticsRPacks/CroptimizR/issues) at any
time. The list of functions accessible to the users is provided in this
[webpage](https://sticsrpacks.github.io/CroptimizR/reference/index.html).

For the moment, only parameter estimation functions have been
developped. The
([`estim_param`](https://sticsrpacks.github.io/CroptimizR/reference/estim_param.html))
function can be used to perform parameter estimation using multi-start
Nelder-Meade simplexe minimization of [different least square
criterion](https://sticsrpacks.github.io/CroptimizR/reference/ls_criterion.html).

Functionnalities for simultaneous estimation of varietal and specific
parameters are provided (see
[here](https://SticsRPacks.github.io/CroptimizR/articles/Parameter_estimation_Specific_and_Varietal.html)
for an example).

CroptimizR is designed to be crop model generic: all the functionalities
can be used on any crop model for which an R wrapper can be implemented.
For the moment, R wrappers are available for Stics and APSIM crop models
(see [SticsOnR](https://github.com/SticsRPacks/SticsOnR) and
[ApsimOnR](https://github.com/hol430/ApsimOnR)). A wrapper for
SiriusQuality is under development.

Guidelines for developping a wrapper for your favourite crop model are
given in the following
[vignette](https://SticsRPacks.github.io/CroptimizR/articles/Designing_a_model_wrapper.html).

Planned features, installation and examples of use are described in the
following sections.

## Planned features

### Probabilistic Uncertainty analysis

To evaluate the uncertainty of crop models outputs resulting from the
propagation of the uncertainty of their inputs for a given set of
simulated situations.

Main features:

  - inputs’ uncertainties will be described by the user using (usual)
    probability distributions or by users’ given sample (or a mixed of
    both depending on the parameters),

  - facilities will be provided to describe distributions of **groups of
    parameters** (soils, weather, farming practices, initial conditions)
    using map labelling techniques (i.e. distributions of identifiers of
    soil / weather / … files) ,

  - description of **joint probability distributions** including
    dependencies between parameters’ uncertainties should be provided,

  - tools for **probabilistic modeling** could be provided (e.g. to
    generate new values, from a sample given by the user, by assessing
    the probability distribution it is sampled from),

  - several methods wil be available to generate the numerical design of
    experiment: **full-factorial design, random sampling using different
    methods (LHS, Quasi-Monte Carlo …)**,

Results provided: numerical (moments, quantiles …) and graphical
(**histograms / density plots / boxplots / violins, correlation plots,
time series of quantiles for dynamic variables …**) description of the
sample of output variables obtained.

### Sensitivity analysis

To assess how the uncertainty of crop models outputs can be allocated to
the uncertainty of their inputs / to describe the effects of the
variations of crop models inputs on their outputs, for a given set of
simulated situations.

Main features:

  - inputs’ uncertainties will be described as for uncertainty analysis
    functionality,

  - several methods should be provided to cope with diverse users’
    needs:
    
      - **Screening methods** (e.g. Morris) for a quick assessment of
        the effect of numerous inputs,
    
      - **Importance measures**: correlation coefficients,
        Variance-based methods (Sobol, EFAST, PCE…), Moment independent
        methods, for a more precise assessment of their impact,
    
      - **Multivariate Sensitivity Analysis** methods to cope with
        temporal outputs,
    
      - **Graphical methods**: scatter plots, response surface, cobweb
        plots, …
    
      - Variants of these methods adapted to **dependent inputs** should
        be provided … (at least analysis per group of parameters)

Results provided: numerical and graphical representations (bar plots /
pie charts / temporal plots of sensitivity indices …) of the indices
depending on the method

### Parameter estimation / model calibration

To estimate the values of a selection of crop models parameters (soil,
plant …) from observations of a set of their output variables,

Main features:

  - procedures for **automatic selection of the parameters to estimate**
    from a given list (e.g. forward selection using criterions such as
    AIC, MSEP …)

  - facilities to describe and perform **calibration in different
    steps**: different parameters are estimated from different observed
    situations and variables at each step using different **forcings**
    (lai, phenological stages) and using the parameters values estimated
    at the preceding steps,

  - facilities to describe and take into account **prior information and
    constraints** (e.g. inequality constraints) on estimated parameters
    and output variables,

  - **facilities to transform model outputs** in case observations does
    not corresponds to the crop model outputs

  - **different types of criterion** to compare simulations and
    observations (i.e. of objective function to minimize) and different
    ways of combining these criteria for several variables:
    e.g. classical ordinary least-square, weighted-least-square,
    concentrated-likelihood for automatic estimation of error variances,
    criterion that take into account error correlations … (see
    e.g. Wallach et al., 2011)

  - different estimation methods:**frequentists (e.g. Nelder-Meade
    Simplex), Bayesians (e.g. multi-chain MCMC, SIR), global
    optimization (Evolutionnary Algorithms, GLUE), multi-objective
    methods, …**

  - methods for evaluating the **predictive performance** of the
    calibrated model (cross validation …)

Results provided:

  - estimated values and uncertainties of estimated parameters,

  - specific diagnostics depending on the estimation method used,

  - evaluation of the predictive performance of the calibrated model,

  - description of the calibration process followed.

## Installation

The last released version of the package can be installed from
[GitHub](https://github.com/) using:

``` r
devtools::install_github("SticsRPacks/CroptimizR@*release")
```

Or using the lightweight
[remotes](https://github.com/r-lib/remotes#readme) package:

``` r
# install.packages("remotes")
remotes::install_github("SticsRPacks/CroptimizR@*release")
```

The package is tested routinely to pass all
[CRAN](https://CRAN.R-project.org) tests using Travis-CI (linux) and
AppVeyor (Windows), but it is not yet released to the CRAN servers:
CroptimizR is still under development and users are not yet widespread
enough to bother CRAN people and use their free server time.

## Examples

A simple introductory example of model calibration using the Stics model
is given in this
[vignette](https://SticsRPacks.github.io/CroptimizR/articles/Parameter_estimation_simple_case.html).

A more complex one with simultaneous estimation of specific and varietal
parameters is given
[here](https://SticsRPacks.github.io/CroptimizR/articles/Parameter_estimation_Specific_and_Varietal.html).

An example using the ApsimX model is detailed
[here](https://SticsRPacks.github.io/CroptimizR/articles/ApsimX_parameter_estimation_simple_case.html).

See
[here](https://sticsrpacks.github.io/CroptimizR/reference/estim_param.html)
for a detailed description of the input and output arguments of the
estim\_param function (or type “? estim\_param” in an R console after
having installed and loaded the CroptimizR package).

## Code of conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

## Authors and acknowledgments

The CroptimizR package is developed by Samuel Buis, Michel Giner and the
[CroptimizR Team](https://github.com/orgs/SticsRPacks/teams/CroptimizR).
