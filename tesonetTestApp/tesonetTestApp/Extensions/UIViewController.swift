//
//  UIViewController.swift
//  tesonetTestApp
//
//  Created by Martynas P on 01/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentError(_ error: NSError) {
        let controller = alertController(for: error)
        present(controller, animated: true, completion: nil)
    }

    func alertController(for error: NSError) -> UIAlertController {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)

        alertController.addAction(dismissAction)

        return alertController
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func endEditing() {
        self.view.endEditing(true)
    }

    func setupKeyboardNotifications(for selector: Selector) {
        let noteCenter = NotificationCenter.default
        noteCenter.addObserver(self,
                               selector: selector,
                               name: NSNotification.Name.UIKeyboardWillShow,
                               object: nil)
    }

    func removeKeyboardNotifications() {
        let noteCenter = NotificationCenter.default
        noteCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
}
