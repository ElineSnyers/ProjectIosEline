import Foundation
class Service {
    
    enum Error: Swift.Error {
        case missingJsonProperty(name: String)
        case noNetwork
        case unexpectedStatusCode(found: Int, expected: Int)
        case missingJsonData
        case invalidJsonData(message: String)
        case other(Swift.Error)
        
    }
    
    static let shared = Service()
    
    private init() { }
    
    private let url = URL(string: "https://api.mlab.com/api/1/databases/iosproject/collections/City?apiKey=qODeovZ2HJ4_2O2Gzilfjs9vy0H7NEJU")!
    private let session = URLSession(configuration: .ephemeral)
    
    func loadDataTask(completionHandler: @escaping (Result<[City]>) -> Void) -> URLSessionTask {
        //hier eerst reachablity schrijven
        let task = session.dataTask(with: url) {
            data, response, error in
            
            let completionHandler: (Result<[City]>) -> Void = {
                result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.noNetwork))
                return
            }
            guard response.statusCode == 200 else {
                completionHandler(.failure(.unexpectedStatusCode(found: response.statusCode, expected:200)))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.missingJsonData))
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let results = json as? [[String: Any]] else {
                    completionHandler(.failure(.invalidJsonData(message: "JSON data did not contain an arrayof objects")))
                    return
            }
            
            do{ let cities = try results.map { try City(json: $0) }
                completionHandler(.success(cities))
            } catch let error as Service.Error{
                completionHandler(.failure(error))
            }
            catch{
                completionHandler(.failure(.other(error)))
            }
        }
        return task
    }
    
}
