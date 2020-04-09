
import UIKit

public let CURRENCY_GROUP_SEPARATOR = ","
public let CURRENCY_DECIMAL_SEPARATOR = "."

class CurrencyTextField: UITextField {
    var lastValue: Int64 = 0
    let maxValue: Int64 = 1_000_000_000_000_000_000
    var amount: Int64 {
        if let newValue = Int64(string.digits), newValue < maxValue {
            lastValue = newValue
        } else if !hasText {
            lastValue = 0
        }
        return lastValue
    }
    override func didMoveToSuperview() {
        textAlignment = .center
        keyboardType = .numbersAndPunctuation
        text = formatCurrencyInt64(amount)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    @objc func editingChanged(_ textField: UITextField) {
        text = formatCurrencyInt64(amount)
    }
    
    public func formatCurrencyInt64(_ money: Int64) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        numFormatter.groupingSeparator = CURRENCY_GROUP_SEPARATOR
        numFormatter.decimalSeparator = CURRENCY_DECIMAL_SEPARATOR
        
        let text = numFormatter.string(from: NSNumber.init(value: money))!
        return text
    }
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
struct Formatter {
    static let decimal = NumberFormatter(numberStyle: .decimal)
}
extension UITextField {
    var string: String { return text ?? "" }
}

extension String {
    private static var digitsPattern = UnicodeScalar("0")..."9"
    var digits: String {
        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
    }
}

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}
