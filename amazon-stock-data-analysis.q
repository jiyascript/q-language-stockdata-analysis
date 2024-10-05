symbol: "AMZN"
apikey: "5DTFUUQT8BPWOS0I"
url: "\"https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=", symbol, "&apikey=", apikey, "&datatype=csv\""

// fetching the stock data and saving to CSV
cmd: "curl -o amznstock.csv ", url
system cmd

stockData: ("DSFFFF"; enlist ",") 0:`:amznstock.csv
cols stockData

// calculate daily statistics: avg price and total vol for each day
dailyStats: select avgPrice: avg close, totalVolume: sum volume by timestamp from stockData

// calculate weekly statistics: avg price and total volume by week
startOfWeek: {x - x mod 7}
weeklyStats: select avgPrice: avg close, totalVolume: sum volume by week: startOfWeek timestamp from stockData
weeklyStats

// max closing price from the weekly stats
maxWeeklyClose: select maxClose: max avgPrice from weeklyStats
// week with the max total volume
maxVolumeWeek: select from weeklyStats where totalVolume = max totalVolume

//price change
weeklyStats: update priceChange: 100 * (avgPrice - prev avgPrice) % prev avgPrice from weeklyStats

show weeklyStats