//
//  Product.swift
//  ShoppingBasket
//
//

import Foundation

///
/// The one and only model object
///
struct ProductModel: Decodable {
    let barcode: String
    let description: String
    let id: String
    let imageUrl: String
    let name: String
    let retailPrice: Int
    let costPrice: Int?
}

extension ProductModel {
    
    ///
    /// Translate to camel casing
    ///
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case barcode
        case description
        case retailPrice = "retail_price"
        case costPrice = "cost_price"
        case imageUrl = "image_url"
    }
}
