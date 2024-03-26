//
//  ContentView.swift
//  ScratchCardDemo
//
//  Created by Anton Brinda on 25/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @Query private var cards: [ScratchCard]

    var body: some View {
        NavigationView {
            ZStack {
                if cards.isEmpty {
                    startView
                } else {
                    VStack {

                        Spacer()

                        cardView

                        cards.first.flatMap { card in
                            NavigationLink {
                                ScratchDetailView(viewModel: ScrachDetailViewModel(), card: card)
                            } label: {
                                Text("Scratch me!")
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(
                                        Color.green.opacity(card.scratched ? 0.1 : 1)
                                    )
                                    .cornerRadius(5)
                            }
                            .disabled(card.scratched)
                        }

                        cards.first.flatMap { card in
                            NavigationLink {
                                ScratchCardActivateView(viewModel: ScratchCardActivateViewModel(), card: card)
                            } label: {
                                Text("Activate me!")
                                    .foregroundColor(Color.black)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(
                                        Color.blue.opacity(card.isActivated || !card.scratched ? 0.1 : 1)
                                    )
                                    .cornerRadius(5)
                            }
                            .disabled(card.isActivated)
                        }

                        Spacer()

                        Button {
                            reset()
                        } label: {
                            Text("Reset")
                        }

                    }
                }
            }
        }
        .padding()
    }

    var startView: some View {
        VStack {
            Button {
                modelContext.insert(ScratchCard(scratched: false, uuid: ""))
            } label: {
                Text("Start")
            }
        }
    }

    var cardView: some View {
        ZStack {
            VStack {
                cards.first.flatMap { card in
                    Text(card.scratched == false 
                         ? "#####"
                         : card.isActivated ? "ACTIVATED!" : "Your card number is:\n\(card.uuid)")
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .frame(width: 250, height: 180)
        .background(
            Color.blue
                .opacity(0.2)
        )
        .cornerRadius(15)
    }

    private func reset() {
        withAnimation {
            cards.first.flatMap({ card in
                modelContext.delete(card)
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ScratchCard.self, inMemory: true)
}

