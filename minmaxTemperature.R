########### R script to analyze historic weather data for min/max values
## Written by Henrik Loeser
## Connection handle con to BLU for Cloud data warehouse is provided already
## For plotting, we are using ggplot2 package
## 
library(ggplot2)
library(bluR)

## initialize DB2 connection and environment
con <- bluConnect("BLUDB","","")
bluAnalyticsInit(con)

## query DB2 weather data and fetch min/max values of min/max values
## (lower/upper boundary each) 
query<-paste('select max(lufttemperatur_maximum) as maxmax,min(lufttemperatur_minimum) as minmin,min(lufttemperatur_maximum) as minmax,max(lufttemperatur_minimum) as maxmin,tag from (select lufttemperatur_maximum, lufttemperatur_minimum, day(mdatum) as tag from blu01023.klima where month(mdatum)=9) group by tag order by tag asc') 
df <- bluQuery(query,as.is=F)

## Some plotting needs to be done
jpeg(type='cairo',"tempe.jpg",width=800,height=600) 
ggplot(df, aes(x = TAG))+ylab("Temperature")+xlab("Day")+               
     geom_ribbon(aes(ymin = MINMIN, ymax=MAXMIN), fill='blue')+
     geom_ribbon(aes(ymin = MAXMAX, ymax=MINMAX), fill='red')+
     geom_ribbon(aes(ymin = MAXMIN, ymax=MINMAX), fill='white')+
     geom_line(aes(y = MINMIN), colour = 'black') +
     geom_line(aes(y = MAXMIN), colour = 'black') +
     geom_line(aes(y = MINMAX), colour = 'black') +
     geom_line(aes(y = MAXMAX), colour = 'black') 

sink('/dev/null') 

bluClose(con)
## connection is closed, we are done
