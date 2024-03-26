//
//  ScratchCardDemoTests.swift
//  ScratchCardDemoTests
//
//  Created by Anton Brinda on 25/03/2024.
//

import XCTest
import SwiftData

final class ScratchCardDemoTests: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testModelSaved() throws {

        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>())

        XCTAssertEqual(model.count, 1)
    }

    @MainActor func testModelNotActivated() throws {

        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>()).first

        model?.ios = 6.1

        XCTAssertEqual(model?.isActivated, false)
    }

    @MainActor func testModelActivated() throws {

        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>()).first

        model?.ios = 6.2

        XCTAssertEqual(model?.isActivated, true)
    }

    @MainActor func testDelay() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>()).first!

        model.uuid = "1234"
        model.scratched = true
        let vm = ScratchCardActivateViewModel()

        vm.activate(card: model)

        let expectation = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            if model.isActivated {
                expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 5.0)
    }

    @MainActor func testCancel() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>()).first!

        let vm = ScrachDetailViewModel()

        vm.scratch(card: model)
        let expectation = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if !model.scratched {
                expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 3.0)
    }

    @MainActor func testFinish() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>()).first!

        let vm = ScrachDetailViewModel()

        vm.scratch(card: model)
        let expectation = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if model.scratched {
                expectation.fulfill()
            }
        })

        wait(for: [expectation], timeout: 4.0)
    }

    @MainActor
    func testAsyncAwaitFinish() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ScratchCard.self, configurations: config)

        container.mainContext.insert(ScratchCard(scratched: false, uuid: ""))

        let model = try container.mainContext.fetch(FetchDescriptor<ScratchCard>()).first!

        model.uuid = "1234"
        model.scratched = true
        let vm = ScratchCardActivateViewModel()

        try await vm.activate(card: model)

        XCTAssertEqual(model.isActivated, true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
