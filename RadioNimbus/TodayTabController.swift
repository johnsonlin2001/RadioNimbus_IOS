//
//  TodayTabController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/11/25.
//

import UIKit

class TodayTabController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sub1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub2.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub3.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub4.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub5.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub6.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub7.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub8.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        sub9.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        sub1.layer.borderColor = UIColor.white.cgColor
        sub1.layer.borderWidth = 1.0
        sub2.layer.borderColor = UIColor.white.cgColor
        sub2.layer.borderWidth = 1.0
        sub3.layer.borderColor = UIColor.white.cgColor
        sub3.layer.borderWidth = 1.0
        
        sub4.layer.borderColor = UIColor.white.cgColor
        sub4.layer.borderWidth = 1.0
        sub5.layer.borderColor = UIColor.white.cgColor
        sub5.layer.borderWidth = 1.0
        sub6.layer.borderColor = UIColor.white.cgColor
        sub6.layer.borderWidth = 1.0
        
        sub7.layer.borderColor = UIColor.white.cgColor
        sub7.layer.borderWidth = 1.0
        sub8.layer.borderColor = UIColor.white.cgColor
        sub8.layer.borderWidth = 1.0
        sub9.layer.borderColor = UIColor.white.cgColor
        sub9.layer.borderWidth = 1.0
        
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.isTranslucent = false
        
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = city
        self.title = city!
        print(self.data)
        updateValues(with: self.data!)
    }
    
    var city: String?
    
    var data: [String: Any]?
    
    
    @IBOutlet weak var sub1: UIView!
    
    @IBOutlet weak var sub2: UIView!
    
    @IBOutlet weak var sub3: UIView!
    
    @IBOutlet weak var sub4: UIView!
    
    @IBOutlet weak var sub5: UIView!
    
    @IBOutlet weak var sub6: UIView!
    
    @IBOutlet weak var sub7: UIView!
    
    @IBOutlet weak var sub8: UIView!
    
    @IBOutlet weak var sub9: UIView!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var precLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var visibilityLabel: UILabel!
    
    @IBOutlet weak var cloudLabel: UILabel!
    
    @IBOutlet weak var UVLabel: UILabel!
    
    let weatherCodes: [Int: String] = [
        0: "Unknown",
        1000: "Clear",
        1100: "Mostly Clear",
        1101: "Partly Cloudy",
        1102: "Mostly Cloudy",
        1001: "Cloudy",
        2000: "Fog",
        2100: "Light Fog",
        4000: "Drizzle",
        4001: "Rain",
        4200: "Light Rain",
        4201: "Heavy Rain",
        5000: "Snow",
        5001: "Flurries",
        5100: "Light Snow",
        5101: "Heavy Snow",
        6000: "Freezing Drizzle",
        6001: "Freezing Rain",
        6200: "Light Freezing Rain",
        6201: "Heavy Freezing Rain",
        7000: "Ice Pellets",
        7101: "Heavy Ice Pellets",
        7102: "Light Ice Pellets",
        8000: "Thunderstorm"
    ]
    
    func updateValues(with weatherData:[String: Any]){
        let currentTemperature = weatherData["temperature"] as? Double ?? 0
        temperatureLabel.text = "\(Int(currentTemperature.rounded()))°F"
        let currentHumidity = weatherData["humidity"] as? Double ?? 0
        humidityLabel.text = "\(Int(currentHumidity.rounded())) %"
        let currentWindspeed = weatherData["windSpeed"] as? Double ?? 0
        windLabel.text = "\(currentWindspeed) mph"
        let currentPressure = weatherData["pressureSeaLevel"] as? Double ?? 0
        pressureLabel.text = "\(currentPressure) inHg"
        let currentPrec = weatherData["precipitationProbability"] as? Int ?? 0
        precLabel.text = "\(currentPrec) %"
        let currentVis = weatherData["visibility"] as? Double ?? 0
        visibilityLabel.text = "\(currentVis) mi"
        let currentCCover = weatherData["cloudCover"] as? Int ?? 0
        cloudLabel.text = "\(currentCCover) %"
        let currentUV = weatherData["uvIndex"] as? Int ?? 0
        UVLabel.text = "\(currentUV)"
        let weatherCode = weatherData["weatherCode"] as? Int ?? 0
        let currentStatus = weatherCodes[weatherCode]
        statusLabel.text = currentStatus
        statusImage.image = UIImage(named: currentStatus ?? "Clear")
        
        
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
