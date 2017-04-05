import Alamofire
import Gloss
import RxSwift
import RxCocoa
import RealmSwift

import Moya

class GitHubAPIClient {

  private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: data)
      let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return prettyData
    } catch {
      return data // fallback to original data if it can't be serialized.
    }
  }

  static let sharedInstance = GitHubAPIClient()

  // MARK: - Properties
  let GitHubApiURL = "https://api.github.com"
  fileprivate let realm = try! Realm()
  fileprivate let sessionManager = SessionManager.sharedInstance

  func searchRepository(_ searchKey: String) -> Observable<[Repository]> {
    let provider = MoyaProvider<GitHubService>(plugins: [
        NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter
      )])
    provider.request(.searchRepos(q: searchKey)) { result in
      switch result {
      case .success(let response):
        debugPrint(response.debugDescription)
        break
      case .failure(let error):
        debugPrint(error)
        break
      }
    }
    return Observable.empty()
  }

  func login(username: String, password: String) -> Observable<User> {
    let provider = MoyaProvider<GitHubService>(
      endpointClosure: { (service: GitHubService) -> Endpoint<GitHubService> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: service)
        return defaultEndpoint.adding(newHTTPHeaderFields: [:])
      },
      plugins: [
        CredentialsPlugin { _ -> URLCredential? in
          return URLCredential(user: username, password: password, persistence: .none)
        },
        NetworkLoggerPlugin(verbose: true)
      ])
    provider.request(.user(username: username, password: password)) { result in
      switch result {
      case .success(let response):
        debugPrint(response.response.debugDescription)
        break
      case .failure(let error):
        debugPrint(error)
        break
      }
    }
    return Observable.empty()
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
