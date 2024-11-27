//
//  detailsTabBarController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/11/27.
//

import UIKit

class detailsTabBarController: UITabBarController {
    
    var city: String?
    var currentTemp: Int?
    var currentStatus: String? 
    

    @IBAction func composeTweet(_ sender: UIBarButtonItem) {
        let tweetText = "The current temperature at \(self.city ?? "") is \(self.currentTemp ?? 0)°F. The weather conditions are \(self.currentStatus ?? "")."
        let hashtags = "CSCI571WeatherSearch"

        let tweet = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let hashtagParam = hashtags.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let tweetLink = "https://twitter.com/intent/tweet?text=\(tweet)&hashtags=\(hashtagParam)"

        let url = URL(string: tweetLink)!
        UIApplication.shared.open(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
