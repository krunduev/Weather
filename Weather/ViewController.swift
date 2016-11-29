//
//  ViewController.swift
//  Weather
//
//  Created by Kostyantyn Runduyev on 10/1/16.
//  Copyright © 2016 Kostyantyn Runduyev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var item:[String]? = nil
    
    @IBAction func submitButton(_ sender: AnyObject) {
        if let city = textBox.text {
            
            let urlStr = "http://api.openweathermap.org/data/2.5/weather?APPID=732d3ee66b6675ad25b4845f021e9bc4&q=" + city
            
            if let url = URL(string: urlStr) {
                
                let request = NSMutableURLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    if error != nil {
                        print(error!)
                    } else {
                        if let unwrapedData = data {
                            
                            do {
                                
                                let dataString = NSString(data: unwrapedData, encoding: String.Encoding.utf8.rawValue)
                                
                                let responceStr:String = String(describing: dataString!)
                                print(responceStr)
                                
                                
                                let data = responceStr.data(using: .utf8)!
                                
                                print(data)
                                
                                var resultStr = "Can't load data. Check internet connection and/or city name"
                                
                                //{"coord":{"lon":-118.24,"lat":34.05},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":300.37,"pressure":1014.5,"humidity":45,"temp_min":294.82,"temp_max":305.37},"wind":{"speed":1.16,"deg":194},"clouds":{"all":0},"dt":1475345192,"sys":{"type":3,"id":1451597784,"message":0.0202,"country":"US","sunrise":1475329706,"sunset":1475372120},"id":5368361,"name":"Los Angeles","cod":200}
                                
                                
                                let json = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                if let forecast = ((json["weather"] as? NSArray)?[0] as? NSDictionary)?["main"] as? String,
                                    let description = ((json["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String,
                                    let tempK = (json["main"] as? NSDictionary)?["temp"] as? Float,
                                    let pressure = (json["main"] as? NSDictionary)?["pressure"] as? Float,
                                    let humidity = (json["main"] as? NSDictionary)?["humidity"] as? Float,
                                    let name = json["name"] as? String
                                {
                                    
                                    resultStr = name + "\n" + forecast + " (" + description + ")\nTemp: " + String(tempK - 273.0) + "\nPressure: " +
                                        String(pressure) + "\nHumidity: " + String(humidity)
                                    
                                }
                                
                                
                                DispatchQueue.main.sync(execute: {
                                    self.resultLabel.text = resultStr
                                    self.view.endEditing(true)
                                })
                                
                            } catch {
                                print("Json processing error")
                            }
                        }
                    }
                }
                task.resume()
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UIGraphicsBeginImageContext(self.view.frame.size)
        //        UIImage(named: "weather.png")?.draw(in: self.view.bounds)
        //
        //        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //
        //        UIGraphicsEndImageContext()
        //
        //        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
}

