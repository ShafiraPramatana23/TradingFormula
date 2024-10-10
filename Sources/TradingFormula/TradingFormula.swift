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
    
    func getPriceNow(ticker: String, price: Double) -> Double {
        return if ticker == "MGAU" || ticker == "MKAU" {
            price / 100
        } else if ticker == "KAU_USD" || ticker == "K100" {
            price * 100
        } else {
            price
        }
    }
    
    //MARK: - Fee Tax
    
    func getFeeTaxMvatIdr(ticker: String, qty: Double, price: Double, streamSell: Int) -> Double {
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let priceNowIdr = priceNow * Double(streamSell)
        let totalPricexGramIdr = qty * priceNowIdr

        return if totalPricexGramIdr < 50000 {
            0.04 * Double(streamSell)
        } else {
            0.0111 * totalPricexGramIdr
        }
    }
    
    func getFeeTaxMvatUsd(ticker: String, qty: Double, price: Double) -> Double {
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let totalPricexGram = qty * priceNow
        
        return if (0.0111 * totalPricexGram) < 0.04 {
            0.04
        } else {
            0.0111 * totalPricexGram
        }
    }
    
    //MARK: - Metal Value at Date
    
    func getMvadIdr(ticker: String, qty: Double, price: Double, streamSell: Int) -> Double {
        let feeTaxMvat = getFeeTaxMvatIdr(ticker: ticker, qty: qty, price: price, streamSell: streamSell)
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let priceNowIdr = priceNow * Double(streamSell)
        let totalPricexGramIdr = qty * priceNowIdr
        
        return totalPricexGramIdr - feeTaxMvat
    }
    
    func getMvadUsd(ticker: String, qty: Double, price: Double) -> Double {
        let feeTaxMvat = getFeeTaxMvatUsd(ticker: ticker, qty: qty, price: price)
        let priceNow = getPriceNow(ticker: ticker, price: price)
        let totalPricexGram = qty * priceNow
        
        return totalPricexGram - feeTaxMvat
    }
    
    //MARK: - P&L
    
    func getPnlHolding(mvad: Double, avgTotalCost: Double) -> Double {
        // IDR & USD
        return NumberFormatterHelper().ConvertDoubleHistory(valueD: mvad - avgTotalCost)
    }
    
    func getPnlHoldingPercentage(pnl: Double, avgTotalCost: Double) -> Double {
        // IDR & USD
        return ((pnl / avgTotalCost) * 100)
    }
    
    func getPnlIdr(ticker: String, priceNowUsd: Double, qtyHolding: Decimal, gramSell: Decimal, streamRate: Decimal, avgTotalCostIdr: Decimal) -> Decimal {
//        let bd100 = Decimal(100.0000)
//        let pricePerGram = if ticker == "KAU_USD" {
//            NumberFormatterHelper().converterPnL(valueD: priceNowUsd * bd100)
//        } else {
//            NumberFormatterHelper().converterPnL(valueD: priceNowUsd)
//        }
        
        let pricePerGram = getPriceNow(ticker: ticker, price: priceNowUsd)
        let pricePerGramIdr = Decimal(pricePerGram) * streamRate

        let qtyH = if ticker == "K100" {
            qtyHolding * 100
        } else {
            qtyHolding
        }

        let totalPricexGramIdr = qtyH * pricePerGramIdr
        let feeTaxMvatIdr = if totalPricexGramIdr < 50000 {
            0.04 * streamRate
        } else {
            0.0111 * totalPricexGramIdr
        }
        let mvad = totalPricexGramIdr - feeTaxMvatIdr
        let pnl = NumberFormatterHelper().converterDecimalCustom(valueD: mvad - avgTotalCostIdr, round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let pnlPerGram = NumberFormatterHelper().converterDecimalCustom(valueD: pnl / qtyH, round: NumberFormatter.RoundingMode.halfUp, digits: 4)
        let fixPnl = pnlPerGram * gramSell
        
        return NumberFormatterHelper().converterPnLRoundDown(valueD: fixPnl)
    }
}
