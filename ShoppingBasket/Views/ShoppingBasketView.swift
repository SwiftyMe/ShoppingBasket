//
//  ShoppingBasketView.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import SwiftUI

///
/// Main view displaying a shopping backet
///
struct ShoppingBasketView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var shoppingBasket = ShoppingBasketViewModel(APIService:APIService(HTTPService:HTTPService()))
    
    fileprivate struct Sheet {
        
        enum SheetType: Int { case basket, basketItem }

        var type: SheetType
        var basketItem: BasketItemViewModel?
    }

    @State private var sheet: Sheet? = nil
    @State private var hasError = false
    @State private var showAlert = false
    
    var body: some View {
        
        VStack(alignment:.leading, spacing:0) {
            
            HStack {
                
                Text("Shopping Basket")
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    self.sheet = Sheet(type:.basket,basketItem:nil)
                }) {
                    
                    Image(systemName:"cart.badge.plus")
                        .imageScale(.medium)
                        .padding()
                }
            }
            .font(.system(size:22.0))
            .foregroundColor(Color.white)
            
            Divider().background(Color.init(white:0.8))
            
            ScrollView {
                
                LazyVStack(spacing:0) {
                    
                    ForEach(self.shoppingBasket.basketItems)  { basketItem in
                        
                        BasketListRowView(basketItem: basketItem, clicked: {
                            self.sheet = Sheet(type:.basketItem,basketItem:basketItem)
                        })
                    }
                }
            }
            .background(Color.white)
            
            HStack {
                
                Text("Total price: \(shoppingBasket.totalPrice)")
                    .padding()
                
                Spacer()
                
                Button(action: { self.showAlert = true }) {
                    
                    Text("Clear").opacity(shoppingBasket.basketItems.isEmpty ? 0.5 : 1.0)
                    
                    Image(systemName:"cart.badge.minus")
                        .imageScale(.medium)
                        .opacity(shoppingBasket.basketItems.isEmpty ? 0.5 : 1.0)
                }
                .disabled(shoppingBasket.basketItems.isEmpty)
                .padding()
                .alertOKCancel(isPresented: $showAlert, message: ShoppingBasketView.alertMessage,
                               OKAction: { self.shoppingBasket.clearItems() })
                
            }
            .foregroundColor(Color.white)
            .font(.system(size:20.0))
        }
        .background(Colors.shoppingBlue.edgesIgnoringSafeArea(.all))
        .sheet(item:$sheet) { sheet in
            switch sheet.type {
                case .basket:
                    ProductListView(close:self.onCloseShowProducts, productList: ProductListViewModel(products: self.shoppingBasket.products))
                case .basketItem:
                    ProductDetailsView(product: sheet.basketItem!)
            }
        }
        .onAppear(perform: { self.shoppingBasket.loadProducts() })
    }
    
    ///
    /// Called when closing the Product List sheet
    ///
    func onCloseShowProducts(added:[ProductModel], cancelled:Bool) {
        
        if !cancelled {
            
            for product in added {
                shoppingBasket.addToBasket(item: product)
            }
        }
    }
}

///
/// Make Sheet enum Hashable and Identifiable
///
extension ShoppingBasketView.Sheet: Hashable, Identifiable {
    
    static func == (lhs: ShoppingBasketView.Sheet, rhs: ShoppingBasketView.Sheet) -> Bool {
        lhs.type == rhs.type && lhs.basketItem === lhs.basketItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type.rawValue)
    }
    
    var id: Self { self }
}

///
/// Constants
///
extension ShoppingBasketView {
    
    static private let alertMessage = "Confirm to clear all items in shopping basket"
}
