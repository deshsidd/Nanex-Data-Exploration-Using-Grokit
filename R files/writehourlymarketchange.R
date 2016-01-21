library(gtBase)
library(nanex)
library(methods)

data <- Read(nanex_trades)

agg <- Segmenter(
GroupBy(data,
group=c(Hour = MsOfDay %/% 3600000 + 24 * (Date$GetYear() * 366 + Date$GetDayOfYear()-1),Symbol),
OrderBy(LastTime = dsc(MsOfDay), inputs = Price, outputs = LastPrice, limit = 1),
OrderBy(FirstTime = asc(MsOfDay), inputs = Price, outputs = FirstPrice, limit = 1),
Count = Count(),
Total = Sum(Size)
));

##View(CountDistinct(agg, Hour))

market <- Segmenter(GroupBy(agg,group=Hour, Sum(FirstPrice), Sum(LastPrice),Min(FirstTime),Max(LastTime)))

market <- Generate(market, marketchange = (FirstPrice - LastPrice) / FirstPrice)



market <- OrderBy(market, asc(Hour), limit=200000);

View(market)

##WriteCSV(market, "/tmp/hourly_market_index.csv", Hour, marketchange);


