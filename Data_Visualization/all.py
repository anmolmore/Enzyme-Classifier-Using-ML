### Sudhir.wadhwa@gmail.com
######################################################################
####
#### This code is written by Sudhir Wadhwa, Jyoti Wadhwa for education purpose only
#### Welcome your feedback 
#### You can reach me at skwadhwa@scu.edu 
#### cc sudhir.wadhwa@gmail.com  
######################################################################

import json
import urllib.request
from datetime import datetime

def writetothefile1(bitcointotal, etherstotal, ltctotal, grandTotal):
    currenttime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    fh = open("D:\coin.csv", "a")
    fh.write( 'TIME '+ str(currenttime)+"," + str(bitcointotal)+","+ str(etherstotal)+","+ str(ltctotal)+","+ str(grandTotal) + "\n")
    fh.close

numberofethers = 1.0246   
ethurl = "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD"
ethdata = json.load(urllib.request.urlopen(ethurl))
etherstotal =  (ethdata['USD']* numberofethers)

numberofbtc = 1.0120
btcurl = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD"
btcdata = json.load(urllib.request.urlopen(btcurl))
bitcointotal =  (btcdata['USD'] * numberofbtc)

numberofltc =  1.0873   
ltcurl = "https://min-api.cryptocompare.com/data/price?fsym=LTC&tsyms=USD"
ltcdata = json.load(urllib.request.urlopen(ltcurl))
ltctotal =  (ltcdata['USD'] * numberofltc)

grandTotal = etherstotal + bitcointotal + ltctotal

print ("====================================")
print ("Ethers : ", "Dollars", numberofethers,"Numbers", etherstotal)
print ("Bitcoin: ", "Dollars", bitcointotal, "Numbers", numberofbtc)
print ("Litecoin: ", "Dollars", ltctotal, "Numbers", numberofltc)
print ("Grand Total is : ", grandTotal)
print ("====================================")


writetothefile1(bitcointotal, etherstotal, ltctotal, grandTotal)
