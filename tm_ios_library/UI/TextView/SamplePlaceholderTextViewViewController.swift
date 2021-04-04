//
//  SamplePlaceholderTextViewViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/04.
//

import UIKit

class SamplePlaceholderTextViewViewController: UIViewController {
    @IBOutlet weak var placeholderTextView: PlaceholderTextview!
    
    public static let identifier = String(describing: SamplePlaceholderTextViewViewController.self)
        
    static func createInstance() -> SamplePlaceholderTextViewViewController {
        let storyboard = UIStoryboard(name: identifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! SamplePlaceholderTextViewViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
        ]
        
        placeholderTextView.placeholder = "PlaceholderTextView1"
        placeholderTextView.inputAccessoryView = toolbar
        
        let placeholderTextView2 = PlaceholderTextview(frame: CGRect(x: 0, y: placeholderTextView.frame.size.height + 50, width: self.view.frame.size.width, height: 200))
        placeholderTextView2.placeholder = "PlaceholderTextView2"
        placeholderTextView2.text = "test text!!"
        placeholderTextView2.inputAccessoryView = toolbar
        self.view.addSubview(placeholderTextView2)
    }
    
    @objc private func tappedDone() {
        self.view.endEditing(true)
    }
}
