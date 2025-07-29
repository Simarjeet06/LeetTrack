//
//  DashboardView.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
//
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dashboard")
                .font(.largeTitle)
                .bold()

            Text("Welcome, Simarjeet 👋")
                .font(.title2)
                .bold()

            Text("Recent LeetCode Submissions")
                .font(.subheadline)
                .foregroundColor(.gray)

            if viewModel.recentProblems.isEmpty {
                ProgressView("Fetching problems...")
                    .padding(.top)
            } else {
                List(viewModel.recentProblems) { problem in
                    VStack(alignment: .leading) {
                        Text(problem.title)
                            .font(.headline)
                        Text("Submitted at: \(viewModel.formatDate(from: problem.timestamp))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.fetchProblems()
        }
    }
}
