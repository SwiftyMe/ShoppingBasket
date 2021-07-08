//
//  ProductDetailsView.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import SwiftUI

///
/// Sheet view showing a selected product
///
struct ProductDetailsView: View {
    
    @ObservedObject var product: BasketItemViewModel
    
    var body: some View {
        
        VStack(spacing:15) {
            
            Text(product.name).font(.title)
                .padding(.top,5)
            
            Image(uiImage: product.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ScrollView {
                
                Text(product.description)
            }
        }
        .padding()
    }
}

