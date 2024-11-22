//
//  ViewController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/11/17.
//

import UIKit

import Alamofire

import CoreLocation


class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    var scheduleFetch: DispatchWorkItem?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView==cityDropDown){
            print("cityDropDown numberOfRowsInSection called")
            return suggestions.count
        
        }else if(tableView==weeklyTable){
            print("weeklyTable numberOfRowsInSection called")
            return weeklyData.count
        }else{
            return 0
        }
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView==cityDropDown){
            print(0)
            let cityCell = cityDropDown.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let location = suggestions[indexPath.row]
            cityCell.textLabel?.text = "\(location.city)"
            return cityCell
        }else if(tableView==weeklyTable){
            print(1)
            let dayCell = weeklyTable.dequeueReusableCell(withIdentifier: "day", for: indexPath)as? weeklyTableViewCell
            let currentData = weeklyData[indexPath.row]
            print(currentData)
            let startTime = currentData["startTime"] as? String
            dayCell?.dateLabel.text = startTime
            let values = currentData["values"] as? [String: Any]
            let weatherCode = values?["weatherCode"] as? Int ?? 0
            let currentStatus = weatherCodes[weatherCode]
            dayCell?.dayWeatherImage.image = UIImage(named: currentStatus ?? "Clear")
            let sunRiseTime = values?["sunriseTime"] as? String
            let sunSetTime = values?["sunsetTime"] as? String
            dayCell?.sunRiseLabel.text = self.convertTime(time: sunRiseTime!)
            dayCell?.sunsetLabel.text = self.convertTime(time: sunSetTime!)
            
            
            
            
            return dayCell!
        }
        return UITableViewCell()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            scheduleFetch?.cancel()

            guard !searchText.isEmpty else {
                suggestions = []
                cityDropDown.reloadData()
                cityDropDown.isHidden = true
                return
            }

            let fetch = DispatchWorkItem { [weak self] in
                self?.getCityAutocomplete(for: searchText)
            }
            scheduleFetch = fetch

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: fetch)
    }
    
    
    var suggestions: [(city: String, state: String)] = []
    
    var weeklyData: [[String: Any]] = []

    
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    @IBOutlet weak var cityDropDown: UITableView!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var subview1: UIView!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windspeedLabel: UILabel!
    
    @IBOutlet weak var visibilityLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var weeklyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weeklyTable.reloadData()
        locationManager.delegate = self
        citySearchBar.delegate = self
        cityDropDown.delegate = self
        cityDropDown.dataSource = self
        weeklyTable.delegate = self
        weeklyTable.dataSource = self
        print("WeeklyTable delegate and data source set")
        view.bringSubviewToFront(cityDropDown)
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        cityDropDown.isHidden = true
        subview1.backgroundColor = UIColor.white.withAlphaComponent(0.5)

    }
    
    // Delegate method: Successfully received location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation() // Stop updates if not needed continuously

            getWeatherData(for: latitude ?? 37.7749 , for: longitude ?? -122.4194)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { place, error in
            let place = place?.first
            let city = place?.locality
            self.locationLabel.text = city
                }


        }
    }

    // Delegate method: Failed to fetch location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error.localizedDescription)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView==cityDropDown){
            let selectedLocation = suggestions[indexPath.row]
            
            citySearchBar.text = selectedLocation.city
            
            suggestions = []
            cityDropDown.reloadData()
            self.cityDropDown.isHidden = self.suggestions.isEmpty
        }
    }
    
    func getCityAutocomplete(for query: String) {
        let backendUrl = "https://radionimbus.wl.r.appspot.com/places"
        let queryParams: [String: String] = ["input": query]
        
        AF.request(backendUrl, method: .get, parameters: queryParams).validate().responseDecodable(of: [[String: String]].self) { response in
            switch response.result {
            case .success(let cityResults):
                self.suggestions = cityResults.compactMap { citySuggestions in
                    let city = citySuggestions["city"]
                    let state = citySuggestions["state"]
                    return (city, state) as? (city: String, state: String)
                }
                DispatchQueue.main.async {
                    self.cityDropDown.reloadData()
                    self.cityDropDown.isHidden = self.suggestions.isEmpty

                }
            case .failure(let error):
                print(error)
                
                DispatchQueue.main.async {
                    self.suggestions = []
                    self.cityDropDown.reloadData()
                    self.cityDropDown.isHidden = self.suggestions.isEmpty
                }
            }
        }
        
    }
    
    func getWeatherData(for lat: Double, for long: Double){
        let backendUrl = "https://radionimbus.wl.r.appspot.com/fetchweatherdata"
        let queryParams: [String: Any] = ["lat": lat, "long": long]
        
        AF.request(backendUrl, method: .get, parameters: queryParams).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                if let weatherData = json as? [String: Any] {
                    self.updateValues(with: weatherData)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
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
        self.weeklyTable.reloadData()
        let currentData = intervals?.first
        let values = currentData?["values"] as? [String: Any]
        let currentTemperature = values?["temperature"] as? Double ?? 0.0
        temperatureLabel.text = "\(currentTemperature)°F"
        let weatherCode = values?["weatherCode"] as? Int ?? 0
        let currentStatus = weatherCodes[weatherCode]
        statusLabel.text = currentStatus
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


}

