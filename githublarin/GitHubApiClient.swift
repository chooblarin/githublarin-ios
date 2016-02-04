import Alamofire
import Gloss
import RxSwift
import RxCocoa
import RealmSwift

class GitHubAPIClient {

    static let sharedInstance = GitHubAPIClient()

    // MARK: - Properties
    let GitHubApiURL = "https://api.github.com"
    private let alamofireManager = Alamofire.Manager.sharedInstance
    private let sessionManager = SessionManager.sharedInstance

    func request(method: Alamofire.Method = .GET, path: String) -> Observable<AnyObject> {
        let request = self.alamofireManager.request(method, self.GitHubApiURL + path).request
        if let request = request  {
            return self.alamofireManager.session.rx_JSON(request)
        } else {
            fatalError("Invalid request")
        }
    }

    func searchRepository(searchKey: String) -> Observable<[Repository]> {
        return request(.GET, path: "/search/repositories?q=" + searchKey)
            .map { $0["items"] as! [AnyObject] }
            .flatMap { $0.toObservable() }
            .map { Repository(json: $0 as! JSON)! }
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
                .doOn(onNext: { _ -> Void in
                }, onError: { _ -> Void in
                }, onCompleted: { () -> Void in
                    let realm = try! Realm()
                    self.sessionManager.saveCredentials(realm: realm, credentials: base64Credentials)
                })
                .map {  User(json: $0 as! JSON)! }
                .subscribeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
                .observeOn(Dependencies.sharedDependencies.mainScheduler)

        } else {
            fatalError("Invalid request")
        }
    }
}
