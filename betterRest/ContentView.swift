//
//  ContentView.swift
//  betterRest
//
//  Created by Kevin Muniz on 1/10/24.
//

import CoreML
import SwiftUI



struct ContentView: View {
    @State private var wakeup = defaultWakeTime
    @State private var sleepAmount: Double = 8.0
    @State private var cupsOfCoffeeHad = 0
    @State private var alertTitle = ""
    @State private var messageTitle = ""
    
    static private var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please select a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                Section{
                    Text("Coffee amount:")
                        .font(.headline)
                    Picker("^[\(cupsOfCoffeeHad) cup](inflect: true)", selection: $cupsOfCoffeeHad){
                        ForEach(0..<21){ number in
                            Text("\(number)")
                        }
                    }.pickerStyle(.automatic)
                }
                Section {
                    Text("Your suggested sleeptime is: \(calculateSleep().formatted(date: .omitted, time: .shortened))")
                        .font(.title)
                }
            }
            .toolbar {
//                Button("Calculate", action: calculateSleep)
            }
            .navigationTitle("BetterRest")
        }
    }
    func calculateSleep() -> Date {
        do {
            let config = MLModelConfiguration()
            
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
            
            let hour = (components.hour ?? 0) * 60 * 60
            
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: Double(sleepAmount), coffee: Int64(Double(cupsOfCoffeeHad)))
            
            let sleepTime = wakeup - prediction.actualSleep
            
            return sleepTime
            
        } catch {
            alertTitle = "Oops"
            messageTitle = "Sorry, there has been a problem calculating your sleep."
        }
        return wakeup
    }
    
}

#Preview {
    ContentView()
}
