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
        let date = Date()
        let json = encode(area: area, date: date)
        
        guard json.isEmpty == false else { return }
        
        do {
            let response = try YumemiWeather.fetchWeather(json)
            
            guard let result = decode(response) else { return }
            
            weatherImageView.image = UIImage(named: result.weather)
            blueLabel.text = String(result.minTemperature)
            redLabel.text = String(result.maxTemperature)
        } catch {
            showAlert()
        }
    }
    
    private func decode(_ json: String) -> Response? {
        var response: Response?
        
        do {
            let jsonData = json.data(using: .utf8)!
            response = try JSONDecoder().decode(Response.self, from: jsonData)
        } catch {
            print(error.localizedDescription)
        }
        
        return response
    }
    
    private func encode(area: String, date: Date) -> String {        
        var json = ""
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted

        let request = Request(area: area, date: date)
        
        do {
            let encodedData = try encoder.encode(request)
            json = String(data: encodedData, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
        
        return json
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
