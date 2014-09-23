########### R script to analyze historic weather data for temperature
## Connection handle con to BLU for Cloud data warehouse is provided already
## For plotting, we are using ggplot2 package
##
## Data for multiple stations is shown in different colors
## 
library(ggplot2)
library(bluR)

## initialize DB2 connection and environment
con <- bluConnect("BLUDB","","")
bluAnalyticsInit(con)

## query DB2 weather data and fetch min/max values of min/max values
## (lower/upper boundary each) 
query<-paste('select max(lufttemperatur_maximum) as maxmax,min(lufttemperatur_minimum) as minmin,min(lufttemperatur_maximum) as minmax,max(lufttemperatur_minimum) as maxmin,tag,sid from (select lufttemperatur_maximum, lufttemperatur_minimum, day(mdatum) as tag,sid from blu06039.klima where month(mdatum)=9) group by tag,sid order by tag asc') 
df <- bluQuery(query,as.is=F)

## Some plotting needs to be done
jpeg(type='cairo',"tempe.jpg",width=800,height=600) 
ggplot(df, aes(x = TAG))+ylab("Temperature")+xlab("Day")+               
     geom_line(aes(y = MAXMAX, group=SID, colour=SID)) 

sink('/dev/null') 

bluClose(con)
## connection is closed, we are done
