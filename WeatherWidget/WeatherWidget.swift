//
//
//

import WidgetKit
import SwiftUI


struct MydataEntry : TimelineEntry {
    
    let date : Date
    let cityName: String
    let hourlyWeather: [WeatherHour]
}


// Provider


struct MyDataProvider : IntentTimelineProvider {
    typealias Intent = MyDataIntent

    typealias Entry = MydataEntry
    
    
    func getSnapshot(for configuration: MyDataIntent, in context: Context, completion: @escaping @Sendable (MydataEntry) -> Void) {
        
        let cityName = configuration.cityName ?? "CityName"
        let entry = MydataEntry(date: Date(), cityName: cityName, hourlyWeather: [])

  
        
        completion(entry)
        
    }
    
    func placeholder(in context: Context) -> MydataEntry {
        
        MydataEntry(date: Date(), cityName: "Enter city name", hourlyWeather: [])
    }
    
    func getTimeline(for configuration: MyDataIntent, in context: Context, completion: @escaping @Sendable (Timeline<MydataEntry>) -> Void) {
        
        let cityName = configuration.cityName ?? "Enter city name"
        
        let entry = MydataEntry(date: Date(), cityName: cityName, hourlyWeather: [])

        
        //added timeline variable to complete it
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        
            //addded
        completion(timeline)

    }
    
    
    
    
    
    
  
 
}

// swiftui view



struct MyDataView : View {
    
    let entry : MydataEntry
    
    
    var body : some View {
        
        VStack{
            
            Text("Hi \(entry.cityName)")
        }
    }
    
}

//widget
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MyDataIntent.self, provider: MyDataProvider()) { entry in
            if #available(iOS 17.0, *) {
               MyDataView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MyDataView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
