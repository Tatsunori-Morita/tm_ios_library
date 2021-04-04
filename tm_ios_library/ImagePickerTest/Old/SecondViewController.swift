//
//  SecondViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/20.
//

import UIKit
import DKImagePickerController

class SecondViewController: DKImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        maxSelectableCount = 5
        sourceType = .photo
        showsCancelButton = true
    }
}
