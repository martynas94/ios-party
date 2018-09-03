//
//  LoadingViewController.swift
//  tesonetTestApp
//
//  Created by Martynas P on 01/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet var loadingCircleView: LoadingCircleView!

    func startRotating() {
        loadingCircleView.startRotating()
    }

    func stopRotating() {
        loadingCircleView.stopRotating()
    }
    
}
