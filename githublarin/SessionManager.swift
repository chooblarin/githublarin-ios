import Foundation
import RealmSwift

class SessionManager {

    static let sharedInstance = SessionManager()

    func saveCredentials(realm realm: Realm, credentials: String) {
        let session = Session()
        session.credentials = credentials

        try! realm.write {
            realm.add(session)
        }
    }

    func getSession(realm: Realm) -> Session? {
        return realm.objects(Session).first
    }
}

class Session: Object {
    dynamic var credentials: String = ""
}
