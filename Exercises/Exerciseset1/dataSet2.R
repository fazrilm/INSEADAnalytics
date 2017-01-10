
# rm(list=ls()) # Clean up the memory, if we want to rerun from scratch
# source("helpersSet1.R")

getdata.fromscratch.2 = 2

website_used = "yahoo" # can be "yahoo" or other ( see help(getSymbols) ). Depending on the website we may need to change the stock tickers' representation
mytickers_2 = c("SPY", "AAPL", "YHOO", "GS", "MSFT")  # Other tickers for example are "GOOG", "GS", "TSLA", "FB", "MSFT", 
startDate = "2001-01-01"

if (getdata.fromscratch.2){
  # Get SPY first, to get all trading days
  tmp_2<-as.matrix(try(getSymbols(Symbols="SPY",from = startDate,src = website_used, auto.assign=FALSE)))
  StockPrices_2=matrix(rep(0,nrow(tmp_2)*length(mytickers_2)), ncol=length(mytickers_2))
  colnames(StockPrices_2)<-mytickers_2; 
  rownames(StockPrices_2)<-rownames(tmp_2)
  StockVolume_2=StockPrices_2
  StockPrices_2[,1] <- tmp_2[,6]
  
  for (ticker_index in 2:length(mytickers_2)){
    ticker_to_get_2 = mytickers_2[ticker_index]
    print(paste("\nDownloading ticker ", ticker_to_get, " ..."))
    tmpdata_2<-as.matrix(try(getSymbols(Symbols=ticker_to_get_2,from = startDate,auto.assign=FALSE)))
    if (!inherits(tmpdata_2, "try-error"))
    {
      therownames=intersect(rownames(tmpdata_2),rownames(StockPrices_2))
      tmpdata_2[is.na(tmpdata_2)] <- 0
      StockPrices_2[therownames,ticker_index]<-tmpdata_2[therownames,6] # adjusted close price
      StockVolume_2[therownames,ticker_index]<-tmpdata_2[therownames,5] # shares volume for now - need to convert to dollars later
    } else {
      cat(ticker_to_get_2," NOT found")
    }
  }
  # Get the daily returns now. Use the simple percentage difference approach 
  StockReturns_2= ifelse(head(StockPrices_2,-1)!=0, (tail(StockPrices_2,-1)-head(StockPrices_2,-1))/head(StockPrices_2,-1),0) # note that this removes the first day as we have no way to get the returns then!
  rownames(StockReturns_2)<-tail(rownames(StockPrices_2),-1) # adjust the dates by 1 day now
  
  # Now remove the first day from the other data, too
  StockPrices_2 = StockPrices_2[rownames(StockReturns_2),]
  StockVolume_2 = StockPrices_2[rownames(StockReturns_2),]
  colnames(StockPrices_2)<-mytickers_2
  colnames(StockVolume_2)<-mytickers_2
  colnames(StockReturns_2)<-mytickers_2
  
  save(StockReturns_2,StockPrices_2,StockVolume_2, file = "DataSet2.Rdata")
} else {
  load("DataSet2.Rdata")
}



