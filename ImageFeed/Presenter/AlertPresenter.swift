//
//  File.swift
//  ImageFeed
//
//  Created by Тася Галкина on 25.12.2023.
//


import Foundation
import UIKit


final class AlertPresenter {
    static func showAlert(alertModel: AlertModel, delegate: UIViewController) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.message,
                                      preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.buttonAction()
        }
        alert.addAction(action)
        delegate.present(alert, animated: true, completion: nil)
    }
}
