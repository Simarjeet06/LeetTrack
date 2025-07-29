//
//  ContentView.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var dashboardVM = DashboardViewModel(username: "Simarjeet_06")
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            if let userProgress = dashboardVM.userProgress {
                ProgressView(progress: userProgress)
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
            } else {
                // Placeholder while loading
                Text("Loading...")
                    .tabItem {
                        Label("Progress", systemImage: "chart.bar.fill")
                    }
            }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        
    }
}

#Preview {
    ContentView()
}


