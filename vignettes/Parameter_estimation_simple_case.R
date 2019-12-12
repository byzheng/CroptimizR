params <-
list(eval_rmd = FALSE)

## ----setup, eval=TRUE, include=FALSE------------------------------------------
# Global options
knitr::opts_chunk$set(eval = params$eval_rmd)

## ----setup_initializations,  message=FALSE, results=FALSE, warning=FALSE------
#  
#  # Install and load the needed libraries
#  if(!require("SticsRPacks")){
#    devtools::install_github("SticsRPacks/SticsRPacks")
#    library("SticsRPacks")
#  }
#  
#  # Download the example USMs:
#  data_dir= normalizePath(tempdir(), winslash = "/", mustWork = FALSE)
#  data_dir_zip= normalizePath(file.path(data_dir,"master.zip"), winslash = "/", mustWork = FALSE)
#  download.file("https://github.com/SticsRPacks/data/archive/master.zip", data_dir_zip)
#  unzip(data_dir_zip, exdir = data_dir)
#  unlink(data_dir_zip)
#  data_dir= file.path(normalizePath(list.dirs(data_dir)[2], winslash = "/"),"study_case_1","V9.0")
#  # NB: all examples are now in data_dir
#  
#  # Define the path to the local version of JavaStics
#  javastics_path=file.path(getwd(),"JavaSTICS-1.41-stics-9.0")
#  stics_path=file.path(javastics_path,"bin/stics_modulo.exe")

## ----gen_dirs, results='hide', message=FALSE, warning=FALSE-------------------
#  stics_inputs_path=file.path(data_dir,"TxtFiles")
#  dir.create(stics_inputs_path)
#  
#  gen_usms_dirs(javastics_path = javastics_path, javastics_workspace_path = file.path(data_dir,"XmlFiles"),
#    target_path = stics_inputs_path, display = TRUE)
#  

## ----results='hide', message=FALSE, warning=FALSE-----------------------------
#  
#  # Set the model options (see '? stics_wrapper_options' for details)
#  model_options=stics_wrapper_options(stics_path,stics_inputs_path,
#                                      parallel=FALSE)
#  
#  # Run the model on all situations found in stics_inputs_path
#  sim_before_optim=stics_wrapper(model_options=model_options)
#  

## ----message=FALSE, warning=FALSE---------------------------------------------
#  
#  sit_name="bo96iN+"  ## among bo96iN+, bou00t1, bou00t3, bou99t1, bou99t3,
#                      ## lu96iN+, lu96iN6 or lu97iN+
#  
#  # For the moment read_obs is only able to read obs files in one folder ...
#  # this will change in future release of sticsRfiles
#  obs_list=read_obs(file.path(data_dir,"XmlFiles"),
#                            obs_filenames = paste0(sit_name,".obs"))
#  
#  var_name="lai_n"    ## lai_n or masec_n
#  obs_list[[sit_name]]=obs_list[[sit_name]][,c("Date",var_name)]
#  

## ----message=FALSE, warning=FALSE---------------------------------------------
#  # 2 parameters here: dlaimax and durvieF, of prior distributions U([0.0005,0.0025]) and U([50,400])
#  prior_information=list(lb=c(dlaimax=0.0005, durvieF=50),
#                         ub=c(dlaimax=0.0025, durvieF=400))

## ----message=FALSE, warning=FALSE---------------------------------------------
#  optim_options=list()
#  optim_options$nb_rep <- 1 #7 # Number of repetitions of the minimization
#                            # (each time starting with different initial
#                            # values for the estimated parameters)
#  optim_options$maxeval <- 1 #500 # Maximum number of evaluations of the
#                               # minimized criteria
#  optim_options$xtol_rel <- 1e-03 # Tolerance criterion between two iterations
#                                  # (threshold for the relative difference of
#                                  # parameter values between the 2 previous
#                                  # iterations)
#  optim_options$path_results <- getwd() # path where to store the results (graph and Rdata)
#  optim_options$ranseed <- 1234 # set random seed so that each execution give the same results
#                                # If you want randomization, don't set it.
#  

## ----results='hide', message=FALSE, warning=FALSE-----------------------------
#  optim_results=main_optim(obs_list=obs_list,
#                              model_function=stics_wrapper,
#                              model_options=model_options,
#                              optim_options=optim_options,
#                              prior_information=prior_information)
#  

## ----echo=TRUE, eval=FALSE----------------------------------------------------
#  ## [1] "Estimated value for dlaimax :  0.00169614928696274"
#  ## [1] "Estimated value for durvieF :  53.9691276907021"
#  ## [1] "Minimum value of the criterion : 112.530331140718"

## ----eval=TRUE, echo=FALSE, out.width = '50%'---------------------------------

knitr::include_graphics("ResultsSimpleCase/estimInit_dlaimax.PNG")

knitr::include_graphics("ResultsSimpleCase/estimInit_durvieF.PNG")


## ----eval=FALSE, echo=TRUE----------------------------------------------------
#  load(file.path(optim_options$path_results,"optim_results.Rdata"))
#  nlo[[2]]

## ----echo=FALSE, eval=TRUE----------------------------------------------------
load(file.path("ResultsSimpleCase","optim_results.Rdata"))
print(nlo[[2]])

## ----message=FALSE, warning=FALSE---------------------------------------------
#  sim_after_optim=stics_wrapper(param_values=optim_results$final_values,
#                                model_options=model_options)

## ----results='hide', warning=FALSE, message=FALSE-----------------------------
#  png(file.path(optim_options$path_results,"sim_obs_plots.png"),
#      width = 15, height = 10, units = "cm", res=1000)
#  par(mfrow = c(1,2))
#  
#  # Simulated and observed LAI before optimization
#  Ymax=max(max(obs_list[[sit_name]][,var_name], na.rm=TRUE),
#           max(sim_before_optim$sim_list[[sit_name]][,var_name], na.rm=TRUE))
#  plot(sim_before_optim$sim_list[[sit_name]][,c("Date",var_name)],type="l",
#       main="Before optimization",ylim=c(0,Ymax+Ymax*0.1))
#  points(obs_list[[sit_name]],col="green")
#  
#  # Simulated and observed LAI after optimization
#  plot(sim_after_optim$sim_list[[sit_name]][,c("Date",var_name)],type="l",
#       main="After optimization",ylim=c(0,Ymax+Ymax*0.1))
#  points(obs_list[[sit_name]],col="green")
#  
#  dev.off()

## ----eval=TRUE, echo=FALSE, message=FALSE, out.width = '80%', fig.cap="Figure 2: plots of simulated and observed target variable before and after optimization. The gap between simulated and observed values has been drastically reduced: the minimizer has done its job!"----
knitr::include_graphics("ResultsSimpleCase/sim_obs_plots.png")
