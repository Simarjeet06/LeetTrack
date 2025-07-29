//
//  DashboardViewModel.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
//
//
/*
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
//import Foundation
//import SwiftUI
//
//struct StatsResponse: Decodable {
//    struct DataFields: Decodable {
//        struct AllQuestionsCount: Decodable {
//            let difficulty: String
//            let count: Int
//        }
//        struct MatchedUser: Decodable {
//            struct SubmitStats: Decodable {
//                struct AC: Decodable {
//                    let difficulty: String
//                    let count: Int
//                }
//                let acSubmissionNum: [AC]
//            }
//            let submitStatsGlobal: SubmitStats?
//        }
//        let allQuestionsCount: [AllQuestionsCount]
//        let matchedUser: MatchedUser
//    }
//    let data: DataFields
//}
//
//class DashboardViewModel: ObservableObject {
//    @Published var easyProgress: Double = 0.0
//    @Published var mediumProgress: Double = 0.0
//    @Published var hardProgress: Double = 0.0
//
//    @Published var totalSolved: Int = 0
//    @Published var totalAvailable: Int = 0
//
//    func fetchProgress(for username: String = "placeholder") {
//        let query = """
//        query userProblemsSolved($username: String!) {
//          allQuestionsCount { difficulty count }
//          matchedUser(username: $username) {
//            submitStatsGlobal { acSubmissionNum { difficulty count } }
//          }
//        }
//        """
//        let vars = ["username": username]
//        let body: [String: Any] = ["query": query, "variables": vars]
//
//        let url = URL(string: "https://leetcode.com/graphql/")!
//        var req = URLRequest(url: url)
//        req.httpMethod = "POST"
//        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        req.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        URLSession.shared.dataTask(with: req) { data, _, error in
//            guard let data = data,
//                  let resp = try? JSONDecoder().decode(StatsResponse.self, from: data),
//                  let submit = resp.data.matchedUser.submitStatsGlobal
//            else {
//                print("Error", error ?? "")
//                return
//            }
//
//            DispatchQueue.main.async {
//                let totalStats = resp.data.allQuestionsCount
//                let solvedStats = submit.acSubmissionNum
//
//                self.totalAvailable = totalStats.first(where: { $0.difficulty == "All" })?.count ?? 0
//                self.totalSolved = solvedStats.first(where: { $0.difficulty == "All" })?.count ?? 0
//
//                self.easyProgress = {
//                    let solved = solvedStats.first(where: { $0.difficulty == "Easy" })?.count ?? 0
//                    let total = totalStats.first(where: { $0.difficulty == "Easy" })?.count ?? 1
//                    return Double(solved) / Double(total)
//                }()
//                self.mediumProgress = {
//                    let solved = solvedStats.first(where: { $0.difficulty == "Medium" })?.count ?? 0
//                    let total = totalStats.first(where: { $0.difficulty == "Medium" })?.count ?? 1
//                    return Double(solved) / Double(total)
//                }()
//                self.hardProgress = {
//                    let solved = solvedStats.first(where: { $0.difficulty == "Hard" })?.count ?? 0
//                    let total = totalStats.first(where: { $0.difficulty == "Hard" })?.count ?? 1
//                    return Double(solved) / Double(total)
//                }()
//            }
//        }.resume()
//    }
//}
*/
import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var userProgress: UserProgress?
    @Published var recentlySolved: [Problems] = []
    @Published var recommendedProblem: Problems?
    @Published var errorMessage: String?
    
    private let username: String
    private var cancellables = Set<AnyCancellable>()
    
    init(username: String) {
        self.username = username
        loadData()
    }
    
    func loadData() {
        fetchUserProgress()
        fetchRecentlySolved()
        fetchRecommendedProblem()
    }
    
    private func fetchUserProgress() {
        LeetCodeAPIService.shared.fetchUserProgress(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let progress):
                    self?.userProgress = progress
                case .failure(let error):
                    self?.errorMessage = "User progress error: \(error)"
                }
            }
        }
    }

    private func fetchRecentlySolved() {
        LeetCodeAPIService.shared.fetchRecentlySolved(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let problems):
                    self?.recentlySolved = problems
                case .failure(let error):
                    self?.errorMessage = "Recent problems error: \(error)"
                }
            }
        }
    }
    
    private func fetchRecommendedProblem() {
        // Prefer ML Recommendation if available
        if let mlRecommended = MLRecommendationService.shared.recommendNextProblem(userProgress: userProgress, problems: recentlySolved) {
            self.recommendedProblem = mlRecommended
        } else {
            LeetCodeAPIService.shared.fetchRecommendedProblem { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let problem):
                        self?.recommendedProblem = problem
                    case .failure(let error):
                        self?.errorMessage = "Recommended problem error: \(error)"
                    }
                }
            }
        }
    }
}




