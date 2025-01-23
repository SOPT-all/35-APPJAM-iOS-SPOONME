//
//  ExploreStore.swift
//  Spoony-iOS
//
//  Created by 최주리 on 1/20/25.
//

import SwiftUI

final class ExploreStore: ObservableObject {
        private let network: ExploreProtocol = DefaultExploreService()
//    private let network: ExploreProtocol = MockExploreService()
    //TODO: navigation MVI 리팩토링은 나중에 할거다..
//    let navigationManager: NavigationManager
    
    @Published private(set) var state: ExploreState = ExploreState()
    
//    init(navigationManager: NavigationManager) {
//        self.navigationManager = navigationManager
//    }
    
    func dispatch(_ intent: ExploreIntent) {
        switch intent {
        case .onAppear:
            getSpoonCount()
            getCategoryList()
        case .navigationLocationTapped:
            state.isPresentedLocation = true
        case .locationTapped(let location):
            state.tempLocation = location
            state.isSelectLocationButtonDisabled = false
        case .selectLocationTapped:
            changeLocation()
        case .closeLocationTapped:
            state.isPresentedLocation = false
        case .filterButtontapped:
            state.isPresentedFilter = true
        case .filterTapped(let filter):
            changeFilter(filter: filter)
        case .closeFilterTapped:
            state.isPresentedFilter = false
        case .categoryTapped(let category):
            changeCategory(category: category)
        case .cellTapped(let feed): break
            //추후 feed 정보 detialview에 전달
//            navigationManager.push(.detailView)
        case .isPresentedLocationChanged(let newValue):
            state.isPresentedLocation = newValue
        case .isPresentedFilterChanged(let newValue):
            state.isPresentedFilter = newValue
        case .isSelectLocationDisabledChanged(let newValue):
            state.isSelectLocationButtonDisabled = newValue
        }
    }
}

extension ExploreStore {
    
    private func changeLocation() {
        guard let location = state.tempLocation else { return }
        
        state.selectedLocation = location
        state.navigationTitle = "서울특별시 \(location.rawValue)"
        getFeedList()
        state.tempLocation = nil
        state.isPresentedLocation = false
        state.isSelectLocationButtonDisabled = true
    }
    
    private func changeFilter(filter: FilterType) {
        state.selectedFilter = filter
        getFeedList()
        state.isPresentedFilter = false
    }
    
    private func changeCategory(category: CategoryChip) {
        state.selectedCategory = category
        getFeedList()
    }
    
    private func getFeedList() {
        Task {
            try await fetchFeedList()
        }
    }

    private func getSpoonCount() {
        Task {
            try await fetchSpoonCount()
        }
    }
    
    private func getCategoryList() {
        Task {
            try await fetchCategoryList()
            await MainActor.run {
                state.selectedCategory = state.categoryList.first
                state.navigationTitle = "서울특별시 \(state.selectedLocation.rawValue)"
            }
            try await fetchFeedList()
        }
    }
    
    // MARK: - Network
    @MainActor
    private func fetchFeedList() async throws {
        state.exploreList = try await network.getUserFeed(
            userId: Config.userId,
            categoryId: state.selectedCategory?.id ?? 1,
            location: state.selectedLocation.rawValue,
            sort: state.selectedFilter
        )
        .toEntity()
    }
    
    @MainActor
    private func fetchCategoryList() async throws {
        state.categoryList = try await network.getCategoryList().toModel()
    }
    
    @MainActor
    private func fetchSpoonCount() async throws {
        //TODO: 추후 수정 예정
        Task {
            do {
                state.spoonCount = try await DefaultHomeService().fetchSpoonCount(userId: Config.userId)
            } catch {
                print("Failed to fetch spoon count:", error)
            }
        }
    }
}
