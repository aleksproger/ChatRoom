//
//  LanguagesViewController.swift
//  ChatRoom
//
//  Created by Alex on 04.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController {

    let inputGroup0 = InputViewPair()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        // Do any additional setup after loading the view.
    }
    
    func loadViews() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(inputGroup0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = view.safeAreaInsets
        if insets.bottom == 0 {
            insets.bottom = 16
        } else {
            insets.bottom = 0
        }
        print(insets.top)
        inputGroup0.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 2 * 44 + 40)
        inputGroup0.center = CGPoint(x: inputGroup0.bounds.size.width/2.0, y: inputGroup0.bounds.height/2.0 + insets.top + 15)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
