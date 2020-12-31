#Read data

#Read in aws credentials from config file
pw <- config::get("aws", file = "config.yml")

Sys.setenv("AWS_ACCESS_KEY_ID" = pw$AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" =  pw$AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = pw$AWS_DEFAULT_REGION
)

loadData <- function() {
  df <- s3readRDS(
    bucket = "surf-journal", 
    object = "surk-journal-data.rds"
  )
}

wgs84<-st_crs("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")

old_data <- loadData()
old_data_sf <- loadData() %>% st_as_sf(., coords = c("surfed_where_lng", "surfed_where_lat"), crs=wgs84)
