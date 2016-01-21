library(nanex)
library(gtStats)

data <- Read(nanex_trades)

sample <- ReservoirSample(data,100)

View(sample)


