//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Alex Bonder on 10/16/23.
//

import SwiftUI

struct UserView: View {
    var body: some View {
        Group {
            Text("Name: Alex")
            Text("Country: USA")
            Text("Pets: Crystal")
        }
        .font(.title)
    }
}

struct ContentView: View {
    @State private var searchText = ""
    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]
    
    var body: some View {
        NavigationView {
            List(filteredNames, id: \.self) { name in
                Text(name)
            }
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Searching")
        }
    }
    
    var filteredNames: [String] {
        if searchText.isEmpty {
            return allNames
        } else {
            return allNames.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

#Preview {
    ContentView()
}
