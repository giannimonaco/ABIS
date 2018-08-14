# ABsolute Immune Signal (ABIS) deconvolution

This Shiny app performs absolute deconvolution on RNA-Seq and microarray data.


## Run it on the web!

This shiny app is hosted online at the https://giannimonaco.shinyapps.io/ABIS/. It does not need R installation and it can be immediately used by just clicking on the link.

We suggest using ABIS from the web only for testing. For larger analysis we encourage to install the shiny app locally.

## Run it locally without installation

You need to download the app from GitHub through R and it will run locally. However, as soon as you will close R, the app will not be available anymore and you need it to download it again.
All the packages and dependecies need to be installed first.

install.packages(c("shiny", "MASS"), dependencies = TRUE)

runGitHub("ABIS", user="giannimonaco")

## Run it locally wit installation

Save the repository on your local machine. Open either the ui.r or the server.R file with RStudio.


---
This software is  released under the GPL v2 license, "which guarantees end users (individuals, organizations, companies) the freedoms to use, study, share (copy), and modify the software".