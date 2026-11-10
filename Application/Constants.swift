import Foundation

enum Constants {
    static let accessKey = "uV980Ccubb6nKKZsca0CjRwQbh8xX2_o1OUTUbuzEnE"
    
    static let secretKey: String? = {
        guard let rawKey = Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_SECRET_KEY") as? String else {
            return nil
        }
        let trimmedKey = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)
        // Берем строго первые 43 символа оригинального Unsplash Secret Key
        if trimmedKey.count > 43 {
            return String(trimmedKey.prefix(43))
        }
        return trimmedKey
    }()
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com"
}
