library(gtBase)
library(nanex)
library(methods)


#data <- Bernoulli(Read(nanex_trades), 0.5)
sample <- Bernoulli(Distinct(Load(nanex_trades)[Date == .(as.Date("2010-01-01"))], Symbol), 0.1)
nanex_trades <- Join(Load(nanex_trades)[Date == .(as.Date("2010-01-01"))], Symbol, sample, Symbol)
sym <- Read(nanex_symbols)
data <- Join(nanex_trades, c(Symbol), sym, c(Symbol))[Start <= Date && Date <= Stop]

View(CountDistinct(data, c(MsOfDay %/% 60000 + base::DATETIME(Date)$AsMinutes(),Symbol)))


agg <- Segmenter(
GroupBy(data,
group=c(Minute = MsOfDay %/% 60000 + base::DATETIME(Date)$AsMinutes(),Symbol),
OrderBy(LastTime = dsc(MsOfDay), inputs = Price, outputs = LastPrice, limit = 1),
OrderBy(FirstTime = asc(MsOfDay), inputs = Price, outputs = FirstPrice, limit = 1),
Count = Count(),
Total = Sum(Size)
));

##View(CountDistinct(agg, Hour))

market <- Segmenter(GroupBy(agg,group=Minute, Sum(FirstPrice), Sum(LastPrice),Min(FirstTime),Max(LastTime)))

market <- Generate(market, marketchange = (FirstPrice - LastPrice) / FirstPrice)



market <- OrderBy(market, asc(Minute), limit=200000);

View(market)

##WriteCSV(market, "/tmp/hourly_market_index.csv", Hour, marketchange);



