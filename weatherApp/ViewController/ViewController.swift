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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var delegate: APIClientDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(background(notification:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil
        )
    }
    
    deinit {
        print("deinit")
    }
    
    @IBAction func tapReloadButton(_ sender: Any) {
        let area = "tokyo"
        let date = Date()
        let json = encode(area: area, date: date)
        
        guard json.isEmpty == false else { return }
        
        indicator.startAnimating()
        
        Task {
            do {
                let response = try await delegate.fetchWeatherUsingAsync(with: json)
                let result = try decode(response)
                
                weatherImageView.image = UIImage(named: result.weather)
                blueLabel.text = String(result.minTemperature)
                redLabel.text = String(result.maxTemperature)
                
                indicator.stopAnimating()
            } catch {
                print(error.localizedDescription)
                indicator.stopAnimating()
                showAlert()
            }
        }
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @objc func foreground(notification: Notification) {
        print("フォアグラウンド")
        tapReloadButton(AnyObject.self)
    }
    @objc func background(notification: Notification) {
        print("バックグラウンド")
    }
    
    private func decode(_ json: String) throws -> Response {
        let jsonData = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(Response.self, from: jsonData)
        
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
