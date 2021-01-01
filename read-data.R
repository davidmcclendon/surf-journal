#Read data

#Read in aws credentials from config file

app_password <- config::get("submit", file = "config.yml")$app_pw

pw <- config::get("aws", file = "config.yml")

Sys.setenv("AWS_ACCESS_KEY_ID" = pw$AWS_ACCESS_KEY_ID,
           "AWS_SECRET_ACCESS_KEY" =  pw$AWS_SECRET_ACCESS_KEY,
           "AWS_DEFAULT_REGION" = pw$AWS_DEFAULT_REGION
)

loadData <- function() {
  #df <- read_csv("https://surf-journal.s3.us-east-2.amazonaws.com/surf-journal-data.csv")
  df <- s3readRDS(
    bucket = "surf-journal",
    object = "surf-journal-data.rds"
  )
  return(df)
}

wgs84<-st_crs("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")

