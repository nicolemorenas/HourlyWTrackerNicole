// NICOLE MORENAS 991691178


import WidgetKit
import SwiftUI

//Referenced from ConfigurableWidgetDemo
struct MydataEntry : TimelineEntry {
    
    let date : Date
    let cityName: String
    let temp: String
}


// Provider


struct MyDataProvider : IntentTimelineProvider {
    func getSnapshot(for configuration: MyDataIntent, in context: Context, completion: @escaping @Sendable (MydataEntry) -> Void) {
        
        let cityName = configuration.cityName ?? "CityName"
        
        let entry = MydataEntry(date: Date(), cityName: cityName, temp: "Temp")
  
        completion(entry)
        
    }
    
    func placeholder(in context: Context) -> MydataEntry {
        
        MydataEntry(date: Date(), cityName: "Enter city name", temp: "Temp")
    }
    
    func getTimeline(for configuration: MyDataIntent, in context: Context, completion: @escaping @Sendable (Timeline<MydataEntry>) -> Void) {
        
        let cityName = configuration.cityName ?? "Enter city name"
        let vm = MyViewModel()
        
        
        Task {
            vm.cityName = cityName
            await vm.getWeather()
            
            let temp = vm.hourlyForecast.first?.temp_c ?? 0
            let tempString = "\(temp) C"
            
            let entry = MydataEntry(date: Date(), cityName: cityName, temp: tempString)
            
            //added timeline variable to complete it because return Timeline(entries: [entry], policy: .atEnd) would give me error

            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)

        }
        
        typealias Intent = MyDataIntent

        typealias Entry = MydataEntry


    }
    
    
}

// swiftui view



struct MyDataView : View {
    
    let entry : MydataEntry
    
    
    var body : some View {
        
//        Date format refernced from https://medium.com/@jpmtech/swiftui-format-dates-and-times-the-easy-way-fc896b25003b
        VStack{
            Text(Date.now.formatted(date: .complete, time: .omitted))
                .bold()
                .font(.title3)
            Text(Date.now.formatted(date: .omitted, time: .shortened))

            Text("City: \(entry.cityName)")
            Text("Temp: \(entry.temp)")

            
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
