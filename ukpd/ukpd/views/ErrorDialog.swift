//
//  ErrorDialog.swift
//  ukpd
//
//  Created by Alex Chesters on 06/09/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit

class ErrorDialog: NSObject {

    private let title: String = "Oops"
    private let message: String = "Something went wrong."

    public func showFor(view: UIViewController) {
        let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))

        view.present(alert, animated: true)
    }
}
