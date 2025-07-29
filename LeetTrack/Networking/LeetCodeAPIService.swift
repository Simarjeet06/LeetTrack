//
//  LeetCodeAPIService.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 29/07/25.
//
import Foundation

enum LeetCodeAPIError: Error {
    case invalidResponse
    case networkError(Error)
    case parsingError
    case unknown
}

class LeetCodeAPIService {
    static let shared = LeetCodeAPIService()
    
    private let endpoint = URL(string: "https://leetcode.com/graphql")!
    private var sessionCookie: String?
    
    // In-memory cache
    private let cache = NSCache<NSString, AnyObject>()
    
    func setSessionCookie(_ cookie: String) {
        self.sessionCookie = cookie
    }

    // MARK: - User Progress
    func fetchUserProgress(username: String, completion: @escaping (Result<UserProgress, LeetCodeAPIError>) -> Void) {
        if let cached = cache.object(forKey: "UserProgress-\(username)" as NSString) as? UserProgress {
            return completion(.success(cached))
        }

        let query = """
        query getUserProfile($username: String!) {
          matchedUser(username: $username) {
            submitStatsGlobal {
              acSubmissionNum {
                difficulty
                count
                submissions
              }
            }
          }
        }
        """
        let variables = ["username": username]

        performGraphQLRequest(query: query, variables: variables) { result in
            switch result {
            case .success(let json):
                guard
                    let dict = json as? [String: Any],
                    let dataDict = dict["data"] as? [String: Any],
                    let matchedUser = dataDict["matchedUser"] as? [String: Any],
                    let stats = matchedUser["submitStatsGlobal"] as? [String: Any],
                    let acList = stats["acSubmissionNum"] as? [[String: Any]]
                else {
                    return completion(.failure(.parsingError))
                }

                var totalSolved = 0
                var totalQuestions = 0
                var topicProgress: [String: Int] = [:]

                for item in acList {
                    if let difficulty = item["difficulty"] as? String,
                       let count = item["count"] as? Int {
                        if difficulty == "All" {
                            totalSolved = count
                        } else {
                            topicProgress[difficulty] = count
                        }
                    }
                    if let submissions = item["submissions"] as? Int, item["difficulty"] as? String == "All" {
                        totalQuestions = submissions
                    }
                }

                let progress = UserProgress(
                    totalSolved: totalSolved,
                    totalQuestions: totalQuestions,
                    topicProgress: topicProgress,
                    streak: 0
                )

                self.cache.setObject(progress as AnyObject, forKey: "UserProgress-\(username)" as NSString)
                completion(.success(progress))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Recently Solved
    func fetchRecentlySolved(username: String, completion: @escaping (Result<[Problems], LeetCodeAPIError>) -> Void) {
        if let cached = cache.object(forKey: "RecentlySolved-\(username)" as NSString) as? [Problems] {
            return completion(.success(cached))
        }

        let query = """
        query recentAcSubmissions($username: String!) {
          recentAcSubmissionList(username: $username, limit: 10) {
            id
            title
            titleSlug
            timestamp
          }
        }
        """
        let variables = ["username": username]

         performGraphQLRequest(query: query, variables: variables) {result in
            switch result {
            case .success(let json):
                guard
                    let dict = json as? [String: Any],
                    let dataDict = dict["data"] as? [String: Any],
                    let recentList = dataDict["recentAcSubmissionList"] as? [[String: Any]]
                else {
                    return completion(.failure(.parsingError))
                }

                let problems: [Problems] = recentList.compactMap { item in
                    guard let id = item["id"] as? String,
                          let title = item["title"] as? String else { return nil }
                    return Problems(id: id, title: title, difficulty: "", status: nil, topicTags: [])
                }

                self.cache.setObject(problems as AnyObject, forKey: "RecentlySolved-\(username)" as NSString)
                completion(.success(problems))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Recommended Problem
    func fetchRecommendedProblem(completion: @escaping (Result<Problems, LeetCodeAPIError>) -> Void) {
        if let cached = cache.object(forKey: "RecommendedProblem" as NSString) as? Problems {
            return completion(.success(cached))
        }

        let query = """
        query questionOfToday {
          activeDailyCodingChallengeQuestion {
            question {
              questionId
              title
              titleSlug
              difficulty
              topicTags { name }
            }
          }
        }
        """
        performGraphQLRequest(query: query, variables: [:]) { result in
            switch result {
            case .success(let json):
                guard
                    let dict = json as? [String: Any],
                    let dataDict = dict["data"] as? [String: Any],
                    let active = dataDict["activeDailyCodingChallengeQuestion"] as? [String: Any],
                    let question = active["question"] as? [String: Any],
                    let id = question["questionId"] as? String,
                    let title = question["title"] as? String,
                    let difficulty = question["difficulty"] as? String,
                    let topicTagsArr = question["topicTags"] as? [[String: Any]]
                else {
                    return completion(.failure(.parsingError))
                }

                let topicTags = topicTagsArr.compactMap { $0["name"] as? String }
                let problem = Problems(id: id, title: title, difficulty: difficulty, status: nil, topicTags: topicTags)

                self.cache.setObject(problem as AnyObject, forKey: "RecommendedProblem" as NSString)
                completion(.success(problem))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Full Problem List
    func fetchProblems(completion: @escaping (Result<[Problems], LeetCodeAPIError>) -> Void) {
        if let cached = cache.object(forKey: "AllProblems" as NSString) as? [Problems] {
            return completion(.success(cached))
        }

        let query = """
        query problemsetQuestionListV2($categorySlug: String, $limit: Int, $skip: Int, $filters: QuestionListFilterInput) {
          problemsetQuestionListV2(
            categorySlug: $categorySlug,
            limit: $limit,
            skip: $skip,
            filters: $filters
          ) {
            total
            questions {
              questionId
              title
              titleSlug
              difficulty
              status
              topicTags { name }
            }
          }
        }
        """
        let variables: [String: Any] = [
            "categorySlug": "all-code-essentials",
            "limit": 50,
            "skip": 0,
            "filters": [:]
        ]

        performGraphQLRequest(query: query, variables: variables) { result in
            switch result {
            case .success(let json):
                guard
                    let dict = json as? [String: Any],
                    let dataDict = dict["data"] as? [String: Any],
                    let problemset = dataDict["problemsetQuestionListV2"] as? [String: Any],
                    let questions = problemset["questions"] as? [[String: Any]]
                else {
                    return completion(.failure(.parsingError))
                }

                let problems: [Problems] = questions.compactMap { item in
                    guard let id = item["questionId"] as? String,
                          let title = item["title"] as? String,
                          let difficulty = item["difficulty"] as? String,
                          let topicTagsArr = item["topicTags"] as? [[String: Any]] else { return nil }

                    let status = item["status"] as? String
                    let topicTags = topicTagsArr.compactMap { $0["name"] as? String }

                    return Problems(id: id, title: title, difficulty: difficulty, status: status, topicTags: topicTags)
                }

                self.cache.setObject(problems as AnyObject, forKey: "AllProblems" as NSString)
                completion(.success(problems))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Networking Core
    private func performGraphQLRequest(query: String, variables: [String: Any], completion: @escaping (Result<Any, LeetCodeAPIError>) -> Void) {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let cookie = sessionCookie {
            request.setValue("LEETCODE_SESSION=\(cookie)", forHTTPHeaderField: "Cookie")
        }

        let body: [String: Any] = [
            "query": query,
            "variables": variables
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("[ERROR] Network error: \(error)")
                return completion(.failure(.networkError(error)))
            }

            guard let data = data else {
                print("[ERROR] No data returned")
                return completion(.failure(.invalidResponse))
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) else {
                print("[ERROR] Failed to decode JSON")
                return completion(.failure(.parsingError))
            }

            completion(.success(json))
        }

        task.resume()
    }
}

