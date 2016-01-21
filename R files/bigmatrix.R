library(nanex)
library(gtStats)
library(methods)

data <- Read(nanex_trades)
data <- Generate(data, Seconds = MsOfDay %/% 1000 + DateTime(Date)$AsSeconds())
##data <- Generate(data, Index=Seconds-
View(Multiplexer(data, min = Min(Seconds), max = Max(Seconds)))


charts <- GroupBy(data, group = Symbol,
                  chart = LineChart(inputs = c(MsOfDay / 3600000, Price), length = 24),
                  cnt = Count())[cnt > 100]

View(charts[Symbol == "SUMRW" || Symbol == "RFID"])

covariance <- BigMatrix(charts, inputs = c(Symbol, chart), outputs = c(x, y, covariance))[x != y]

ordering <- OrderBy(covariance, dsc(covariance), limit = 200000)

View(ordering)