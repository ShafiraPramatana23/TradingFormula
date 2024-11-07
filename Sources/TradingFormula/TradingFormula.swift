// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct TradingFormula {
    public init() {}
    
    public func helloWorld() {
        print("Hello, World!")
    }
    
    public func getTextHihi() -> String {
        return "Shafiraaaa"
    }
    
    public func getPriceNow(ticker: String, price: Double) -> Double {
        return if ticker == "MGAU" || ticker == "MKAU" {
            price / 100
        } else if ticker == "KAU_USD" || ticker == "K100" {
            price * 100
        } else {
            price
        }
    }
    
    //MARK: - Fee Tax
    
    public func getFeeTaxMvatIdr(ticker: String, qty: Double, price: Double, streamSell: Int) -> Double {
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let priceNowIdr = priceNow * Double(streamSell)
        let totalPricexGramIdr = qty * priceNowIdr

        return if totalPricexGramIdr < 50000 {
            0.04 * Double(streamSell)
        } else {
            0.0111 * totalPricexGramIdr
        }
    }
    
    public func getFeeTaxMvatUsd(ticker: String, qty: Double, price: Double) -> Double {
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let totalPricexGram = qty * priceNow
        
        return if (0.0111 * totalPricexGram) < 0.04 {
            0.04
        } else {
            0.0111 * totalPricexGram
        }
    }
    
    //MARK: - Metal Value at Date
    
    public func getMvadIdr(ticker: String, qty: Double, price: Double, streamSell: Int) -> Double {
        let feeTaxMvat = getFeeTaxMvatIdr(ticker: ticker, qty: qty, price: price, streamSell: streamSell)
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let priceNowIdr = priceNow * Double(streamSell)
        let totalPricexGramIdr = qty * priceNowIdr
        
        print("omg feeTaxMvat: ", feeTaxMvat)
        print("omg priceNow: ", priceNow)
        print("omg priceNowIdr: ", priceNowIdr)
        print("omg streamSell: ", streamSell)
        print("omg totalPricexGramIdr: ", totalPricexGramIdr)
        print("omg mvad: ", (totalPricexGramIdr - feeTaxMvat))
        print("omg qty: ", qty)
        
        return totalPricexGramIdr - feeTaxMvat
    }
    
    public func getMvadUsd(ticker: String, qty: Double, price: Double) -> Double {
        let feeTaxMvat = getFeeTaxMvatUsd(ticker: ticker, qty: qty, price: price)
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let totalPricexGram = qty * priceNow
        
        print("usd feeTaxMvat: ", feeTaxMvat)
        print("usd priceNow: ", priceNow)
        print("usd totalPricexGram: ", totalPricexGram)
        print("usd mvad: ", (totalPricexGram - feeTaxMvat))
        print("usd qty: ", qty)
        
        return totalPricexGram - feeTaxMvat
    }
    
    //MARK: - P&L
    
    public func getPnlHolding(mvad: Double, avgTotalCost: Double) -> Double {
        // IDR & USD
        return NumberFormatterHelper().ConvertDoubleHistory(valueD: mvad - avgTotalCost)
    }
    
    public func getPnlHoldingPercentage(pnl: Double, avgTotalCost: Double) -> Double {
        // IDR & USD
        return ((pnl / avgTotalCost) * 100)
    }
    
    public func getPnlIdr(ticker: String, priceNowUsd: Double, qtyHolding: Double, gramSell: Decimal, streamRate: Int, avgTotalCostIdr: Decimal) -> Decimal {
        
        let pricePerGram = getPriceNow(ticker: ticker, price: priceNowUsd)
        let qtyH = if ticker == "K100" {
            qtyHolding * 100
        } else {
            qtyHolding
        }
        
        let feeTaxMvat = getFeeTaxMvatIdr(ticker: ticker, qty: qtyH, price: priceNowUsd, streamSell: streamRate)
        let mvad = Decimal(getMvadIdr(ticker: ticker, qty: qtyH, price: priceNowUsd, streamSell: streamRate))
        
        let pnl = NumberFormatterHelper().converterDecimalCustom(valueD: mvad - avgTotalCostIdr, round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let pnlPerGram = NumberFormatterHelper().converterDecimalCustom(valueD: pnl / Decimal(qtyH), round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let fixPnl = pnlPerGram * gramSell
        
        print("----------------------------")
        print("pnlAkhir qty: \(qtyHolding)", qtyH)
        print("pnlAkhir gramSell: ", gramSell)
        print("pnlAkhir pricePerGram: ", pricePerGram)
        print("pnlAkhir streamSell: ", streamRate)
        print("pnlAkhir feeTaxMvat: ", feeTaxMvat)
        print("pnlAkhir mvad: ", mvad)
        print("pnlAkhir pnl: ", pnl)
        print("pnlAkhir pnlPerGram: ", pnlPerGram)
        print("pnlAkhir fixPnl: ", fixPnl)
        print("----------------------------")
        
        return NumberFormatterHelper().converterPnLRoundDown(valueD: fixPnl)
    }
    
    public func getPnlUsd(ticker: String, priceNowUsd: Double, qtyHolding: Double, gramSell: Decimal, avgTotalCost: Decimal) -> Decimal {
        
        let pricePerGram = getPriceNow(ticker: ticker, price: priceNowUsd)
        let qtyH = if ticker == "K100" {
            qtyHolding * 100
        } else {
            qtyHolding
        }

        let feeTaxMvat = getFeeTaxMvatUsd(ticker: ticker, qty: qtyH, price: priceNowUsd)
        let mvad = Decimal(getMvadUsd(ticker: ticker, qty: qtyH, price: priceNowUsd))

        let pnl = NumberFormatterHelper().converterDecimalCustom(valueD: mvad - avgTotalCost, round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let pnlPerGram = NumberFormatterHelper().converterDecimalCustom(valueD: pnl / Decimal(qtyH), round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let pnlPerGramConvert = NumberFormatterHelper().converterDecimalCustom(valueD: pnlPerGram, round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let fixPnl = pnlPerGramConvert * gramSell

        return NumberFormatterHelper().converterPnLRoundDown(valueD: fixPnl)
    }
}
