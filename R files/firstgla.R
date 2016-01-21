 library(gtTranslator)

 gla <- MakeGLA(representation = list(count = integer, sum = double),
                   prototype = function(count = 0L, sum = 0){},
                   AddItem = function(x) {sum = sum + x; count = count + 1L},
                   AddState = function(o) {sum = sum + o$sum; count = count + o$count},
                   GetResult = function(result = JSON) {return(average = sum / count, sum = sum, count = count)})

  data <- Read(nanex_trades)

  agg <- gla(data, inputs = Price, outputs = average)

  View(agg)