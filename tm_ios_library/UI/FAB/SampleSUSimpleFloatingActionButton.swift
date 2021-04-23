//
//  SampleSUSimpleFloatingActionButton.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/04/18.
//

import SwiftUI

struct SampleSUSimpleFloatingActionButton: View {
    
    @State var text = "Hello, World!"
    
    var body: some View {
        VStack {
            Button("", action: {
                
            })
            .frame(width: 44, height: 44, alignment: .center)
            .background(Color(hex: "ED6317"))
            .cornerRadius(22)
            .shadow(color: Color(.sRGBLinear, red: 0, green: 0, blue: 0, opacity: 0.6), radius: 3, x: 0.0, y: 2.0)
        }
    }
}

struct SampleSUSimpleFloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        SampleSUSimpleFloatingActionButton()
    }
}
