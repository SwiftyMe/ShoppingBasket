//
//  ProductListRowView.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import SwiftUI

///
/// List row view presenting a product
///
struct ProductListRowView: View {
    
    @ObservedObject var product: ProductViewModel
    
    let changed: () -> Void
    
    var body: some View {
        
        VStack(spacing:10) {
            
            HStack(spacing:5) {
                
                Image(uiImage: product.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                
                Toggle(isOn:$product.addedToBasket.injectAction(self.changed)) {
                    VStack(alignment: .leading) {
                        Text(product.name)
                        Text("Price: \(product.price)")
                    }
                }
                .font(.system(size:14.0))
            }
            .frame(height:80)
            
            Divider()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}

///
/// Utility used to inject closure into binding
///
extension Binding {
    
    func injectAction(_ action: @escaping ()->Void) -> Binding {
        
        Binding(
            
            get: { return wrappedValue },
            
            set: {
                wrappedValue = $0
                action()
            }
        )
    }
}
