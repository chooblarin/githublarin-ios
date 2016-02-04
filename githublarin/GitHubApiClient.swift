import Alamofire
import Gloss
import RxSwift
import RxCocoa
import RealmSwift

class GitHubAPIClient {

    static let sharedInstance = GitHubAPIClient()

    // MARK: - Properties
    let GitHubApiURL = "https://api.github.com"
    private let realm = try! Realm()
    private let alamofireManager = Alamofire.Manager.sharedInstance
    private let sessionManager = SessionManager.sharedInstance

    func request(method: Alamofire.Method = .GET, path: String) -> Observable<JSON> {
        return self.request(method, path: path, headers: nil)
    }

    func request(method: Alamofire.Method = .GET, path: String, headers: [String:String]?) -> Observable<JSON> {
        let request: NSURLRequest?
        if let headers = headers {
            request = self.alamofireManager.request(method, self.GitHubApiURL + path, headers: headers).request
        } else {
            request = self.alamofireManager.request(method, self.GitHubApiURL + path).request
        }
        if let request = request  {
            return self.alamofireManager.session.rx_JSON(request).map { $0 as! JSON }
        } else {
            fatalError("Invalid request")
        }
    }

    func searchRepository(searchKey: String) -> Observable<[Repository]> {
        return request(.GET, path: "/search/repositories?q=" + searchKey)
            .map { $0["items"] as! [AnyObject] }
            .flatMap { $0.toObservable() }
            .map { (anyObject: AnyObject) -> Repository in
                return Repository(json: anyObject as! JSON)!
            }
            .toArray()
            .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .observeOn(Dependencies.sharedDependencies.mainScheduler)
    }

    func login(username username: String, password: String) -> Observable<User> {
        // TODO: - OAuth instead
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]

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
    }

    // WIP
    func feeds() {
        let headers = getAuthHeader()
        self.request(.GET, path: "/feeds", headers: headers)
            .map { FeedResponse(json: $0) }
            .map { self.alamofireManager.request(.GET, $0!.currentUserUrl).request }
            .flatMap { self.alamofireManager.session.rx_response($0!) }
            .map({ (data, response) -> NSString? in
                return NSString(data: data, encoding:NSUTF8StringEncoding)
            })
            .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .observeOn(Dependencies.sharedDependencies.mainScheduler)
    }

    private func getAuthHeader() -> [String:String]? {
        if let session = sessionManager.getSession(realm) {
            return ["Authorization": "Basic \(session.credentials)"]
        } else {
            return nil
        }
    }
}
