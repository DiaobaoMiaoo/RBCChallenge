//
//  BaseViewController.swift
//  RBCChallenge
//
//  Created by Ke MA on 2017-08-17.
//  Copyright © 2017 Kemin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PopupDialog

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
     To replace the default Apple Alert View.
     If only need cancel button, leave actionButtonTitle to be nil.
     If need both cancel button and action button, name the actionButtonTitle and pass in the action to execute.
     */
    func showPopUpMessage(title: String?, message: String?, cancelButtonTitle: String = "OK", actionButtonTitle: String?, action: @escaping (() -> ())) {
        
        let popup = PopupDialog(title: title, message: message, image: nil)
        var buttons = [CancelButton]()
        
        let cancelButton = CancelButton(title: cancelButtonTitle) {}
        buttons.append(cancelButton)
        
        if let actionButtonTitle = actionButtonTitle {
            let actionButton = CancelButton(title: actionButtonTitle) {
                action()
            }
            buttons.append(actionButton)
        }
        
        popup.addButtons(buttons)
        popup.buttonAlignment = .horizontal
        self.present(popup, animated: true, completion: nil)
    }
}
