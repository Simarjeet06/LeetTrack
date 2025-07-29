//
//  ProblemDetailView.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 30/07/25.
import SwiftUI

struct ProblemDetailView: View {
    let problem: Problems

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(problem.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 4)
                    
                    HStack {
                        Label(problem.difficulty.capitalized, systemImage: "speedometer")
                            .foregroundColor(difficultyColor(problem.difficulty))
                            .font(.headline)
                    }

                    HStack {
                        Image(systemName: "tag")
                        Text(problem.topicTags.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .navigationTitle("Problem Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Color based on difficulty
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
}

#Preview {
    ProblemDetailView(problem: Problems(
        id: "1234",
        title: "Two Sum",
        difficulty: "Easy",
        status: "done",
        topicTags: ["Array", "Hash Table"]
    ))
}

