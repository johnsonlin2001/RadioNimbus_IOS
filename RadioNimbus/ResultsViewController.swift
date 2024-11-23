//
//  ResultsViewController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/11/22.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var weatherData: [String: Any]?


    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let data = weatherData {
                    print("Received weather data: \(data)")
                    // Update labels, images, etc., with the weather data
                }
        // Do any additional setup after loading the view.
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
