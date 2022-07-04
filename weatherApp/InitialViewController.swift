//
//  InitialViewController.swift
//  weatherApp
//
//  Created by ToshiPro01 on 2022/07/04.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "toWeather", sender: nil)
    }
}
