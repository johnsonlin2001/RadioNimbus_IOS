//
//  weatherDataTabController.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/12/6.
//

import UIKit
import Highcharts

class weatherDataTabController: UIViewController {
    
    var currentPrec: Int?
    var currentHum: Int?
    var currentCloudCover: Int?
    
    
    @IBOutlet weak var precLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var ccLabel: UILabel!
    
    @IBOutlet weak var chartSub: UIView!
    
    override func viewDidLoad() {
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
        let chartView = HIChartView(frame: chartSub.bounds)
        chartView.plugins = ["solid-gauge"]

        let options = HIOptions()

        let chart = HIChart()
        chart.type = "solidgauge"
        chart.height = "110%"
        options.chart = chart

        let title = HITitle()
        title.text = "Weather Data"
        title.style = HICSSObject()
        title.style.fontSize = "24px"
        options.title = title

        let tooltip = HITooltip()
        tooltip.borderWidth = 0
        tooltip.shadow = HIShadowOptionsObject()
        tooltip.shadow.opacity = 0
        tooltip.style = HICSSObject()
        tooltip.style.fontSize = "16px"
        tooltip.valueSuffix = "%"
        tooltip.pointFormat = "{series.name}<br><span style=\"font-size:2em; color: {point.color}; font-weight: bold\">{point.y}</span>"
        tooltip.positioner = HIFunction(jsFunction: "function (labelWidth) { return { x: (this.chart.chartWidth - labelWidth) / 2, y: (this.chart.plotHeight / 2) + 15 }; }")
        options.tooltip = tooltip

        let pane = HIPane()
        pane.startAngle = 0
        pane.endAngle = 360

        let background1 = HIBackground()
        background1.backgroundColor = HIColor(rgba: 82, green: 204, blue: 15, alpha: 0.35)
        background1.outerRadius = "112%"
        background1.innerRadius = "88%"
        background1.borderWidth = 0

        let background2 = HIBackground()
        background2.backgroundColor = HIColor(rgba: 76, green: 202, blue: 249, alpha: 0.35)
        background2.outerRadius = "87%"
        background2.innerRadius = "63%"
        background2.borderWidth = 0

        let background3 = HIBackground()
        background3.backgroundColor = HIColor(rgba: 242, green: 24, blue: 66, alpha: 0.35)
        background3.outerRadius = "62%"
        background3.innerRadius = "38%"
        background3.borderWidth = 0

        pane.background = [
            background1, background2, background3
        ]

        options.pane = [pane]

        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.max = 100
        yAxis.lineWidth = 0 // Removes the gauge line
        yAxis.tickWidth = 0 // Removes major ticks
        yAxis.minorTicks = false // Removes minor ticks
        yAxis.gridLineWidth = 0 // Removes grid lines
        yAxis.tickPositions = [] // No ticks at all
        yAxis.labels = HILabels()
        yAxis.labels.enabled = false // Removes the labels
        options.yAxis = [yAxis]

        let plotOptions = HIPlotOptions()
        plotOptions.solidgauge = HISolidgauge()
        let dataLabels = HIDataLabels()
        dataLabels.enabled = false
        plotOptions.solidgauge.dataLabels = [dataLabels]
        plotOptions.solidgauge.linecap = "round"
        plotOptions.solidgauge.stickyTracking = false
        plotOptions.solidgauge.rounded = true
        options.plotOptions = plotOptions

        // Correctly configure each series with its own data
        let cloudCover = HISolidgauge()
        cloudCover.name = "Cloud Cover"
        let cloudData = HIData()
        cloudData.color = HIColor(rgba: 82, green: 204, blue: 15, alpha: 1)
        cloudData.radius = "112%"
        cloudData.innerRadius = "88%"
        cloudData.y = self.currentCloudCover as? NSNumber
        cloudCover.data = [cloudData]

        let prec = HISolidgauge()
        prec.name = "Precipitation"
        let precData = HIData()
        precData.color = HIColor(rgba: 76, green: 202, blue: 249, alpha: 1)
        precData.radius = "87%"
        precData.innerRadius = "63%"
        precData.y = self.currentPrec as? NSNumber
        prec.data = [precData]

        let humidity = HISolidgauge()
        humidity.name = "Humidity"
        let humidityData = HIData()
        humidityData.color = HIColor(rgba: 242, green: 24, blue: 66, alpha: 1)
        humidityData.radius = "62%"
        humidityData.innerRadius = "38%"
        humidityData.y = self.currentHum as? NSNumber
        humidity.data = [humidityData]

        options.series = [cloudCover, prec, humidity]

        chartView.options = options

        chartSub.addSubview(chartView)
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
