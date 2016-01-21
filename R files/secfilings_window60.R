# For each SEC filings, trades of the corresponding stock in the interval [time - before, time + after]
## are analyzed, where "time" is the time of the filing and "before", "after" are parameters.
## To reduce system load, only trades occurring on the same day as the filing are accounted for.
before <- 0
after <- 60

library(gtNanex)

## Trades can be filtered because all stocks filed with the SEC are equity stocks, not bonds.
events <- Load(SECFilings)
trades <- Load(nanex_trades)[Type == "Equity"]

events <- Generate(events, Date = Date(Time), Seconds = base::Time(Time)$as_seconds(), .overwrite = TRUE)

trades <- Join(trades, c(Symbol, Date), events, c(Symbol, Date))

trades <- Generate(trades, difference = Seconds - MsOfDay %/% 1000)
trades <- trades[.(-before) <= difference && difference <= .(after)]

info <- GroupBy(trades, c(ID, Time),
                NumTrades = Count(),
                SumVolume = Sum(Size),
                SumRevenue = Sum(Size * Price),
                OrderBy(LastTime = dsc(MsOfDay), inputs = c(LastPrice = Price, LastSize = Size), limit = 1),
                OrderBy(FirstTime = asc(MsOfDay), inputs = c(FirstPrice = Price, FirstSize = Price), limit = 1))

## info <- Generate(info, LastTime = base::Time(LastTime), FirstTime = base::Time(FirstTime), .overwrite = TRUE)

WriteCSV(info, "/tmp/hourly_market_index.csv");


##View(info)