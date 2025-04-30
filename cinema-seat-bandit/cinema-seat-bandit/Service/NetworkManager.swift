import Foundation
import Alamofire

enum TMDB {
    case trending(page: Int = 1)
    case upcoming(page: Int = 1)
    case search(query: String, page: Int)
    case image(id: Int)
    case credit(id: Int)

    var baseURL: String { "https://api.themoviedb.org/3/" }

    var endPoint: URL {
        let path: String
        switch self {
        case .trending(let page):
            path = "trending/movie/day?language=ko-KR&page=\(page)"
        case .upcoming(let page):
                path = "movie/upcoming?language=ko-KR&page=\(page)"
        case .search(let query, let page):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            path = "search/movie?query=\(encodedQuery)&include_adult=false&language=ko-KR&page=\(page)"
        case .image(let id):
            path = "movie/\(id)/images"
        case .credit(let id):
            path = "movie/\(id)/credits?language=ko-KR"
        }
        return URL(string: baseURL + path)!
    }

    var header: HTTPHeaders { ["Authorization": "Bearer \(APIKey.TOKEN)"] }
    var method: HTTPMethod { .get }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        api: TMDB,
        completion: @escaping (Result<T, Error>) -> Void
    ) {

        print("api 확인: \(api.endPoint.absoluteString)")

        AF.request(api.endPoint, method: api.method, headers: api.header)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print("네트워크 실패: \(error.localizedDescription)")
                    let statusCode = response.response?.statusCode ?? -1
                    print("실패한 StatusCode: \(statusCode)")
                    let errorMessage = self.handleError(error: error, statusCode: statusCode)
                    completion(.failure(errorMessage))
                }
            }
    }

    private func handleError(error: AFError, statusCode: Int) -> Error {
        switch statusCode {
        case 400: return NSError(domain: "Bad Request", code: 400)
        case 401: return NSError(domain: "Invalid Token", code: 401)
        case 404: return NSError(domain: "Not Found", code: 404)
        case 500...599: return NSError(domain: "Server Error", code: statusCode)
        default: return error
        }
    }
}
