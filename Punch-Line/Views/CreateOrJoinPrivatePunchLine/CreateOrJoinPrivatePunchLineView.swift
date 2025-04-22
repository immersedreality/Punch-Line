//
//  CreateOrJoinPrivatePunchLineView.swift
//  Punch-Line
//
//  Created by Jeffrey Eugene Hoch on 4/21/25.
//

import SwiftUI

struct CreateOrJoinPrivatePunchLineView: View {

    @StateObject var viewModel: CreateOrJoinPrivatePunchLineViewModel

    @FocusState private var textFieldIsFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                StyleManager.createOrJoinBackgroundColor
                    .ignoresSafeArea(edges: [.bottom])
                VStack {
                    HStack {
                        Text(viewModel.displayText)
                            .font(Font.system(size: 32.0, weight: .semibold))
                            .foregroundStyle(.accent)
                            .shadow(color: .black, radius: 0.1, x: 0.1, y: 0.1)
                            .padding([.top], 48.0)
                        Spacer()
                    }
                    TextField("", text: $viewModel.enteredText)
                        .textFieldStyle(.roundedBorder)
                        .font(Font.system(size: 20.0, weight: .light))
                        .focused($textFieldIsFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            if viewModel.textEntryIsValid() {
                                switch viewModel.mode {
                                case .create:
                                    viewModel.createPrivatePunchLine()
                                case .join:
                                    viewModel.joinPrivatePunchLine()
                                }
                            }

                        }
                    Button {
                        if viewModel.textEntryIsValid() {
                            switch viewModel.mode {
                            case .create:
                                viewModel.createPrivatePunchLine()
                            case .join:
                                viewModel.joinPrivatePunchLine()
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Done")
                                .padding([.vertical], 8.0)
                            Spacer()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.white)
                    .backgroundStyle(.accent)
                    .disabled(!viewModel.textEntryIsValid())
                    Spacer()
                }
                .padding([.horizontal], 16.0)
                .onAppear {
                    textFieldIsFocused = true
                }
                .alert("Failure!", isPresented: $viewModel.showingErrorAlert) {
                    Button("Okeydoke") {
                    }
                } message: {
                    Text(viewModel.errorAlertMessage)
                }
                .navigationDestination(isPresented: $viewModel.shouldNavigateToSuccessScreen) {
                    CreateOrJoinSuccessView(viewModel: self.viewModel)
                }
            }
            .navigationBarBackButtonHidden()
            .toolbarVisibility(.hidden)
        }
    }

}

#Preview {
    CreateOrJoinPrivatePunchLineView(viewModel: CreateOrJoinPrivatePunchLineViewModel(mode: .create))
}
