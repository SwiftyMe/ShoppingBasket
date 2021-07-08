//
//  ProductListView.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import SwiftUI
import Combine

///
///  Sheet view showing a list of available products
///
struct ProductListView: View {
    
    var close: ([ProductModel],Bool) -> Void
    
    @ObservedObject var productList: ProductListViewModel

    @Environment(\.presentationMode) private var presentationMode
    
    @State private var hasError = false
    @State private var saveEnabled = false
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing:0) {
            
            HStack {
                
                Button("Cancel", action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                    self.close([],true)
                })
                
                Spacer()
                
                Text("Product List")
                
                Spacer()
                
                Button(action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                    
                    let selected = self.productList.products.filter({$0.addedToBasket}).map( { $0.modelObject } )
                    
                    self.close(selected,false)
                }) {
                    
                    Text("Save").opacity(self.saveEnabled ? 1 : 0.5)
                }
                .disabled(!self.saveEnabled)
            }
            .padding()
            .background(Color.init(white:0.90))

            Divider()
                .background(Color.init(white:0.9))
                .padding(0)
            
            ScrollView {
                
                LazyVStack(spacing:0) {
                    
                    ForEach(self.productList.products) { product in
                            
                        ProductListRowView(product:product, changed: { self.saveEnabled = true })
                    }
                }
            }

            Spacer()
        }
        .background(Color.white)
    }
}


