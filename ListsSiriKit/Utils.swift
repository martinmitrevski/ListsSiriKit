//
//  Utils.swift
//  ListsSiriKit
//
//  Created by Martin Mitrevski on 24.06.17.
//  Copyright © 2017 Martin Mitrevski. All rights reserved.
//

import Foundation
import UIKit

func alertForAddingItems(title: String,
                         placeholder: String)
    -> UIAlertController {
    
    let alertController = UIAlertController(title: title,
                                            message: nil,
                                            preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = placeholder
    }
    
    return alertController
}

func addActions(toAlertController alertController: UIAlertController,
                saveActionHandler: @escaping ((UIAlertAction) -> Swift.Void))
    -> UIAlertController {
        
    let saveAction = UIAlertAction(title: "Save", style: .default, handler: saveActionHandler)
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel,
                                     handler: { action in
                                        alertController.dismiss(animated: true, completion: nil)
                                     })
        
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
        
    return alertController
}
