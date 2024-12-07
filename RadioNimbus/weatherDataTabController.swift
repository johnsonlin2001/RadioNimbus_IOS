//
//  weatherDataTabController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/12/6.
//

import UIKit

class weatherDataTabController: UIViewController {
    
    var currentPrec: Int?
    var currentHum: Int?
    var currentCloudCover: Int?
    
    
    @IBOutlet weak var precLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var ccLabel: UILabel!
    
    
    override func viewDidLoad() {
        print(currentCloudCover)
        super.viewDidLoad()
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.isTranslucent = false
        topView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        topView.layer.borderColor = UIColor.white.cgColor
        topView.layer.borderWidth = 1.0
        
        precLabel.text = "Precipitation: \(currentPrec ?? 0) %"
        humLabel.text = "Humidity: \(currentHum ?? 0) %"
        ccLabel.text = "Cloud Cover: \(currentCloudCover ?? 0) %"

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
