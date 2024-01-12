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
    @State private var showAlert = false
    
    static private var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 10) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please select a time", selection: $wakeup, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 10){
                    Text("Coffee amount:")
                        .font(.headline)
                    Stepper("^[\(cupsOfCoffeeHad) cup](inflect: true) of coffee",value: $cupsOfCoffeeHad ,in: 0...20)
                }
            }
            .toolbar {
                Button("Calculate", action: calculateSleep)
            }
            .navigationTitle("BetterRest")
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ok"){}
        }message: {
            Text(messageTitle)
        }
    }
    func calculateSleep() {
        do {
            let config = MLModelConfiguration()
            
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeup)
            
            let hour = (components.hour ?? 0) * 60 * 60
            
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: Double(sleepAmount), coffee: Int64(Double(cupsOfCoffeeHad)))
            
            let sleepTime = wakeup - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            messageTitle = "\(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            alertTitle = "Oops"
            messageTitle = "Sorry, there has been a problem calculating your sleep."
        }
        
        showAlert = true
    }
}

#Preview {
    ContentView()
}
