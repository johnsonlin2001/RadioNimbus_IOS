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
    func tableView(_ cityDropDown: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ cityDropDown: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = cityDropDown.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let location = suggestions[indexPath.row]
        cityCell.textLabel?.text = "\(location.city)"
        return cityCell
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
    
    @IBOutlet weak var citySearchBar: UISearchBar!
    
    @IBOutlet weak var cityDropDown: UITableView!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var subview1: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        citySearchBar.delegate = self
        cityDropDown.delegate = self
        cityDropDown.dataSource = self
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

        let selectedLocation = suggestions[indexPath.row]
        
        citySearchBar.text = selectedLocation.city

        suggestions = []
        cityDropDown.reloadData()
        self.cityDropDown.isHidden = self.suggestions.isEmpty
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
        let currentData = intervals?.first
        let values = currentData?["values"] as? [String: Any]
        let currentTemperature = values?["temperature"] as? Double ?? 0.0
        temperatureLabel.text = "\(currentTemperature)°F"
        var weatherCode = values?["weatherCode"] as? Int ?? 0
        let currentStatus = weatherCodes[weatherCode]
        statusLabel.text = currentStatus
        weatherImage.image = UIImage(named: currentStatus ?? "Clear")
        
        
        
        
    }


}

