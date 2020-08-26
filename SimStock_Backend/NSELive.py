import json
import time
from selenium import webdriver
import pandas as pd
from datetime import datetime

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException

from firebase import firebase

firebase = firebase.FirebaseApplication(
    "https://smarttech-ee0de.firebaseio.com/", None
)

browser = webdriver.Chrome()

userStocks = firebase.get('/UserStocks',None)
print(userStocks)
df = pd.read_csv("EQUITY_L.csv")

allSymbols = df['SYMBOL']
dfallSymbols = pd.DataFrame(allSymbols)
allCompanyNames = df['NAME OF COMPANY']
dfallCompanyNames = pd.DataFrame(allCompanyNames)

isUserStock = False

symbols = []
companyNames = []
i = 0

if userStocks!=None and len(userStocks)!=0 :
    for stock in userStocks :
        symbols.append(stock)
        companyNames.append(allCompanyNames[dfallSymbols.values.tolist().index([stock])])
        
    print(allCompanyNames[dfallSymbols.values.tolist().index([stock])])
    isUserStock = True

else:
    symbols = df['SYMBOL']
    companyNames = df['NAME OF COMPANY']
    i = firebase.get('/StockCount',None)
    isUserStock = False


refreshcount = 0
refreshInnercount = 0
stockColor = 'Green'

iterationCount = 1

while True:
    symbols = []
    companyNames = []
    i = 0
    firebase.put('/','Iteration Number',iterationCount)
    iterationCount = iterationCount + 1

    if userStocks!=None and len(userStocks)!=0 and datetime.now().time()<datetime.fromtimestamp(1596362400).time():
        for stock in userStocks :
            symbols.append(stock)
            companyNames.append(allCompanyNames[dfallSymbols.values.tolist().index([stock])])
        
        print(allCompanyNames[dfallSymbols.values.tolist().index([stock])])
        isUserStock = True
    else:
        symbols = df['SYMBOL']
        companyNames = df['NAME OF COMPANY']
        i = firebase.get('/StockCount',None)
        isUserStock = False
    
    if datetime.now().time()>datetime.fromtimestamp(1596362400).time():
        i = 0

    while i < len(symbols):


        userStocks = firebase.get('/UserStocks',None)
        if(userStocks!=None and isUserStock==False and datetime.now().time()<datetime.fromtimestamp(1596362400).time()):
            break
        
        firebase.put('/','Running',1)
            
        browser.delete_all_cookies()
            
        url = (
            "https://www.nseindia.com/get-quotes/equity?symbol="
            + symbols[i]
        )
        browser.get(url)
        try:
            time.sleep(2.5)

            split = str(browser.page_source).split('<input id="gq-e-rangeslider1" type="range"')

            

            

            #<span id="priceInfoStatus" class="blkbox-redtxt">-9.80 (-3.53%)</span>


            if refreshcount==10 or refreshInnercount==10:
                i+=1            #Starting a new chrome widow if the current window fails even after 10 refresh
                browser.delete_all_cookies()
                browser.close()
                browser = webdriver.Chrome()
                browser.delete_all_cookies()

                

            if split == None or len(split)==0 or len(split[1].split('labels'))==0 or split[1].split('labels')==None and refreshcount < 10:      # Refreshing the page
                    print('Refreshing ' + str(refreshcount) + ' times')
                    refreshcount+=1
            else:                   
                refreshcount = 0                 # Reseting refresh so that every stock gets 10 chances.
                split2 = split[1].split('labels')
                allValues = split2[0]
                

                if  allValues.split('min="')==None or len(allValues.split('min="'))==0 or (allValues.split('min="')[1].split('"')[0] == '283.50' and refreshInnercount < 10) : # Refreshing the page by not incrementing i
                    print('RefreshingInner ' + str(refreshInnercount) + 'times')
                    refreshInnercount+=1
                else:
                    firebase.put('/','userStockCount',i) if isUserStock else firebase.put('/','StockCount',i) 
                    refreshInnercount = 0                               # Reseting refresh so that every stock gets 10 chances.

                    split2 = str(browser.page_source).split('<span id="priceInfoStatus" class="blkbox-')
                    stockInfo = ''
                    if(split2[1].startswith('red')):
                        stockColor = 'Red'
                        splitStockInfo = split2[1].split('</span>')
                        splitStockInfo3 = splitStockInfo[0].split('redtxt">')
                        stockInfo = splitStockInfo3[1]
                    else:
                        stockColor = 'Green'
                        splitStockInfo = split2[1].split('</span>')
                        splitStockInfo3 = splitStockInfo[0].split('greentxt">')
                        stockInfo = splitStockInfo3[1]
                    
                    allValuesSplitForLow = allValues.split('min="')
                    low = allValuesSplitForLow[1].split('"')[0]

                    allValuesSplitForHigh = allValues.split('max="')
                    high = allValuesSplitForHigh[1].split('"')[0]

                    allValuesSplitForValue = allValues.split('value="')
                    value = allValuesSplitForValue[1].split('"')[0]
                    
                    print(str(i) + ' ' + symbols[i] + ' ' + companyNames[i] + '\n' + allValues +'\n\n\n' )
                    
                    
                    firebase.put("/Stocks/"+companyNames[i], "StockID", symbols[i])
                    firebase.put("/Stocks/"+companyNames[i], "StockName", companyNames[i])
                    firebase.put("/Stocks/"+companyNames[i], "High", high)
                    firebase.put("/Stocks/"+companyNames[i], "Low", low)
                    firebase.put("/Stocks/"+companyNames[i], "Value", value)
                    firebase.put("/Stocks/"+companyNames[i], "Color", stockColor)
                    firebase.put("/Stocks/"+companyNames[i],'StockInfo',stockInfo)
                    firebase.put("/Stocks/"+companyNames[i],'LastUpdated',datetime.now())
                    
                    i+=1
        except :
            print("Loading took too much time!")
            i+=1
        finally:
            firebase.put('/','Running',0)
            
        browser.delete_all_cookies()
    i=0