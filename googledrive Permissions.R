library(tidyverse)
library(googledrive)  # the package used to iterface with the google api

# Function to retrieve email addresses of permissions (read/write) --------

get_permissions_df <- function(permission_list){
  map_df(permission_list, ~{
    if (!is.null(.$emailAddress)){
      tibble(user_email = .$emailAddress, user_role = .$role)
    } else {
      tibble(user_email = NA, user_role = NA)
    }
  })
}


# Read the contents of the folder -----
# note that the first time you run this, you will be asked to login into your gmail using a web browser.
folder_contents <- drive_ls(as_id("<FOLDER ID OR URL>")) # replace here with the URL or ID of the folder.
folder_contents <- drive_ls(recursive = T) # for all files

# Get a tidy form of all shares and permissions of subfolders
tidy_permissions <- folder_contents %>% 
  mutate(new_creds = 
           map(drive_resource, 
               ~{get_permissions_df(.$permissions)})
  ) %>% 
  select(name, new_creds) %>% 
  unnest(new_creds) %>% 
  filter(!is.na(user_email))

# Optional - turn into a wider form where each column is a user,
# each row is a subfolder, and values are permissions of users.

wide_permissions <- tidy_permissions %>% 
  distinct(name, user_email, .keep_all = T) %>% 
  pivot_wider(id_cols = name, 
              names_from = user_email, values_from = user_role, values_fill = list(user_role = "none"))
