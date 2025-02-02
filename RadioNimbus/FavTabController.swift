//
//  FavTabController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/12/9.
//

import UIKit

import Alamofire

import CoreLocation
import SwiftSpinner


class FavTabController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let locationManager = CLLocationManager()
    var latitude: String?
    var longitude: String?
    
    
    var selectedLat: Double?
    var selectedLong: Double?
    
    var weatherData: [String: Any]?
    
    var selectedCity: String?
    var selectedState: String?
    
    var currentCity: String?
    var currentState: String?
    
    var todayData: [String: Any]?
    var currentTemp: Int?
    var currentStatus: String?
    
    var currentPrec: Int?
    var currentHum: Int?
    var currentCloudCover: Int?

    
    var scheduleFetch: DispatchWorkItem?
    
    var Fetched = false
    
    func fetchWeatherData() {
            if !Fetched {
                getWeatherData(for: Double(latitude ?? "0") ?? 37.7749 , for: Double(longitude ?? "0") ?? -122.4194)
                Fetched = true
            }
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView==cityDropDown){
            return suggestions.count
        
        }else if(tableView==weeklyTable){
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView==cityDropDown){
            let cityCell = cityDropDown.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            let location = suggestions[indexPath.row]
            cityCell.textLabel?.text = "\(location.city)"
            return cityCell
        }else if(tableView==weeklyTable){
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
    
    @IBAction func tapDetails(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weeklyTable.reloadData()
        citySearchBar.delegate = self
        cityDropDown.delegate = self
        cityDropDown.dataSource = self
        weeklyTable.delegate = self
        weeklyTable.dataSource = self
        view.bringSubviewToFront(cityDropDown)
        cityDropDown.isHidden = true
        subview1.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.navigationItem.backButtonTitle = "Weather"

    }
    
    // Delegate method: Successfully received location updates
    
    func getCityCoordinates(for location: (city: String, state: String), completion: @escaping (Double?, Double?) -> Void) {
        let geocoder = CLGeocoder()
        let address = "\(location.city), \(location.state)"
        geocoder.geocodeAddressString(address) { places, error in
            if let place = places?.first, let coordinates = place.location?.coordinate {
                completion(coordinates.latitude, coordinates.longitude)
            } else {
                completion(0.00, 0.00)
            }
        }
    }

    // Delegate method: Failed to fetch location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error.localizedDescription)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultsSegue" {
            // Pass data to the ResultsViewController
            let resultsView = segue.destination as? ResultsViewController
            resultsView?.city = self.selectedCity
            resultsView?.state = self.selectedState
            resultsView?.weatherData = self.weatherData
            resultsView?.currentLat = self.selectedLat
            resultsView?.currentLong = self.selectedLong
        }
        
        else if segue.identifier == "detailsSegue"{
            let detailsView = segue.destination as? detailsTabBarController
            detailsView?.city = self.currentCity
            detailsView?.currentTemp = self.currentTemp
            detailsView?.currentStatus = self.currentStatus
            if let viewControllers = detailsView!.viewControllers {
            for view in viewControllers {
                if let todayTab = view as? TodayTabController {
                    todayTab.city = self.currentCity
                    todayTab.data = self.todayData
                    
                }
                else if let weeklyTab = view as? weeklyTabController{
                    weeklyTab.currentTemp = currentTemp
                    weeklyTab.currentStatus = currentStatus
                    weeklyTab.weeklyData = self.weeklyData
                }
                else if let weatherDataTab = view as? weatherDataTabController{
                    weatherDataTab.currentHum = self.currentHum
                    weatherDataTab.currentPrec = self.currentPrec
                    weatherDataTab.currentCloudCover = self.currentCloudCover
                    
                }
            }
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView==cityDropDown){
            let selectedLocation = suggestions[indexPath.row]
            
            citySearchBar.text = selectedLocation.city
            self.selectedCity = selectedLocation.city
            self.selectedState = selectedLocation.state
            
            suggestions = []
            cityDropDown.reloadData()
            self.cityDropDown.isHidden = self.suggestions.isEmpty
            
            SwiftSpinner.show("Fetching Weather Details for \(selectedLocation.city)")
            
            self.getCityCoordinates(for: selectedLocation) { [weak self] lat, long in
                guard let self = self, let latitude = lat, let longitude = long else {
                    SwiftSpinner.hide()
                    return
                }
                
                self.selectedLat = latitude
                self.selectedLong = longitude
                self.getWeatherData1(for: latitude, for: longitude){weatherData in
                    SwiftSpinner.hide()
                    
                    if weatherData != nil {
                        self.weatherData = weatherData
                        DispatchQueue.main.async {
                            print("Performing segue to results view")
                            self.performSegue(withIdentifier: "showResultsSegue", sender: self)
                        }
                        
                        
                    }
                }
                
                
            }
            
            
            
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
        print("fetching")
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
    
    func getWeatherData1(for lat: Double, for long: Double, completion: @escaping ([String: Any]?) -> Void) {
        let backendUrl = "https://radionimbus.wl.r.appspot.com/fetchweatherdata"
        let queryParams: [String: Any] = ["lat": lat, "long": long]
        
        AF.request(backendUrl, method: .get, parameters: queryParams).validate().responseJSON { response in
            switch response.result {
            case .success(let json):
                if let weatherData = json as? [String: Any] {
                    completion(weatherData)
                }
            case .failure(let error):
                print(error)
                completion(nil)
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
        locationLabel.text = self.currentCity
        let daily_data = weatherData["daily_data"]as? [String: Any]
        let data = daily_data?["data"] as? [String: Any]
        let timelines = data?["timelines"] as? [[String: Any]]
        let intervals = timelines?.first?["intervals"] as? [[String: Any]]
        self.weeklyData = intervals!
        self.weeklyTable.reloadData()
        let currentData = intervals?.first
        let values = currentData?["values"] as? [String: Any]
        self.todayData = values
        let currentTemperature = values?["temperature"] as? Double ?? 0.0
        temperatureLabel.text = "\(Int(currentTemperature.rounded()))°F"
        self.currentTemp = Int(currentTemperature.rounded())
        let weatherCode = values?["weatherCode"] as? Int ?? 0
        let currentStatus = weatherCodes[weatherCode]
        statusLabel.text = currentStatus
        self.currentStatus = currentStatus
        weatherImage.image = UIImage(named: currentStatus ?? "Clear")
        let currentHumidity = values?["humidity"] as? Double ?? 0
        humidityLabel.text = "\(Int(currentHumidity.rounded())) %"
        let currentWindspeed = values?["windSpeed"] as? Double ?? 0
        windspeedLabel.text = "\(currentWindspeed) mph"
        let currentVisibility = values?["visibility"] as? Double ?? 0
        visibilityLabel.text = "\(currentVisibility) mi"
        let currentPressure = values?["pressureSeaLevel"] as? Double ?? 0
        pressureLabel.text = "\(currentPressure) inHg"
        
        let currentPrec = values?["precipitationProbability"] as? Int ?? 0
        self.currentPrec = currentPrec
        self.currentHum = Int(currentHumidity.rounded())
        let currentCCover = values?["cloudCover"] as? Double ?? 0
        self.currentCloudCover = Int(currentCCover.rounded())
        
    }


}
