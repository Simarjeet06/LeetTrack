//
//  MLRecommendationService.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 29/07/25.
//


import Foundation

class MLRecommendationService {
    static let shared = MLRecommendationService()

    func recommendNextProblem(userProgress: UserProgress?, problems: [Problems]) -> Problems? {
        guard let _ = userProgress else {
            print("Error: User progress data is nil.")
            return nil
        }

        let unsolved = problems.filter { problem in
            guard let status = problem.status?.lowercased() else { return true }
            return !(status.contains("solved") || status == "ac")
        }

        let sorted = unsolved.sorted { lhs, rhs in
            let order: [String: Int] = ["easy": 0, "medium": 1, "hard": 2]
            return (order[lhs.difficulty.lowercased()] ?? 3) < (order[rhs.difficulty.lowercased()] ?? 3)
        }

        return sorted.first
    }
}
