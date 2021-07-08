//
//  ShoppingBasketViewModel.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import Foundation
import Combine

///
/// Protocol used for delegation of basket updates from child objects
///
protocol ShoppingBasketUpdate {

    func updateTotalPrice()
}

///
/// View model class for shopping basket
///
class ShoppingBasketViewModel: ObservableObject {
    
    @Published var basketItems = [BasketItemViewModel]()
    
    @Published var error: String?
    @Published var totalPrice = 0
    
    var products: [ProductViewModel] {
        
        var list: [ProductViewModel] = []
        
        for (_,product) in productDictionary! {
            list.append(ProductViewModel(product:product))
        }
        
        return list
    }
    
    init(APIService: APIServiceType) {
        
        self.APIService = APIService
    }
    
    private var productDictionary: [String:ProductModel]?
    
    private var APIService: APIServiceType
    private var cancellable: AnyCancellable?
    
    ///
    /// Add a product item to the basket represented by a model object
    ///
    func addToBasket(item: ProductModel) {
        
        if let found = basketItems.first(where: { String($0.id) == item.id }) {
            
            found.incrementCount()
        }
        else {
            
            let itemModel = ShoppingBasketItemModel(product:item,count:1)
            
            basketItems.append(BasketItemViewModel(model:itemModel, basket:self))
            
            updateTotalPrice()
        }
    }

    ///
    /// Clear items in backet
    ///
    func clearItems() {
        
        basketItems.removeAll()
        
        updateTotalPrice()
    }
    
    ///
    /// Get list of products from backend, by setting up an subscription
    ///
    func loadProducts() {
        
        error = nil
        
        cancellable?.cancel()

        cancellable = APIService.products()
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        self.error = error.localizedDescription
                    case .finished:
                        break
            }},receiveValue:{ value in
                
                self.productDictionary = value
            })
    }
}

///
/// Implementation of ShoppingBasketUpdate protocol
///
extension ShoppingBasketViewModel: ShoppingBasketUpdate {
    
    func updateTotalPrice() {
        
        totalPrice = basketItems.reduce(0) { $0 + $1.totalPrice }
    }
}
