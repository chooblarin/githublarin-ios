import Alamofire
import Gloss
import RxSwift
import RxCocoa
import RealmSwift

class GitHubAPIClient {

    static let sharedInstance = GitHubAPIClient()

    // MARK: - Properties
    let GitHubApiURL = "https://api.github.com"
    fileprivate let realm = try! Realm()
    fileprivate let sessionManager = SessionManager.sharedInstance

    func searchRepository(_ searchKey: String) -> Observable<[Repository]> {
        let path = "/search/repositories?q=" + searchKey
        /*
        requestJSON(.get, path: "/search/repositories?q=" + searchKey)
            .map { $0["items"] as! [AnyObject] }
            .flatMap { $0.toObservable() }
            .map { (anyObject: AnyObject) -> Repository in
                return Repository(json: anyObject as! JSON)!
            }
            .toArray()
            .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .observeOn(Dependencies.sharedDependencies.mainScheduler)
        */
        return Observable.empty()
    }

    func login(username: String, password: String) -> Observable<User> {
        // TODO: - OAuth instead
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        let path = "/user"
        return Observable.empty()
        /*
        let request = self.alamofireManager.request(.GET, self.GitHubApiURL + "/user", headers: headers)
            .authenticate(user: username, password: password).request
        if let request = request  {
            return self.alamofireManager.session.rx_JSON(request)
                .map {  User(json: $0 as! JSON)! }
                .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
                .observeOn(Dependencies.sharedDependencies.mainScheduler)
                .doOn { event in
                    switch event {
                    case .Completed:
                        self.sessionManager.saveCredentials(realm: self.realm, credentials: base64Credentials)
                    case .Next(_): break
                    case .Error(_): break
                    }
                }

        } else {
            fatalError("Invalid request")
        }
        */
    }

    func feeds() -> Observable<Feed> {
        /*
        let headers = getAuthHeader()
        return requestJSON(.GET, path: "/feeds", headers: headers)
            .map { FeedResponse(json: $0) }
            .map { NSURL(string: $0!.currentUserUrl) }
            .flatMap { FeedParser(contentsUrl: $0!).parse() }
            .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .observeOn(Dependencies.sharedDependencies.mainScheduler)
        */
        return Observable.empty()
    }

    func gists() -> Observable<[Gist]> {
        /*
        let headers = getAuthHeader()
        return requestJSONArray(.GET, path: "/gists", headers: headers)
            .map { jsonArray -> [Gist] in
                return [Gist].fromJSONArray(jsonArray)
            }
            .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .observeOn(Dependencies.sharedDependencies.mainScheduler)
        */
        return Observable.empty()
    }

    fileprivate func getAuthHeader() -> [String:String]? {
        if let session = sessionManager.getSession(realm) {
            return ["Authorization": "Basic \(session.credentials)"]
        } else {
            return nil
        }
    }
}
