//
//  ViewController.swift
//  weatherApp
//
//  Created by ToshiPro01 on 2022/06/26.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapReloadButton(_ sender: Any) {
        let weather = YumemiWeather.fetchWeatherCondition()
        weatherImageView.image = UIImage(named: weather)
    }
}

