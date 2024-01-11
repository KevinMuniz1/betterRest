//
//  ContentView.swift
//  betterRest
//
//  Created by Kevin Muniz on 1/10/24.
//

import SwiftUI



struct ContentView: View {
    @State private var wakeup = Date.now
    @State private var sleepAmount = 8.0
    @State private var cupsOfCoffeeHad = 0
    var body: some View {
        NavigationStack {
            VStack() {
                Text("When do you want to wake up?")
                    .font(.headline)
                DatePicker("Please select a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                Text("Coffee amount:")
                    .font(.headline)
                Stepper("\(cupsOfCoffeeHad) cups of coffee", value: $cupsOfCoffeeHad, in: 0...20)
            }
            .toolbar {
                Button("Calculate", action: calculateSleep)
            }
            .navigationTitle("BetterRest")
        }.padding()
    }
    func calculateSleep() {
        
    }
}

#Preview {
    ContentView()
}
