import Foundation
import RealmSwift

class SessionManager {

    static let sharedInstance = SessionManager()

    func saveCredentials(realm: Realm, credentials: String) {
        let session = Session()
        session.credentials = credentials

        try! realm.write {
            realm.add(session)
        }
    }

    func getSession(_ realm: Realm) -> Session? {
        return realm.objects(Session.self).first
    }
}

class Session: Object {
    dynamic var credentials: String = ""
}
