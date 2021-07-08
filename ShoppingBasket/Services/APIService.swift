//
//  APIService.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import Foundation
import Combine

///
/// protocol Errors
///
enum APIServiceError: Swift.Error {
    
    case Network(HTTPService.Error)
}


///
/// protocol APIServiceType
///
protocol APIServiceType {
    
    typealias Error = APIServiceError
    
    func products() -> AnyPublisher<[String:ProductModel],Error>
}

///
/// Implementation of high level Interface to the mocky API
///
class APIService: APIServiceType {
    
    typealias Error = APIServiceError
    
    ///
    /// APIServiceProducts function - products
    ///
    func products() -> AnyPublisher<[String:ProductModel],Error> {

        let url = URL(string: APIService.Products_Endpoint)!
    
        return httpService.getJSON(url:url, accessToken:nil)
            .mapError { error -> Error in
                return Error.Network(error)
            }
        .receive(on:RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    ///
    /// init and injection of services
    ///
    init(HTTPService: HTTPServiceType) {
        
        self.httpService = HTTPService
    }
    
    // MARK: Private
    private var httpService: HTTPServiceType
}


///
/// URLs for the mocky API
///
extension APIService {

    static let Products_Endpoint = "https://run.mocky.io/v3/4e23865c-b464-4259-83a3-061aaee400ba"
}

///
/// Error Text messages
///
extension APIService.Error {
    
    var localizedDescription: String {
        switch self {
            
            // TODO: Add non-general error messages
        
            case let .Network(HTTPServiceError):
                if case HTTPService.Error.HTTPCode(let code) = HTTPServiceError {
                    if code == 403 {
                        return HTTPServiceError.localizedDescription + "\n\n TODO: Add message"
                    }
                }
                
                return HTTPServiceError.localizedDescription
        }
    }
}

