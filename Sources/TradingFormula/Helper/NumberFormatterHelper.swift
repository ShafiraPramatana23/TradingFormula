//
//  File.swift
//  
//
//  Created by Shafira on 10/10/24.
//

import Foundation

class NumberFormatterHelper {
  func ConvertDouble(valueD: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.roundingMode = .halfUp
    formatter.decimalSeparator = "."
    let res = formatter.string(from: valueD as NSNumber) ?? ""
    return res
  }
  
  func ConvertDoubleTrading(valueD: Double) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 3
    formatter.roundingMode = .halfUp
    formatter.decimalSeparator = "."
    let res = formatter.string(from: valueD as NSNumber) ?? ""
    return res
  }
  
  func ConvertDoubleHistory(valueD: Double) -> Double {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    //        formatter.roundingMode = .halfUp
    formatter.decimalSeparator = "."
    let res = formatter.string(from: valueD as NSNumber) ?? ""
    return Double(res) ?? 0.0
  }
    
    func ConvertDoubleHalfUp(valueD: Double) -> Double {
      let formatter = NumberFormatter()
      formatter.maximumFractionDigits = 2
              formatter.roundingMode = .halfUp
      formatter.decimalSeparator = "."
      let res = formatter.string(from: valueD as NSNumber) ?? ""
      return Double(res) ?? 0.0
    }
  
  func ConvertNoComma(valueD: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    //        formatter.roundingMode = .halfUp
    formatter.decimalSeparator = "."
    let res = formatter.string(from: valueD as NSNumber) ?? ""
    return res
  }
  
  func ConvertNoCommaCurrency(valueD: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    //        formatter.roundingMode = .halfUp
    formatter.decimalSeparator = "."
    formatter.numberStyle = .decimal
    let res = formatter.string(from: valueD as NSNumber) ?? ""
    return res
  }
  
  func RemoveGrouping(valueD: String) -> String {
    let completeString = valueD.replacingOccurrences(of: ".", with: "")
    return completeString
  }
  
  /*func ConvertDouble(valueD: Double) -> Double {
   let formatter = NumberFormatter()
   formatter.maximumFractionDigits = 2
   let res = formatter.string(from: valueD as NSNumber)
   let d = Double(res ?? "0") ?? 0.0
   return d
   //        formatter.roundingMode = .down
   //        let s = formatter.string(from: )
   }*/
    
    func converterPnL(valueD: Decimal) -> Decimal {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.roundingMode = .halfUp
        formatter.decimalSeparator = "."
        let res = formatter.string(from: valueD as NSNumber) ?? ""
        return Decimal(string: res) ?? 0
    }
    
    func converterPnLRoundDown(valueD: Decimal) -> Decimal {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.roundingMode = .floor
        formatter.decimalSeparator = "."
        let res = formatter.string(from: valueD as NSNumber) ?? ""
        return Decimal(string: res) ?? 0
    }
    
    func converterDecimalCustom(valueD: Decimal, round: NumberFormatter.RoundingMode, digits: Int) -> Decimal {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = digits
        formatter.roundingMode = round
        formatter.decimalSeparator = "."
        let res = formatter.string(from: valueD as NSNumber) ?? ""
        return Decimal(string: res) ?? 0
    }

}
