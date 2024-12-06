//
//  weeklyTabController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/12/5.
//

import UIKit

class weeklyTabController: UIViewController {
    var currentTemp: Int?
    var currentStatus: String? 
    
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.isTranslucent = false
        topview.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        topview.layer.borderColor = UIColor.white.cgColor
        topview.layer.borderWidth = 1.0
        
        statusLabel.text = currentStatus
        tempLabel.text = "\((currentTemp) ?? 0)°F"
        statusImg.image = UIImage(named: currentStatus ?? "Clear")
    }
    
    @IBOutlet weak var topview: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
