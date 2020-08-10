
import UIKit

extension String {
    
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    func encrypt() -> String {
        return self.toBase64()
    }
    
    func decrypt() -> String {
        return self.fromBase64() ?? ""
    }
    
    func convertDateFormatter(date: String) -> String {
        
        if(date == "") {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
    func convertDateFormatterToServer(date: String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/YYYY hh:mm aa"//this your string date format
         dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
         dateFormatter.locale = Locale(identifier: "your_loc_id")
         let convertedDate = dateFormatter.date(from: date)

         guard dateFormatter.date(from: date) != nil else {
             assert(false, "no date from string")
             return ""
         }

         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"///this is what you want to convert format
         dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
         let timeStamp = dateFormatter.string(from: convertedDate!)

         return timeStamp
     }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
    
    func toAttributeString(font: UIFont?,
                           textColor: UIColor = .white,
                           spaceLine: CGFloat = 0.0,
                           spaceCharacter: CGFloat = 0.0,
                           range: NSRange? = nil,
                           alignment: NSTextAlignment = .left,
                           lineBreakMode: NSLineBreakMode? = nil) -> NSAttributedString? {
        
        let multipletAttribute = [NSAttributedString.Key.font: font as Any,
                                  NSAttributedString.Key.foregroundColor: textColor,
                                  NSAttributedString.Key.kern: spaceCharacter] as [NSAttributedString.Key: Any]
        
        let descAttributeText = NSMutableAttributedString(string: self, attributes: multipletAttribute)
        
        let paragraphStype = NSMutableParagraphStyle()
        paragraphStype.lineSpacing = spaceLine
        paragraphStype.alignment = alignment
        if let lineBreakMode = lineBreakMode {
            paragraphStype.lineBreakMode = lineBreakMode
        }
        descAttributeText.addAttribute(NSAttributedString.Key.paragraphStyle,
                                       value: paragraphStype,
                                       range: range ?? NSRange(location: 0, length: descAttributeText.length))
        return descAttributeText
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func isLocalPath() -> Bool {
        return self.hasPrefix("file")
    }
    
    func underLineAtrribute() -> NSAttributedString {
        let attributes = NSMutableAttributedString(string: self)
        let underLineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        attributes.addAttributes(underLineAttribute, range: NSRange(location: 0, length: self.count))
        return attributes
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let query = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return query.evaluate(with: self)
    }
    
    func toAlphaBet() -> String {
        let text = self.folding(options: .diacriticInsensitive, locale: Locale(identifier: "en")).uppercased()
        return text.replacingOccurrences(of: "Đ", with: "D")
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16) else { return nil }
        guard let to = range.upperBound.samePosition(in: utf16) else { return nil }
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    
    func toDate(withFormat format: String, isUTC: Bool = false) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if isUTC {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        return dateFormatter.date(from: self)
    }
    
    func getSize() -> CGFloat {
        let nsText = self as NSString
        let gRect = nsText.boundingRect(with: UIScreen.main.bounds.size,
                            options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin],
                            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return gRect.size.width
    }
    

        func index(from: Int) -> Index {
            return self.index(startIndex, offsetBy: from)
        }

        func substring(from: Int) -> String {
            let fromIndex = index(from: from)
            return String(self[fromIndex...])
        }

        func substring(to: Int) -> String {
            let toIndex = index(from: to)
            return String(self[..<toIndex])
        }

        func substring(with r: Range<Int>) -> String {
            let startIndex = index(from: r.lowerBound)
            let endIndex = index(from: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
  
}
