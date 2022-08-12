import Foundation

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
    
    var roundedWithAbbreviationsKM: String{
        var stringResult = String(self)
        
        guard self > 0 else { return stringResult }
        
        if 4...6 ~= stringResult.count {
            stringResult = stringResult.dropLast(3) + "K"
        }else if stringResult.count > 6 {
            stringResult = stringResult.dropLast(6) + "M"
        }
        return stringResult
    }
}
