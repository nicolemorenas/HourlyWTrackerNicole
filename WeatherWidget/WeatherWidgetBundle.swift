//
//  WeatherWidgetBundle.swift
//  WeatherWidget
//
//  Created by Nicole Morenas on 2024-11-20.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        WeatherWidgetControl()
        WeatherWidgetLiveActivity()
    }
}
