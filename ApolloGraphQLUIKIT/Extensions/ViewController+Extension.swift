//
//  ViewController+Extension.swift
//  ApolloGraphQLUIKIT
//
//  Created by Mariano Battaglia on 11/06/2022.
//

import UIKit

//MARK: - Spinner View
fileprivate var aView: UIView?

extension UIViewController {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
//        Next line is for put background to the spinner:
//        aView?.backgroundColor = UIColor.white
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = UIColor(red: 0.255, green: 0.561, blue: 0.886, alpha: 1.0)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
    func showAlert(label: String, delay: Double, animated: Bool) {
        let alert = UIAlertController(title: label, message: "", preferredStyle: .alert)
        self.present(alert, animated: animated, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.dismiss(animated: animated)
        })
    }
}
