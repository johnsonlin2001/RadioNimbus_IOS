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
        sub1.layer.borderColor = UIColor.white.cgColor
        sub1.layer.borderWidth = 1.0
        sub2.layer.borderColor = UIColor.white.cgColor
        sub2.layer.borderWidth = 1.0
        sub3.layer.borderColor = UIColor.white.cgColor
        sub3.layer.borderWidth = 1.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBOutlet weak var sub1: UIView!
    
    @IBOutlet weak var sub2: UIView!
    
    @IBOutlet weak var sub3: UIView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
