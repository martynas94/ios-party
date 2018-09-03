//
//  AppError.swift
//  tesonetTestApp
//
//  Created by Martynas P on 28/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

class AppError: NSError {

    required init(code: Int, message: String) {
        super.init(domain: "com.martynas.pasilis.tesonetTestApp", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
