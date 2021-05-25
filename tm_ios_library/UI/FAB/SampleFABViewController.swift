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
        
        let fab = SimpleFloatingActionButton()
        fab.frontColor = .blue
        fab.shadowOffset = CGSize(width: 0.0, height: 2.0)
        fab.shadowColor = .black
        fab.shadowOpacity = 0.6
        fab.delegate = self
        view.addSubview(fab)
        fab.translatesAutoresizingMaskIntoConstraints = false
        fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        fab.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        fab.widthAnchor.constraint(equalToConstant: 63).isActive = true
        fab.heightAnchor.constraint(equalToConstant: 63).isActive  = true
        
        let item1 = SimpleFloatingActionButtonItem()
        item1.backgroundColor = .green
        fab.addImte(item: item1)
        item1.tapped = { item in
            print("item1 tapped")
        }
        
        let item2 = SimpleFloatingActionButtonItem()
        item2.backgroundColor = .yellow
        fab.addImte(item: item2)
        item2.tapped = { item in
            print("item2 tapped")
        }
    }
}

extension SampleFABViewController: SimpleFloatingActionButtonDelegate {
    func didClose() {
        print("didClose")
    }
    
    func didTappe() {
        print("didTappe")
    }
    
    func didOpen() {
        print("didOpen")
    }
}
