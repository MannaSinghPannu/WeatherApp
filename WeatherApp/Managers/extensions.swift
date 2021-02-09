//
//  extensions.swift
//  My Weather App
//
//  Created by Manna Pannu on 2/7/21.
//

import Foundation
import Toast_Swift


extension UIViewController
{
    
    func showToast(view:UIView,message:String)
    {
        DispatchQueue.main.async{
    self.view.makeToast(message, duration: 3.0, position: .center)
        }
    }
}
