//
//  ScratchDetailView.swift
//  ScratchCardDemo
//
//  Created by Anton Brinda on 25/03/2024.
//

import Foundation
import SwiftUI
import SwiftData
import Combine

struct ScratchDetailView: View {

    @ObservedObject var viewModel: ScrachDetailViewModel
    @Environment(\.modelContext) private var modelContext
    let card: ScratchCard

    var body: some View {
        ZStack {
            if viewModel.loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Button {
                    Task {
                        viewModel.scratch(card: card)
                    }
                } label: {
                    Text("Scratch me!")
                }
            }
        }
        .onDisappear {
            viewModel.cancel()
        }
    }
}

@MainActor
class ScrachDetailViewModel: ObservableObject {

    @Published var loading = false

    private var cancellables: Task<Void, Never>?

    func cancel() {
        cancellables?.cancel()
        loading = false
    }

    func scratch(card: ScratchCard) {
        self.cancellables = Task {
            do {
                loading = true
                try await Task.sleep(nanoseconds: 2_000_000_000)
                card.scratched = true
                card.uuid = UUID().uuidString
                loading = false
            } catch {

            }
        }
    }

}
