// NICOLE MORENAS 991691178

//Referenced from WebServiceExample
import Foundation

struct WeatherResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let hour: [WeatherHour]
}

struct WeatherHour: Codable {
    let time: String
    let temp_c: Double
    let condition: WeatherCondition
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}

class MyViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var hourlyForecast: [WeatherHour] = []
    @Published var errorMessage: String? = ""
    private let apiKey = "3a4add48c41f4dea80e40810241211"
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"


    func getWeather() async {
            guard !cityName.isEmpty else {
                errorMessage = "Please enter a city name."
                return
            }
            
            guard let url = URL(string: "\(baseURL)?key=\(apiKey)&q=\(cityName)&hours=7&days=1") else {
                errorMessage = "Invalid city name"
                return
            }

            do {
                //Referenced from https://www.avanderlee.com/concurrency/urlsession-async-await-network-requests-in-swift/
                let (data, response) = try await URLSession.shared.data(from: url)
                let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                //Referenced from https://stackoverflow.com/questions/28527797/how-to-return-first-5-objects-of-array-in-swift
                if let firstForecastDay = decodedResponse.forecast.forecastday.first {
                    self.hourlyForecast = Array(firstForecastDay.hour.prefix(7))
                } else {
                    self.errorMessage = "Error"
                }
            } catch {
                self.errorMessage = "Error"
            }
        }
    }
