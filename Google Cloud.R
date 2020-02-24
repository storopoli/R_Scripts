library(googleComputeEngineR)

## list your VMs in the project/zone
the_list <- gce_list_instances()
default_project <- gce_get_project()

# List Machine Types
machines_types <- gce_list_machinetype()
View(machines_types$items)

# List Images
gce_list_images(image_project = "debian-cloud")

# List Instances
gce_list_instances()

## start a new instance
vm <- gce_vm(template = "rstudio",
             name = "rstudio-server",
             username = "storopoli", password = "duda1234",
             predefined_type = "n1-highmem-2")


vm$status

# Logging into instance
gce_ssh_browser("rstudio-server")
gce_

## stop VM
vm <- gce_vm_stop("rstudio-server")
