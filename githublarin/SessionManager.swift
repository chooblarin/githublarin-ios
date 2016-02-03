import Foundation
// import RealmSwift

class SessionManager {

    static let sharedInstance = SessionManager()
    // var realm = try! Realm()
    var user: User?

    func saveCredentials(username username: String, password: String) {
//        realm.write { () -> Void in
//            let credentials = Credentials()
//            credentials.username = username
//            credentials.password = password
//        }
    }
}

//class Credentials: Object {
//    dynamic var username: String = ""
//    dynamic var password: String = ""
//
//    init(username: String, password: String) {
//        super.init()
//        self.username = username
//        self.password = password
//    }
//
//    required init() {
//        super.init()
//        fatalError("init() has not been implemented")
//    }
//}