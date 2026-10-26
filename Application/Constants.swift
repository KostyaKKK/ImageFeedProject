import Foundation

enum Constants {
    static let accessKey = "uV980Ccubb6nKKZsca0CjRwQbh8xX2_o1OUTUbuzEnE"
    static let secretKey = Bundle.main.object(
        forInfoDictionaryKey: "UNSPLASH_SECRET_KEY"
    ) as? String
    
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com"
}
