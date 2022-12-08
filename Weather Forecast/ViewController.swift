//
//  ViewController.swift
//  Weather Forecast
//
//  Created by laptop on 2022-12-07.
//

import UIKit

class ViewController: UIViewController {
    var units = "&units=metric"
    var degree = "°C"

    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var unitSystem: UISegmentedControl!
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var tempL: UILabel!
    @IBOutlet weak var tempFL: UILabel!
    @IBOutlet weak var tempH: UILabel!
    @IBOutlet weak var weather: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchSystem(_ sender: Any) {
        switch unitSystem.selectedSegmentIndex {
        case 0:
            self.units = "&units=metric"
            self.degree = "°C"
//            print("metric")
        case 1:
            self.units = "&units=imperial"
            self.degree = "°F"
//            print("imperial")
        default:
            self.units = "&units=metric"
            self.degree = "°C"
//            print("metric")
        }
        
        fetchWeather(self)
    }

    @IBAction func fetchWeather(_ sender: Any) {
        let baseUrl = "https://api.openweathermap.org/data/2.5/weather?q="
        
        let cityName = cityInput.text ?? "Vancouver"
        
        let apiKey = "&appid=0d6ea1c728b59d0bd10630142fa767a0"
        
        let url = URL(string: baseUrl + cityName.replacingOccurrences(of: " ", with: "%20") + apiKey + self.units)
        
//        print(baseUrl + cityName + apiKey + self.units)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) {(data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)

                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                if data != nil {
                    do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)

                        DispatchQueue.main.async {
                            if let tempData = (jsonResponse as AnyObject)["main"] as? [String : Any ] {
//                                print(tempData)
                                if let temp = tempData["temp"] as? Double {
                                    self.temp.text = "\(Int(temp))\(self.degree)"
                                }
                                if let tempH = tempData["temp_max"] as? Double {
                                    self.tempH.text = "High \(Int(tempH))\(self.degree)"
                                }
                                if let tempL = tempData["temp_min"] as? Double {
                                    self.tempL.text = "Low \(Int(tempL))\(self.degree)"
                                }
                                if let tempFL = tempData["feels_like"] as? Double {
                                    self.tempFL.text = "Feels like \(Int(tempFL))\(self.degree)"
                                }
                            }
                            if let data = (jsonResponse as AnyObject) as? [String : Any ] {
                                if let weatherArray =  data["weather"] as? [ Any] {
                                    if let weatherObject = weatherArray[0] as? [String: Any] {
                                        if let weather = weatherObject["description"] as? String {
                                            self.weather.text = weather
                                        }
                                    }
                                }
                            }
                            if let cityName = (jsonResponse as AnyObject)["name"] as? String {
                                self.city.text = cityName.uppercased()
                            }
                        }
                    } catch {
                        print("error")
                    }
                }

            }
        }
        task.resume()
    }
    
}

