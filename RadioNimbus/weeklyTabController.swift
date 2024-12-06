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
        
        let chartView = HIChartView(frame: self.view.bounds)
        chartView.plugins = ["exporting", "series-label", "accessibility"]

        // Chart Configuration
        let options = HIOptions()
        
        // Chart type and settings
        let chart = HIChart()
        chart.type = "arearange"
        chart.zooming = HIZooming()
        chart.zooming.type = "x"
        chart.scrollablePlotArea = nil
        options.chart = chart
        
        // Chart title
        let title = HITitle()
        title.text = "Temperature Ranges (Min, Max)"
        options.title = title
        
        // X-Axis configuration
        let xAxis = HIXAxis()
        xAxis.type = "datetime"
        let accessibility = HIAccessibility()
        accessibility.rangeDescription = "Date range of the weather data."
        xAxis.accessibility = accessibility
        options.xAxis = [xAxis]
        
        // Y-Axis configuration
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "Temperature (°F)"
        options.yAxis = [yAxis]
        
        // Tooltip configuration
        let tooltip = HITooltip()
        tooltip.shared = NSNumber(value: true)
        tooltip.valueSuffix = "°F"
        tooltip.xDateFormat = "%A, %b %e"
        options.tooltip = tooltip
        
        // Disable legend
        let legend = HILegend()
        legend.enabled = NSNumber(value: false)
        options.legend = legend
        
        // Series configuration
        let series = HIArearange()
        series.name = "Temperatures"
        series.data = [
            [1668864000000, 52, 62],  // Example data: [timestamp, minTemp, maxTemp]
            [1668950400000, 54, 64],
            [1669036800000, 50, 60]
        ]
        series.color = HIColor()
        options.series = [series]
        
        // Assign options to the chart view
        chartView.options = options
        
        chartView.translatesAutoresizingMaskIntoConstraints = false

        chartSub.addSubview(chartView)

        // Set constraints to make the chartView fit the container view
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: chartSub.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: chartSub.trailingAnchor),
            chartView.topAnchor.constraint(equalTo: chartSub.topAnchor),
            chartView.bottomAnchor.constraint(equalTo: chartSub.bottomAnchor)
        ])
        
        // Add chartView to the view
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
