library(data.table)
library(stringr)
library(raster)
library(ggplot2)
library(rgeos)
library(maptools)
library()

# 구글키
mykey = 'AIzaSyCquUhfZH1TW1aSxfEwQOAtmVFc6RqVPfg'

# lat/lon computation
station <- fread("Example/data/stations.csv")

station$전철역명 <- ifelse(str_detect(station$전철역명, "역"), station$전철역명, paste0(station$전철역명, "역"))

station_latlon <- mutate_geocode(station, 전철역명)

# 지도 불러오기
p <- get_googlemap("seoul", zoom = 11) %>% ggmap


#호선 색상 저장
color_list = c("#0052A4", "#009D3E", "#EF7C1C", "#00A5DE", "#996CAC", "#CD7C2F", "#747F00", "#EA545D", "#BDB092")

#행정구역 표시

korea <- shapefile('SIG_202101/TL_SCCO_SIG.shp') %>%
  spTransform(CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

korea$SIG_KOR_NM <- iconv(korea$SIG_KOR_NM, from = "CP949", to = "UTF-8", sub = NA, mark = TRUE, toRaw = FALSE) # change encoding


korea <- fortify(korea, region = "SIG_CD")

korea$id <- as.numeric(korea$id)

seoul_map <- korea[korea$id <= 11740, ]




save.image(file = "Example/data/station_latlon.RData")
