library(nanex)

data <- Read(nanex_trades)

agg <- Segmenter(GroupBy(
  data,
  group = c(HourID = MsOfDay %/% 3600000 + 24 * (Date$GetYear() * 366 + Date$GetDayOfYear() - 1),Symbol),
  OrderBy(LastTime = dsc(MsOfDay), inputs = Price, outputs = LastPrice, limit = 1),
  OrderBy(FirstTime = asc(MsOfDay), inputs = Price, outputs = FirstPrice, limit = 1),
  Count = Count(),
  Total = Sum(Size)
))



market <- Generate(agg, marketchange = (FirstPrice - LastPrice) / FirstPrice, Hour = HourID %% 24)

market <- market[.(5) <= Hour && Hour <= .(8)]
## No need for a limit here. There are less than 40,000 hours in the data. 
market <- OrderBy(market, dsc(Total),limit=200000)

View(market)