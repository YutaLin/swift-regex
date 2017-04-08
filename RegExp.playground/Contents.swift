//: # RegExp Playground

import Foundation  // For `NSRegularExpression` class

//: Extend `NSRegularExpression` to make things easier. XD
extension NSRegularExpression {

    // Provide full string range as the default value for the `range` argument

    func matches(in string: String, options: MatchingOptions = []) -> [NSTextCheckingResult] {
        let rangeOfString = NSRange(location: 0, length: string.characters.count)
        return self.matches(in: string, options: options, range: rangeOfString)
    }

    func numberOfMatches(in string: String, options: MatchingOptions = []) -> Int {
        let rangeOfString = NSRange(location: 0, length: string.characters.count)
        return self.numberOfMatches(in: string, options: options, range: rangeOfString)
    }

    func firstMatch(in string: String, options: MatchingOptions = []) -> NSTextCheckingResult? {
        let rangeOfString = NSRange(location: 0, length: string.characters.count)
        return self.firstMatch(in: string, options: options, range: rangeOfString)
    }

    // Helper for getting capture groups

    func matchedCaptureGroups(in string: String, options: MatchingOptions = []) -> [[String]] {
        var result = [[String]]()
        for match in self.matches(in: string, options: options) {
            var captureGroups = [String]()
            for captureGroupIndex in 1..<match.numberOfRanges {  // index=0 is the range of original string
                let captureGroupRange = match.rangeAt(captureGroupIndex)
                let substringOfCaptureGroup = (string as NSString).substring(with: captureGroupRange)
                captureGroups.append(substringOfCaptureGroup)
            }
            result.append(captureGroups)
        }
        return result
    }
}

//: Let's overload a built-in operator: `~` for creating pre-compiled regex pattern by a simple syntax.
prefix func ~(pattern: String) -> NSRegularExpression? {
    return try? NSRegularExpression(pattern: pattern)
}

//: Also, overload the pattern match `~=` operator for comparing with regex.
//: This is for pattern matching in `switch-case` statements.
func ~=(pattern_: NSRegularExpression?, value: String) -> Bool {
    guard let pattern = pattern_ else { return false }
    return pattern.numberOfMatches(in: value) != 0
}


//: --------------------------------------------------------------------------------------------------------------------

//: ## Use cases

//: Parse string pattern (identify string type)

func contentType(of string: String) -> String {
    let type: String
    switch string {
    case ~"^.+@.+\\.com$":
        type = "an email"
    case ~"^09\\d{2}-\\d{6}$":
        type = "a mobile phone number"
    default:
        type = "just a string"
    }
    return "'\(string)' is \(type)."
}

contentType(of: "Hello World!")
contentType(of: "sodas@icloud.com")
contentType(of: "0987-654321")

//: Get capture groups (parse string content)

let emailPattern = (~"^(.+)@(.+\\.com)$")!
let matchedCaptureGroups = emailPattern.matchedCaptureGroups(in: "sodas@icloud.com")[0]
let account = matchedCaptureGroups[0]
let domain = matchedCaptureGroups[1]
