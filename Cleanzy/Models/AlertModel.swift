//
//  AlertModel.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 10.11.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    var actions: [UIAlertAction] = [ UIAlertAction(title: "Tamam", style: .default) ]
}
