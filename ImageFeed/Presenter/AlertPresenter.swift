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
        
        let firstAction = UIAlertAction(title: alertModel.firstButtonText, style: .default) { _ in
            alertModel.firstButtonAction?()
        }
        alert.addAction(firstAction)
        
        if let secondButtonText = alertModel.secondButtonText {
            let secondAction = UIAlertAction(title: secondButtonText, style: .cancel) { _ in
                alertModel.secondButtonAction?()
            }
            alert.addAction(secondAction)
        }
        
        delegate.present(alert, animated: true, completion: nil)
    }
}
