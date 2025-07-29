//
//  ProfileView.swift
//  LeetTrack
//
//  Created by Simarjeet Kaur on 30/07/25.
//
//import SwiftUI
//
//struct ProfileView: View {
//    let name = "Simarjeet Kaur"
//    let username = "Simarjeet_06"
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "person.crop.circle.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
//                .foregroundColor(.blue)
//                .padding(.top, 40)
//
//            Text(name)
//                .font(.title2)
//                .fontWeight(.bold)
//
//            Text("@\(username)")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            Spacer()
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .navigationTitle("Profile")
//    }
//}
import SwiftUI

struct ProfileView: View {
   
    
    var name: String = "Simarjeet Kaur"
    var username: String = "Simarjeet_06"
    var email: String = "simarjeetkaur6603@gmail.com"
    var bio: String = "Passionate iOS Developer 💻 | Problem Solver"
    var joinedDate: String = "Joined year :  2022"
    var problemsSolved: Int = 229
    var currentStreak: Int = 7
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .padding(.top)
                
                // Name and Username
                VStack(spacing: 4) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(username)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Bio
                Text(bio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Email & Joined
                VStack(spacing: 4) {
                    Text(email)
                        .font(.footnote)
                    Text(joinedDate)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Stats
                HStack(spacing: 40) {
                    VStack {
                        Text("\(problemsSolved)")
                            .font(.title)
                            .bold()
                        Text("Solved")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    VStack {
                        Text("\(currentStreak)")
                            .font(.title)
                            .bold()
                        Text("Day Streak")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        // Edit profile action
                    }) {
                        Text("Edit Profile")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                    }

                    Button(action: {
                        // Logout action
                    }) {
                        Text("Log Out")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.red)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
}



#Preview {
    ProfileView()
}
