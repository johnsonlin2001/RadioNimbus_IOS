//
//  ResultsViewController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/11/22.
//

import UIKit

import Alamofire

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView==weeklyTable){
            return weeklyData.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView==weeklyTable){
            let dayCell = weeklyTable.dequeueReusableCell(withIdentifier: "day", for: indexPath)as? weeklyTableViewCell
            let currentData = weeklyData[indexPath.row]
            let startTime = currentData["startTime"] as? String
            dayCell?.dateLabel.text = self.convertDate(time: startTime!)
            let values = currentData["values"] as? [String: Any]
            let weatherCode = values?["weatherCode"] as? Int ?? 0
            let currentStatus = weatherCodes[weatherCode]
            dayCell?.dayWeatherImage.image = UIImage(named: currentStatus ?? "Clear")
            let sunRiseTime = values?["sunriseTime"] as? String
            let sunSetTime = values?["sunsetTime"] as? String
            dayCell?.sunRiseLabel.text = self.convertTime(time: sunRiseTime!)
            dayCell?.sunsetLabel.text = self.convertTime(time: sunSetTime!)
            

            return dayCell!
        }else{
            return UITableViewCell()
        }
    }
    
    func convertDate(time: String) -> String? {

        let inputDate = DateFormatter()
        inputDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputDate.timeZone = TimeZone(abbreviation: "UTC")

        let date = inputDate.date(from: time)

        let outputDate = DateFormatter()
        outputDate.dateFormat = "MM/dd/yyyy"
        outputDate.timeZone = TimeZone.current

        let newDate = outputDate.string(from: date!)
        return newDate
    }
    
    func convertTime(time: String) -> String? {

        let inputDate = DateFormatter()
        inputDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        inputDate.timeZone = TimeZone(abbreviation: "UTC")

        let date = inputDate.date(from: time)
        
        let outputDate = DateFormatter()
        outputDate.dateFormat = "hh:mm a"
        outputDate.timeZone = TimeZone(abbreviation: "PST")

        let pstTime = outputDate.string(from: date!)
        return pstTime
    }
    
    
    var weatherData: [String: Any]?
    var city: String?
    var state: String?
    var currentTemp: Double?
    var currentStatus: String?
    var isFav: Bool = false
    var currentLat: Double?
    var currentLong: Double?
    
    var weeklyData: [[String: Any]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    @IBOutlet weak var windspeedLabel: UILabel!
    
    
    @IBOutlet weak var visibilityLabel: UILabel!
    
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    @IBOutlet weak var subview1: UIView!
    
    
    @IBOutlet weak var weeklyTable: UITableView!
    
    @IBOutlet weak var favButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subview1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.title = city
        cityLabel.text = city
        weeklyTable.delegate = self
        weeklyTable.dataSource = self
        if let data = weatherData {
                    self.updateValues(with: data)
                }
        
        // Do any additional setup after loading the view.
    }
    
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
        let daily_data = weatherData["daily_data"]as? [String: Any]
        let data = daily_data?["data"] as? [String: Any]
        let timelines = data?["timelines"] as? [[String: Any]]
        let intervals = timelines?.first?["intervals"] as? [[String: Any]]
        self.weeklyData = intervals!
        let currentData = intervals?.first
        let values = currentData?["values"] as? [String: Any]
        let currentTemperature = values?["temperature"] as? Double ?? 0.0
        self.currentTemp = currentTemperature
        self.weeklyTable.reloadData()
        temperatureLabel.text = "\(currentTemperature)°F"
        let weatherCode = values?["weatherCode"] as? Int ?? 0
        let currentStatus = weatherCodes[weatherCode]
        self.currentStatus = currentStatus
        weatherStatusLabel.text = currentStatus
        weatherImage.image = UIImage(named: currentStatus ?? "Clear")
        let currentHumidity = values?["humidity"] as? Int ?? 0
        humidityLabel.text = "\(currentHumidity) %"
        let currentWindspeed = values?["windSpeed"] as? Double ?? 0
        windspeedLabel.text = "\(currentWindspeed) mph"
        let currentVisibility = values?["visibility"] as? Double ?? 0
        visibilityLabel.text = "\(currentVisibility) mi"
        let currentPressure = values?["pressureSeaLevel"] as? Double ?? 0
        pressureLabel.text = "\(currentPressure) inHg"
        
    }
    
    @IBAction func composeTweet(_ sender: UIBarButtonItem) {

        let tweetText = "The current temperature at \(self.city ?? "") is \(self.currentTemp ?? 0)°F. The weather conditions are \(self.currentStatus ?? "")."
        let hashtags = "CSCI571WeatherSearch"

        let tweet = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let hashtagParam = hashtags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let tweetLink = "https://twitter.com/intent/tweet?text=\(tweet)&hashtags=\(hashtagParam)"

        let url = URL(string: tweetLink)!
        UIApplication.shared.open(url)
        
    }
    
    
    @IBAction func favClick(_ sender: Any) {
        if(self.isFav){
            favButton.setImage(UIImage(named: "plus-circle"), for: .normal)
            self.deleteFav(for: self.city ?? "", for: self.state ?? "")
        }else{
            favButton.setImage(UIImage(named: "close-circle"), for: .normal)
            self.addFav(for: self.city ?? "", for: self.state ?? "", for: self.currentLat ?? 0, for: self.currentLong ?? 0)
        }
        self.isFav = !self.isFav
        
        
    }
    
    func addFav(for city: String, for state: String, for lat: Double, for long: Double){
        print("Sending to backend:")
        print("City: \(city), State: \(state), Lat: \(lat), Long: \(long)")
        let backendUrl = "https://radionimbus.wl.r.appspot.com/addfavorites"
        let queryParams: [String: Any] = ["city": city, "state": state,"lat": lat, "long": long]
        
        let encoder = URLEncoding(destination: .queryString)
        
        AF.request(backendUrl, method: .post, parameters: queryParams, encoding: encoder).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                print("succesfully added to favorites")
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func deleteFav(for city: String, for state: String){
        print("Sending to backend:")
        print("City: \(city), State: \(state)")
        let backendUrl = "https://radionimbus.wl.r.appspot.com/deleteFavorite"
        let queryParams: [String: Any] = ["city": city, "state": state]
        
        let encoder = URLEncoding(destination: .queryString)
        
        AF.request(backendUrl, method: .delete, parameters: queryParams, encoding: encoder).validate().responseJSON { response in
            switch response.result {
            case .success(_): break
            case .failure(let error):
                print(error)
            }
        }
        
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
