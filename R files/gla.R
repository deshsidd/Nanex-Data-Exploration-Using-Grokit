library(gtBase)
library(nanex)
library(gtTranslator)

Hist <- MakeGLA(
               representation = list(H = statistics::fixed_matrix(nrow=113L, ncol=101L)), ## histogram matrix
               prototype = function(H = zeros(113L, 101L)){},
               AddItem = function(i,x){
                 index = as.int(x);
                   H(i, index) = H(i, index)+1;
               },
               AddState = function(o) {
                 H = H + o$H
               },
               GetResult = function(result = JSON) {
                 return(histogram = H, bogus=1.0)
               })


data <- Read(nanex_trades)

agg <- 
  GroupBy(data,
          group=c(Symbol, Date),
          trades=Count(), ## number of trades
          strades=Sum( if(Size*Price < 10000) 1 else 0 ) ## number of small trades
         );

hist <- Hist(agg, inputs=c(12L*(Date$GetYear()-2005L)+Date$GetMonth()-1, 100*strades/trades), 
                  outputs=histogram
                 );

View(hist);