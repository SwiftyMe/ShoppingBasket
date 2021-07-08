//
//  BasketListRowView.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import SwiftUI

///
/// List row view showing a basket item
///
struct BasketListRowView: View {
    
    @ObservedObject var basketItem: BasketItemViewModel
    
    var clicked: () -> Void
    
    var body: some View {
        
        VStack(spacing:10) {
            
            HStack(spacing:15) {
                
                Button(action: {
                    
                    self.clicked()
                    
                }) {
                    
                    HStack(spacing:10) {
                        
                        Image(uiImage: basketItem.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.vertical,5)
                        
                        VStack(alignment:.leading, spacing:2) {
                            
                            Text(basketItem.name).bold().font(.system(size:14.0))
                            
                            Text("Item(s): \(basketItem.count)")
                                .font(.system(size:13.0))
                            
                            Text("Total Price: \(basketItem.totalPrice)")
                                .font(.system(size:13.0))
                        }
                    }
                }
                
                Spacer()
                
                HStack(alignment:.bottom, spacing:15) {
                    
                    Button(action: { self.basketItem.incrementCount() }) {
                        Image(systemName:"plus.circle")
                            .imageScale(.large)
                    }
                    
                    Button(action: { self.basketItem.decrementCount() }) {
                        Image(systemName:"minus.circle")
                            .imageScale(.large)
                            .opacity(self.basketItem.count == 0 ? 0.5 : 1)
                    }
                    .disabled(self.basketItem.count == 0)
                }
                .font(.system(size:18.0))
                .padding(.leading,20)
            }
            .frame(height: 80)
            .foregroundColor(Colors.shoppingBlue)
            
            Divider()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
}
