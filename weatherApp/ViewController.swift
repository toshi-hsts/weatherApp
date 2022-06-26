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
        let area = "tokyo"
        do {
            let weather = try YumemiWeather.fetchWeatherCondition(at: area)
            weatherImageView.image = UIImage(named: weather)
        } catch {
            showAlert()
        }
    }
    
    private func showAlert(){
        let alert =
        UIAlertController(title:"エラー",
                          message: "通信エラーが発生しました。",
                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
}

