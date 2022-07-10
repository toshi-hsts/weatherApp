//
//  ViewController.swift
//  weatherApp
//
//  Created by ToshiPro01 on 2022/06/26.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var delegate: APIClientDelegate?
    
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
    
    @IBAction func tapReloadButton(_ sender: Any) {
        let area = "tokyo"
        let date = Date()
        let json = encode(area: area, date: date)
        
        guard json.isEmpty == false else { return }
        
        indicator.startAnimating()
        
        DispatchQueue.global(qos: .default).async {
            do {
                guard let response = try self.delegate?.fetchWeather(with: json),
                      let result = self.decode(response) else { return }
                
                DispatchQueue.main.async {
                    self.weatherImageView.image = UIImage(named: result.weather)
                    self.blueLabel.text = String(result.minTemperature)
                    self.redLabel.text = String(result.maxTemperature)
                    
                    self.indicator.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.showAlert()
                }
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