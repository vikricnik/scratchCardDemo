//
//  ScratchCardActivateView.swift
//  ScratchCardDemo
//
//  Created by Anton Brinda on 25/03/2024.
//

import Foundation
import Combine
import SwiftUI

struct ScratchCardActivateView: View {
    
    @StateObject var viewModel: ScratchCardActivateViewModel
    let card: ScratchCard

    var body: some View {
        ZStack {
            VStack {
                if viewModel.loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button {
                        viewModel.activate(card: card)
                    } label: {
                        Text("Activate me!")
                    }
                }
            }
        }
        .alert(isPresented: $viewModel.error) {
            Alert(title: Text("Important message"), message: Text("ERROR"), dismissButton: .default(Text("Got it!")))
        }
    }

}

class ScratchCardActivateViewModel: ObservableObject {

    @Published var loading = false
    @Published var error = false

    func activate(card: ScratchCard) {

        guard card.uuid != "" else { return }

        loading = true
        var req = URLRequest(url: URL(string: "https://api.o2.sk/versions?code=\(card.uuid)")!)
        req.httpMethod = "GET"

        let queue = DispatchSerialQueue(label: "request_task")

        URLSession.shared.dataTaskPublisher(for: req)
            .subscribe(on: queue)
            .delay(for: .seconds(2), scheduler: queue)
            .tryMap { data in
                guard let httpResponse = data.response as? HTTPURLResponse, httpResponse.statusCode >= 200
                else {
                    throw URLError(.badServerResponse)
                }
                return try JSONSerialization.jsonObject(with: data.data)
            }
            .receive(on: DispatchSerialQueue.main)
            .receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in

            }, receiveValue: { [weak self] (dict: Any) in
                self?.loading = false

                guard let dict = dict as? NSDictionary else { 
                    self?.error = true
                    return
                }
                let ios = dict["ios"] as? String
                ios.flatMap { val in
                    card.ios = Double(val)
                }

                if !card.isActivated {
                    self?.error = true
                }
            }))
    }
}
