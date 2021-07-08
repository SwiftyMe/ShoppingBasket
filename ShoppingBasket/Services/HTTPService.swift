//
//  HTTPService.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import Foundation
import Combine

enum HTTPServiceError: Swift.Error {
    
    case Decoding(String)
    case Encoding(String)
    case HTTPCode(Int)
    case ResponseError
    case NoData
}

///
/// Minimum required HTTP service protocol
///
protocol HTTPServiceType {
    
    typealias Error = HTTPServiceError
    
    func getJSON<JSONData:Decodable>(url:URL,accessToken:String?) -> AnyPublisher<JSONData,Error>
}

///
/// High level Interface to HTTP request service
///
class HTTPService: HTTPServiceType {
    
    typealias Error = HTTPServiceError

    ///
    /// Returns JSON object in response to GET request
    ///
    func getJSON<JSONData>(url:URL, accessToken:String? = nil) -> AnyPublisher<JSONData,Error> where JSONData : Decodable {
        
        var request = URLRequest(url:url)

        request.httpMethod = "GET"
        
        if let token = accessToken {
            request.addValue("Bearer " + token, forHTTPHeaderField:"authorization")
        }
        
        return HTTPService.urlRequest(request)
    }
    
    ///
    /// Returns JSON object in response to URL request
    ///
    private static func urlRequest<JSONData:Decodable>(_ request: URLRequest) -> AnyPublisher<JSONData,HTTPService.Error> {
        
        return urlRequestData(request)
            .decode(type: JSONData.self, decoder: JSONDecoder())
            .mapError { error -> HTTPService.Error in
                
                if let error = error as? HTTPService.Error {
                    return error
                }
                
                return .Decoding(error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    ///
    /// Returns Foundation.Data object in response to URL request
    ///
    private static func urlRequestData(_ request: URLRequest) -> AnyPublisher<Data,HTTPService.Error> {

        return Future<Data,Error> { promise in
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    
                    promise(.failure(.Decoding(error.localizedDescription)))
                    return
                }
                
                if let resp = response as? HTTPURLResponse {
                    
                    if resp.statusCode != 200 {
                        promise(.failure(.HTTPCode(resp.statusCode)))
                        return
                    }
                    
                } else {
                    
                    promise(.failure(.ResponseError))
                    return
                }
                
                guard data != nil else {
                    
                    promise(.failure(.NoData))
                    return
                }

                // HTTPService.debugPrint(data!)

                promise(.success(data!))
            }
            .resume()
            
        }.eraseToAnyPublisher()
    }
}

///
/// Error messages
///
extension HTTPService.Error {
    
    var localizedDescription: String {
        switch self {
            case let .Decoding(errorDescription): return "Decoding error: " + errorDescription
            case let .Encoding(errorDescription): return "Encoding error: " + errorDescription
            case let .HTTPCode(code): return HTTPCodeMessage(code)
            case .ResponseError: return "Response error"
            case .NoData: return "Data from HTTP request was empty"
        }
    }
    
    func HTTPCodeMessage(_ code: Int) -> String {
        
        var message: String?
        
        switch code {
            case 400: message = "Bad request" // probably because of syntax error in body or something like that
            case 403: message = "Forbidden" // request was understood, but perhaps something is wrong with access rights
        default:
            break
        }
        
        return "HTTP code (\(code)) error" + (message == nil ? "" : " - " + message!)
    }
}

///
/// Debug
///
extension HTTPService {
    
    static func debugPrint(_ data: Data) {
        
        if let json = try? JSONSerialization.jsonObject(with:data, options:.allowFragments) {
            
            print(json)
        }
    }
}
