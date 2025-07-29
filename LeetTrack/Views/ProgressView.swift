//
//  ProgressView.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 30/07/25.
//

import SwiftUI
import Charts

struct ProgressView: View {
    let progress: UserProgress

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Overall Progress")
                    .font(.title2).bold()
                    .padding(.horizontal)

                // Solved by Topic Chart
                CardView(title: "Problems Solved by Topic") {
                    Chart {
                        ForEach(progress.topicProgress.sorted(by: { $0.key < $1.key }), id: \.key) { topic, count in
                            BarMark(
                                x: .value("Topic", topic),
                                y: .value("Solved", count)
                            )
                            .foregroundStyle(.blue)
                        }
                    }
                    .frame(height: 200)
                }

                // Difficulty chart (mocked until difficulty-wise data available)
                CardView(title: "Problems Solved by Difficulty") {
                    Chart {
                        BarMark(x: .value("Difficulty", "Easy"), y: .value("Solved", progress.totalSolved / 2))
                            .foregroundStyle(.green)
                        BarMark(x: .value("Difficulty", "Medium"), y: .value("Solved", progress.totalSolved / 3))
                            .foregroundStyle(.orange)
                        BarMark(x: .value("Difficulty", "Hard"), y: .value("Solved", progress.totalSolved / 6))
                            .foregroundStyle(.red)
                    }
                    .frame(height: 200)
                }

                // Weak Topic Analysis
                VStack(alignment: .leading, spacing: 12) {
                    Text("Weak Topic Analysis")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(progress.topicProgress.sorted(by: { $0.value < $1.value }), id: \.key) { topic, solved in
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(topic)
                                    .font(.subheadline)
                                Text("\(solved)/50 problems solved")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer(minLength: 40)
            }
            .padding(.vertical)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable Card Container
struct CardView<Content: View>: View {
    let title: String
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}

#Preview {
    let dummyProgress = UserProgress(
        totalSolved: 120,
        totalQuestions: 200,
        topicProgress: ["Arrays": 10, "Strings": 5, "Trees": 2, "Graphs": 1, "DP": 15],
        streak: 5
    )
    return ProgressView(progress: dummyProgress)
}

