//
//  ContentView.swift
//  tm_ios_ui_library
//
//  Created by Tatsunori on 2021/02/15.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherVewModel
    
    var body: some View {
        VStack {
            Text(viewModel.cityName)
                .font(.largeTitle)
                .padding()
            Text(viewModel.temperature)
                .font(.system(size: 70))
                .bold()
            Text(viewModel.weatherIcon)
                .font(.largeTitle)
                .padding()
            Text(viewModel.weatherDescription)
        }.onAppear(perform: viewModel.refresh)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherVewModel(weatherService: WeatherService()))
    }
}
