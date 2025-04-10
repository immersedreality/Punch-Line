//
//  JokeLookupView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/9/25.
//

import SwiftUI

struct JokeLookupView: View {

    @State private var showingModalSheet = false
    @State private var searchText: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.generateRandomBackgroundColor()
                    .ignoresSafeArea(edges: [.top])
                Text("There is currently nothing funny for me to show you. - Jeff")
                    .font(Font.system(size: 24.0, weight: .bold))
                    .foregroundStyle(.accent)
                    .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                    .padding([.horizontal], 16.0)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image(ImageTitles.iconNavigationTitle)
                                .foregroundStyle(.accent)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Image(systemName: SystemIcons.settingsButton)
                                .foregroundStyle(.accent)
                                .onTapGesture {
                                    showingModalSheet = true
                                }
                                .sheet(isPresented: $showingModalSheet) {
                                    SettingsView()
                                        .presentationDragIndicator(.visible)
                                }
                        }
                    }
                    .navigationTitle(NavigationTitles.jokeLookup)
                    .listRowSpacing(8.0)
                    .scrollContentBackground(.hidden)
            }
        }
        .searchable(text: $searchText)
    }

}

#Preview {
    JokeLookupView()
}
