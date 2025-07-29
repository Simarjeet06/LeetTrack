//
//  LeetCodeService.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 04/05/25.
//



//class LeetCodeService {
//    
//    func fetchRecentProblems(completion: @escaping ([Problem]) -> Void) {
//        // Simulated API delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            let problems = [
//                Problem(title: "Two Sum", isSolved: true),
//                Problem(title: "Valid Parentheses", isSolved: false),
//                Problem(title: "Merge Intervals", isSolved: true)
//            ]
//            completion(problems)
//        }
//    }
//    
//    func fetchProblemsSolvedToday(completion: @escaping (Int, Int) -> Void) {
//        // Simulating current progress
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            completion(3, 5) // 3 out of 5 solved
//        }
//    }
import Foundation

class LeetCodeService {
    static let shared = LeetCodeService()
    private init() {}
    
    func fetchRecentProblems(for username: String, completion: @escaping ([Submission]) -> Void) {
        let url = URL(string: "https://leetcode.com/graphql/")!
        
        let query = """
        query {
          recentSubmissionList(username: "\(username)") {
            title
            timestamp
            status
          }
        }
        """


        let json: [String: Any] = ["query": query]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
                do {
                    let decoded = try JSONDecoder().decode(GraphQLResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded.data.recentSubmissionList)
                      

                    }
                } catch {
                    print("Decoding error:", error)
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            } else {
                print("Fetch error:", error ?? "Unknown error")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}

