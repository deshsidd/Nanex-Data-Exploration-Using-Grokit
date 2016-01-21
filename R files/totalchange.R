library(gtBase)
library(nanex)
library(methods)

data <- Read(nanex_trades)

market <- ReadCSV("/tmp/hourly_market_index.csv", c(,), header = TRUE, sep = "|")


agg <- Segmenter(
GroupBy(data,
group=c(SymbolMinute = MsOfDay %/% 60000 + base::DATETIME(Date)$AsMinutes(),Symbol),
OrderBy(LastTime = dsc(MsOfDay), inputs = Price, outputs = LastPrice, limit = 1),
OrderBy(FirstTime = asc(MsOfDay), inputs = Price, outputs = FirstPrice, limit = 1),
Count = Count(),
Total = Sum(Size)
));

agg <- Generate(agg, symbolchange = (FirstPrice - LastPrice) / FirstPrice)


datajoin <- Join( agg, SymbolMinute,market, Minute)

#datajoin <- OrderBy(datajoin, dsc(Count), limit = 200000)


final <- Generate(datajoin, totalchange= symbolchange - marketchange )


final <- OrderBy(final, asc(Minute), limit=200000);

View(final)