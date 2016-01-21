library(gtBase)
library(nanex)

data <- Read(nanex_trades)
agg <- Segmenter(
  GroupBy(data,
          group=c(Date, Hour=(MsOfDay %/% 1000)/3600),
          cnt=Count()
         ));

agg <- OrderBy(agg, dsc(cnt), limit=20000);

WriteCSV(agg, "/tmp/topcount20000.csv", Date,Hour,cnt);

View(agg)

