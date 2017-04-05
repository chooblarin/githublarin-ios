import Foundation

import Moya

enum GitHubService {
  case user(username: String, password: String)
  case searchRepos(q: String)
}

extension GitHubService: TargetType {

  var baseURL: URL { return URL(string: "https://api.github.com")! }

  var path: String {
    switch self {
    case .user:
      return "/user"
    case .searchRepos:
      return "/search/repositories"
    }
  }
  var method: Moya.Method {
    switch self {
    default:
      return .get
    }
  }
  var parameters: [String : Any]? {
    switch self {
    case .searchRepos(let q):
      return ["q": q]
    default:
      return nil
    }
  }
  var parameterEncoding: ParameterEncoding {
    switch self {
    case .searchRepos:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }
  var sampleData: Data {
    return "Hello.".utf8Encoded
  }
  var task: Task {
    return .request
  }
}

// MARK: - Helpers
private extension String {
  var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }

  var utf8Encoded: Data {
    return self.data(using: .utf8)!
  }
}
