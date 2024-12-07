//
//  weeklyTabController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/12/5.
//

import UIKit
import Highcharts

class weeklyTabController: UIViewController {
    var currentTemp: Int?
    var currentStatus: String? 
    
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    
    @IBOutlet weak var chartSub: UIView!
    
    var weeklyData: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var temperatureData: [[Any]] = []
        print(self.weeklyData)
        for day in weeklyData {
            if let startTime = day["startTime"] as? String,
               let values = day["values"] as? [String: Any],
               let tempLow = values["temperatureMin"] as? Double,
               let tempHigh = values["temperatureMax"] as? Double {
               let inputDateFormatter = ISO8601DateFormatter()
               if let date = inputDateFormatter.date(from: startTime) {
                    // Convert date to UTC timestamp
                    let calendar = Calendar(identifier: .gregorian)
                    let components = calendar.dateComponents([.year, .month, .day], from: date)
                    if let utcDate = calendar.date(from: components) {
                        let timestamp = utcDate.timeIntervalSince1970 * 1000
                        temperatureData.append([timestamp, tempLow, tempHigh])
                    }
                }
            }
        }

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.barTintColor = .white
        self.tabBarController?.tabBar.isTranslucent = false
        topview.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        topview.layer.borderColor = UIColor.white.cgColor
        topview.layer.borderWidth = 1.0
        
        statusLabel.text = currentStatus
        tempLabel.text = "\((currentTemp) ?? 0)°F"
        statusImg.image = UIImage(named: currentStatus ?? "Clear")
        
        let chartView = HIChartView(frame: self.view.bounds)
        chartView.plugins = ["exporting", "series-label", "accessibility"]

        let options = HIOptions()

        let chart = HIChart()
        chart.type = "arearange"
        chart.zooming = HIZooming()
        chart.zooming.type = "x"
        chart.scrollablePlotArea = nil
        options.chart = chart

        let title = HITitle()
        title.text = "Temperature Ranges (Min, Max)"
        options.title = title

        let xAxis = HIXAxis()
        xAxis.type = "datetime"
        let accessibility = HIAccessibility()
        accessibility.rangeDescription = "Date range"
        xAxis.accessibility = accessibility
        options.xAxis = [xAxis]

        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "Temperature (°F)"
        options.yAxis = [yAxis]
        
        let tooltip = HITooltip()
        tooltip.shared = NSNumber(value: true)
        tooltip.valueSuffix = "°F"
        tooltip.xDateFormat = "%A, %b %e"
        options.tooltip = tooltip

        let legend = HILegend()
        legend.enabled = false
        options.legend = legend

        let series = HIArearange()
        series.name = ""
        series.data = temperatureData
        series.color = HIColor()
        options.series = [series]
        
        let marker = HIMarker()
        marker.enabled = true
        marker.fillColor = HIColor(uiColor: UIColor.black)
        series.marker = marker
        
        let gradientColor = HIColor(linearGradient: ["x1": 0,"x2": 0,"y1": 0,"y2": 1], stops: [[0.0, "rgba(253, 215, 118, 1)"],[1.0, "rgba(156, 197, 255 , 1)"]])
        series.color = gradientColor

        chartView.options = options
        
        chartView.translatesAutoresizingMaskIntoConstraints = false

        chartSub.addSubview(chartView)

        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: chartSub.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: chartSub.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: chartSub.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: chartSub.bottomAnchor)
        ])

        chartSub.addSubview(chartView)
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
