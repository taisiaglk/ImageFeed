//
//  File.swift
//  ImageFeed
//
//  Created by Тася Галкина on 28.12.2023.
//

import Foundation

let dateFormat: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMMM yyyy"
    return dateFormatter
}()
