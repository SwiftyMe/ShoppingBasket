//
//  ProductViewModel.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import Foundation
import UIKit

///
/// View model class for a single product
///
class ProductViewModel: ObservableObject, Identifiable {
    
    var id: Int {
        Int(product.id)!
    }
    
    var addedToBasket = false

    var description: String {
        product.description
    }
    
    var name: String {
        product.name
    }
    
    var price: Int {
        product.retailPrice
    }
    
    @Published var image = UIImage(systemName:"wifi.slash")!

    var modelObject: ProductModel {
        product
    }
    
    private let product: ProductModel
    
    ///
    /// Init
    ///
    init(product: ProductModel) {
        
        self.product = product
        
        DispatchQueue.global().async {
            
            if let url = URL(string:product.imageUrl), let data = try? Data(contentsOf:url), let image = UIImage(data:data) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
