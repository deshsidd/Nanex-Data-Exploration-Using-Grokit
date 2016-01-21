library(gtBase)
library(nanex)
library(methods)

#data <- Bernoulli(Read(nanex_trades), 0.0001)
datatemp <- Read(nanex_trades)


 
data <- datatemp[Date==.(as.Date("2008-11-21"))]

agg <- Segmenter(
  GroupBy(data,
          group=c(Hour = MsOfDay %/% 3600000 + 24 * (Date$GetYear() * 366 + Date$GetDayOfYear() - 1), Symbol),
          OrderBy(dsc(MsOfDay), inputs = Price, limit = 1),
          Count = Count(),
          Total = Sum(Size)
         ));

agg <- OrderBy(agg, dsc(Count), limit=200000);

View(agg)