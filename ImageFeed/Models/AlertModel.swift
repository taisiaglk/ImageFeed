//
//  File.swift
//  ImageFeed
//
//  Created by Тася Галкина on 25.12.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let firstButtonText: String
    let secondButtonText: String?
    let firstButtonAction: (() -> Void)?
    let secondButtonAction: (() -> Void)?
}
