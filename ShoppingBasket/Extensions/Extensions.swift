//
//  Extensions.swift
//  ShoppingBasket
//
//  Created by Anders Sommer Lassen on 25/06/2020.
//

import Foundation
import SwiftUI

public extension View
{
    /// Convenience function to set up and return an OK/Cancel View.alert
    ///
    /// Use this function to easily set up a two-button OK/Cancel alert with a hardcoded title: "Error"
    ///
    /// - Parameters:
    ///     - isPresented: Boolean binding to hold state for presentation life-cycle.
    ///     - message: Message to display.
    ///     - OKAction: Action to perform when clicking the OK button.
    ///
    /// - Returns:self.alert(...) - set up as required.
    ///
    /// - Note: If action is required for the cancel out-come too, add a new variant.
    ///
    func alertOKCancel(isPresented presentAlert: Binding<Bool>, message:String, OKAction action: @escaping ()->Void) -> some View
    {
        let view = self
        
        return view.alert(isPresented: presentAlert) {
            
            Alert(title: Text("Alert"),
                  message: Text(message),
                  primaryButton: Alert.Button.default(Text("OK"), action: { presentAlert.wrappedValue = false; action() }),
                  secondaryButton: .default(Text("Cancel")))
        }
    }
}


