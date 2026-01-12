//
//  HomeView.swift
//  Host
//
//  Created by Justin Dayane  Gbadamassi on 11/18/25.
//

import SwiftUI

struct LargeCard: View {
    let title: String
    let imageName: String
    let description: String
    
    var body: some View {
        VStack {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .foregroundStyle(.tint)
                Text(title)
                    .padding(1)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .font(.title)
                    .foregroundStyle(.white)
                    .bold()
                    .offset(x: 0, y: 70)
                
                Text(description)
                    .padding(1)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .offset(x: 0, y: 95)
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 8)
        }
    }
}

struct SmallCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(height: 100)
                .cornerRadius(20)
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color(.systemOrange))
                .lineLimit(2)
            Text("More details would go here if needed...")
                .font(.footnote)
                .foregroundColor(Color(.black))
        }
        .padding()
        .background(Gradient(colors: [Color(.systemBackground), Color(.cyan).opacity(0.50)]))
//        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}


struct HomeView: View {
    let columns = [GridItem(.adaptive(minimum: 200, maximum: 350)), GridItem(.adaptive(minimum: 200, maximum: 350))]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    NavigationLink(destination: MenuView()) {
                        LargeCard(title: "Food", imageName: "food",description: "This is where all the food resides")
                    }

                    HStack {
                        LazyVGrid(columns: columns) {
                            NavigationLink(destination: Text("TBD: To Be Developed")) {
                                SmallCard(title: "Units", imageName: "machinev")
                            }
                            NavigationLink(destination: TraysListView()) {
                                SmallCard(title: "Trays (working)", imageName: "tray")
                            }
                        }
                    }
                    NavigationLink(destination: TodayMealsView()) {
                        LargeCard(title: "Specials", imageName: "units",description: "Daily list of specials")
                    }
                    HStack {
                        LazyVGrid(columns: columns) {
                            NavigationLink(destination: Text("TBD: To Be Developed")) {
                                SmallCard(title: "Units", imageName: "fruits")
                            }
                            NavigationLink(destination: Text("TBD: To Be Developed")) {
                                SmallCard(title: "Units", imageName: "veggie")
                            }
                            NavigationLink(destination: Text("TBD: To Be Developed")) {
                                SmallCard(title: "Units", imageName: "drinks")
                            }
                            NavigationLink(destination: MenuBrowserView()) {
                                SmallCard(title: "Menu New", imageName: "meal")
                            }
                        }
                        }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
