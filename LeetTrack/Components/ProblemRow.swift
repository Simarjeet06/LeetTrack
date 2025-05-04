//
//  ProblemRow.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
import SwiftUI

struct ProblemRow: View {
    let problem: Problem

    var body: some View {
        HStack {
            Image(systemName: problem.isSolved ? "checkmark.seal.fill" : "xmark.seal.fill")
                .foregroundColor(problem.isSolved ? .green : .red)
            Text(problem.title)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

