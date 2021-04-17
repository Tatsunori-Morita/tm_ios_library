//
//  SampleFABViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/14.
//

import UIKit

class SampleFABViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let fab = SimpleFloatingActionButton(frame: .zero)
        fab.frontColor = .blue
        fab.shadowOffset = CGSize(width: 2.0, height: 4.0)
        fab.shadowColor = .red
        fab.shadowOpacity = 1
        view.addSubview(fab)
        fab.translatesAutoresizingMaskIntoConstraints = false
        fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13).isActive = true
        fab.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        fab.widthAnchor.constraint(equalToConstant: 44).isActive = true
        fab.heightAnchor.constraint(equalToConstant: 44).isActive  = true
    }
}
