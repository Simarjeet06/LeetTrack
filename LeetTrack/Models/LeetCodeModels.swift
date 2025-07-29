//
//  LeetCodeModels.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
//



//// MARK: - Submission Model
//struct Submission: Codable, Identifiable,Decodable {
//    var id: String { title + timestamp }
//    let title: String
//    let status: String
//    let timestamp: String
//}
//
//// MARK: - Top-Level GraphQL Response
//struct LeetCodeResponse: Codable {
//    let data: LeetCodeData
//}
//
//struct LeetCodeData: Codable {
//    let matchedUser: MatchedUser
// }
//
//struct MatchedUser: Codable {
//    let recentSubmissionList: [Submission]
//}
import Foundation

struct GraphQLResponse: Decodable {
    let data: SubmissionData
}

struct SubmissionData: Decodable {
    let recentSubmissionList: [Submission]
}

    
    struct Submission: Identifiable, Decodable {
        let title: String
        let timestamp: String
        let status: Int
        var id: UUID { UUID() } // computed property, not decoded
    }

