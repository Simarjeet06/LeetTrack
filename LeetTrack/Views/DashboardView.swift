
import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel(username: "Simarjeet_06")
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    
                    recommendedCard
                    
                    HStack {
                        progressCard(title: "Overall Progress", value: progressPercent)
                        progressCard(title: "Solved", value: solvedCount)
                    }
                    
                    HStack {
                        Text("Streak")
                        Spacer()
                        Text("7 days") // You can calculate streak from UserProgress if needed
                    }
                    .padding(.horizontal)
                    .foregroundColor(.gray)
                    
                    recentlySolvedSection
                }
                .padding()
            }
            .navigationBarTitle("Dashboard", displayMode: .inline)
        }
    }

    private var profileHeader: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill") // Replace with avatar if needed
                .resizable()
                .frame(width: 40, height: 40)
            Text("Dashboard")
                .font(.title2)
                .bold()
            Spacer()
            Image(systemName: "gear")
        }
    }
    
    private var recommendedCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Next Best Problem")
                .font(.headline)
            Text("Based on your progress, we recommend this problem to enhance your skills.")
                .font(.subheadline)
            if let problem = viewModel.recommendedProblem {
                NavigationLink("Start", destination: ProblemDetailView(problem: problem))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                ProgressView(progress: viewModel.userProgress ?? UserProgress(totalSolved: 229, totalQuestions: 555, topicProgress: [:], streak: 7))
            }
        }
        .padding()
        .background(LinearGradient(colors: [.orange, .brown], startPoint: .top, endPoint: .bottom))
        .cornerRadius(16)
    }
    
    private func progressCard(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var recentlySolvedSection: some View {
        VStack(alignment: .leading) {
            Text("Recently Solved")
                .font(.headline)
                .padding(.bottom, 4)
            
            ForEach(viewModel.recentlySolved.prefix(5), id: \.id) { problem in
                NavigationLink(destination: ProblemDetailView(problem: problem)) {
                    HStack {
                        Text(problem.title)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.vertical, 6)
                }
                Divider()
            }
        }
    }

    private var progressPercent: String {
        guard let progress = viewModel.userProgress else { return "0%" }
        let percent = Double(progress.totalSolved) / Double(progress.totalQuestions) * 100
        return String(format: "%.0f%%", percent)
    }
    
    private var solvedCount: String {
        guard let progress = viewModel.userProgress else { return "0/0" }
        return "\(progress.totalSolved)/\(progress.totalQuestions)"
    }
}


#Preview {
    DashboardView()
}

//
