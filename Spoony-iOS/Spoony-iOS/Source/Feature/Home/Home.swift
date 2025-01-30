//
//  Home.swift
//  SpoonMe
//
//  Created by 이지훈 on 1/2/25.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = HomeViewModel(service: DefaultHomeService())
    @State private var isBottomSheetPresented = true
    @State private var searchText = ""
    @State private var selectedPlace: CardPlace?
    @State private var currentPage = 0
    @State private var spoonCount: Int = 0
    private let restaurantService: HomeServiceType
    
    init(restaurantService: HomeServiceType = DefaultHomeService()) {
        self.restaurantService = restaurantService
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            NMapView(viewModel: viewModel, selectedPlace: $selectedPlace)
                .edgesIgnoringSafeArea(.all)
                .onChange(of: viewModel.focusedPlaces) { _, newPlaces in
                    if !newPlaces.isEmpty {
                        selectedPlace = newPlaces[0]
                    }
                }
                .onChange(of: viewModel.pickList) { _ in
                    selectedPlace = nil
                    if let location = viewModel.selectedLocation {
                        print("Moving to new location: \(location)")
                    }
                }
            
            VStack(spacing: 0) {
                if let locationTitle = navigationManager.currentLocation {
                    CustomNavigationBar(
                        style: .locationTitle,
                        title: locationTitle,
                        searchText: $searchText,
                        onBackTapped: {
                            viewModel.fetchPickList()
                            navigationManager.currentLocation = nil
                        }
                    )
                    .frame(height: 56.adjusted)
                } else {
                    CustomNavigationBar(
                        style: .searchContent,
                        searchText: $searchText,
                        spoonCount: spoonCount,
                        tappedAction: {
                            navigationManager.push(.searchView)
                        }
                    )
                    .frame(height: 56.adjusted)
                }
                Spacer()
            }
            
            Group {
                if !viewModel.focusedPlaces.isEmpty {
                    PlaceCard(
                        places: viewModel.focusedPlaces,
                        currentPage: $currentPage
                    )
                } else if navigationManager.currentLocation != nil && !viewModel.searchPickList.isEmpty {
                    // 검색 결과가 있을 때는 SearchLocationBottomSheetView 표시
                    SearchLocationBottomSheetView(viewModel: viewModel)
                        .onAppear {
                            print("✅ Showing SearchLocationBottomSheetView with \(viewModel.searchPickList.count) items")
                        }
                } else if !viewModel.pickList.isEmpty {
                    // 일반 목록이 있을 때는 BottomSheetListView 표시
                    BottomSheetListView(viewModel: viewModel)
                } else {
                    FixedBottomSheetView()
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            isBottomSheetPresented = true
            do {
                spoonCount = try await restaurantService.fetchSpoonCount(userId: Config.userId)
                if navigationManager.currentLocation == nil {
                    viewModel.fetchPickList()
                }
            } catch {
                print("Failed to fetch spoon count:", error)
            }
        }
    }
}

#Preview {
    Home().environmentObject(NavigationManager())
}
