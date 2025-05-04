//
//  DashboardViewModel.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
//

import Foundation

class DashboardViewModel: ObservableObject {
    @Published var recentProblems: [Submission] = []

    func fetchProblems() {
        LeetCodeService.shared.fetchRecentProblems(for: "Simarjeet_06") { problems in
            self.recentProblems = problems
        }
    }

    // Helper to format timestamp
    func formatDate(from timestamp: String) -> String {
        guard let timeInterval = TimeInterval(timestamp) else { return "N/A" }
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}



