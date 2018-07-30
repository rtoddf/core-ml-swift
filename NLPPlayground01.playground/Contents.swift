import UIKit

let text = "Christopher Bailey, chief creative and chief executive officer of Burberry. Bailey is responsible for over 11,000 employees at the iconic British fashion brand Burberry. He has won various fashion accolades, including Menswear Designer of the Year at the British Fashion Awards, and is a vocal supporter of LGBT rights and equality. Burberry Group PLC is a British luxury fashion house headquartered in London, England."

let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.nameType], options: 0)
tagger.string = text

let range = NSMakeRange(0, text.utf16.count)

let options:NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

let tags:[NSLinguisticTag] = [.personalName, .placeName, .organizationName]

var names = [String]()
var places:[String] = []
var orgs:[String] = []

tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) {
    tag, tokenRange, stop in
    guard let tag = tag else { return }
    
    let token = (text as NSString).substring(with: tokenRange)
    
    switch tag {
    case .personalName:
        names.append(token)
    case .placeName:
        places.append(token)
    case .organizationName:
        orgs.append(token)
    default:
        break
    }
    
    
}

print(names)
print(places)
print(orgs)
