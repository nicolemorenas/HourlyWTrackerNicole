// NICOLE MORENAS 991691178


import SwiftUI

//Referenced from WebServiceExample and MapKitExample2
struct ContentView: View {
    
    @StateObject private var vm = MyViewModel()

    var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    TextField("Enter city name", text: $vm.cityName)
                        .frame(width: 300, height: 50)
                        .border(.blue, width: 4)

                    Button(action: {
                        Task {
                            await vm.getWeather()
                        }
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    if let errorMessage = vm.errorMessage {
                        Text(errorMessage)
                            .padding()
                    }

                    //Referenced from https://medium.com/@vcorva/getting-the-index-number-of-an-item-in-an-array-of-identifiable-380041750c3b
                    List(vm.hourlyForecast.indices, id: \.self) { index in
                        let hour = vm.hourlyForecast[index]
                        HStack {
                            Text(hour.time)
                                .fontWeight(.bold)
                                
                            //Referenced https://developer.apple.com/documentation/swiftui/asyncimage
                            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                                image.resizable()
                                 
                                    
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)

                            Spacer()

                            Text("\(hour.temp_c, specifier: "%.1f")°C")
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding()
                .navigationTitle("Weather Forecast")
            }
        }
    }
