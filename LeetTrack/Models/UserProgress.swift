//
//  UserProgress.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 29/07/25.
//

import Foundation


struct UserProgress: Codable {
    let totalSolved: Int
    let totalQuestions: Int
    let topicProgress: [String: Int]
    var streak: Int
}
