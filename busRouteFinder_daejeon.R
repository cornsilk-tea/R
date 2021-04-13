#대전에서 운행중인 버스 한대 선택해서 
#그 버스가 현재 어디에위치해있는지 지도에 출력해주는 함수를 작성
install.packages("XML")
install.packages("ggmap")
library(XML)
library(ggmap)

busRtNm <- "OOO"  #검색하고 싶은 버스 번호
API_key <- "########################" #api키 할당(노선정보조회 서비스)
url <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busRouteInfo/getRouteInfoAll?serviceKey=", API_key, "&reqPage=1", sep="")
xmefile <- xmlParse(url)
df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
df_busRoute <- subset(df, ROUTE_NO==busRtNm)
API_key <- "#################"  #api키 할당(버스위치정보조회 서비스)
url <- paste("http://openapitraffic.daejeon.go.kr/api/rest/busposinfo/getBusPosByRtid?busRouteId=", df_busRoute$ROUTE_CD, "&serviceKey=", API_key, sep="")
xmefile <- xmlParse(url)
df <- xmlToDataFrame(getNodeSet(xmefile, "//itemList"))
gpsX <- as.numeric(as.character(df$GPS_LONG))
gpsY <- as.numeric(as.character(df$GPS_LATI))
gc <- data.frame(lon=gpsX, lat=gpsY)
register_google(key = '################')#api키 할당(Google Maps Platform)
cen <- c(mean(gc$lon), mean(gc$lat))
map <- get_googlemap(center=cen, maptype="roadmap",zoom=12, marker=gc)
ggmap(map, extent="device")
