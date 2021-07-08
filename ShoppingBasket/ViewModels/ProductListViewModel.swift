//
//  ProductListViewModel.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import Foundation
import Combine

///
/// View model for the product list screen
///
class ProductListViewModel: ObservableObject {
    
    @Published var products = [ProductViewModel]()
    
    ///
    /// Init
    ///
    init(products: [ProductViewModel]) {
        
        self.products = products
    }
    
    func clearSelection() {
        
        for product in products {
            
            product.addedToBasket = false
        }
    }
}



