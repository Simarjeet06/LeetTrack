//
//  Problems.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 29/07/25.
//

import Foundation


struct Problems: Identifiable, Codable,Equatable {
    let id: String
    let title: String
    let difficulty: String
    let status: String?
    let topicTags: [String]
}
