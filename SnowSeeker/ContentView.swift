//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Alex Bonder on 10/16/23.
//

import SwiftUI

//extension View {
//    @ViewBuilder func phoneOnlyNavigationView() -> some View {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            self.navigationViewStyle(.stack)
//        } else {
//            self
//        }
//    }
//}

enum SortMethod: String, CaseIterable, Identifiable {
    case none, name, country
    var id: Self { self }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @StateObject var favorites = Favorites()
    @State private var searchText = ""
    @State private var sortMethod: SortMethod = .none

    var body: some View {
        NavigationView {
    
                List(filteredResorts) { resort in
                    NavigationLink {
                        ResortView(resort: resort)
                    } label: {
                        HStack {
                            Image(resort.country)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 25)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(resort.name)
                                    .font(.headline)
                                Text("\(resort.runs) runs")
                                    .foregroundStyle(.secondary)
                            }
                            
                            if favorites.contains(resort) {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .accessibilityLabel("This is a favorite resort")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                Menu {
                    Picker("Sort List", selection: $sortMethod) {
                        ForEach(SortMethod.allCases) { method in
                            Text("Sort by \(method.rawValue)")
                        }
                    }
                } label: {
                    Label("Change sort method", systemImage: "arrow.up.arrow.down")
                }
                
            }
            
            WelcomeView()
        }
        .environmentObject(favorites)
//        .phoneOnlyNavigationView()
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return sortedResorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortedResorts: [Resort] {
        switch (sortMethod) {
        case .none:
            return resorts
        case .name:
            return resorts.sorted { lhs, rhs in
                lhs.name < rhs.name
            }
        case .country:
            return resorts.sorted { lhs, rhs in
                lhs.country < rhs.country
            }
        }
    }
}

#Preview {
    ContentView()
}
