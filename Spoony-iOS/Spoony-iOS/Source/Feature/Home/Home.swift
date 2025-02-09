//
//  Home.swift
//  SpoonMe
//
//  Created by 이지훈 on 1/2/25.
//

import SwiftUI
import FlexSheet

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
            
            VStack(spacing: 0) {
                CustomNavigationBar(
                    style: .searchContent,
                    searchText: $searchText,
                    spoonCount: spoonCount,
                    tappedAction: {
                        navigationManager.push(.searchView)
                    }
                )
                .frame(height: 56.adjusted)
                Spacer()
            }
            
            Group {
                if !viewModel.focusedPlaces.isEmpty {
                    PlaceCard(
                        places: viewModel.focusedPlaces,
                        currentPage: $currentPage
                    )
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom))
                } else {
                    if !viewModel.pickList.isEmpty {
                        FlexibleListBottomSheet(viewModel: viewModel)
                    } else {
                        EmptyStateBottomSheet()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            isBottomSheetPresented = true
            do {
                spoonCount = try await restaurantService.fetchSpoonCount(userId: Config.userId)
                viewModel.fetchPickList()
            } catch {
                print("Failed to fetch spoon count:", error)
            }
        }
    }
}

struct FlexibleListBottomSheet: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var currentStyle: BottomSheetStyle = .half
    @State private var scrollOffset: CGFloat = 0
    @State private var lastContentOffset: CGFloat = 0
    @State private var isAtTop: Bool = true
    @GestureState private var isDragging: Bool = false
    @State private var firstVisibleItemIndex: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            FlexibleBottomSheet(
                currentStyle: $currentStyle,
                style: .defaultFlex
            ) {
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray200)
                            .frame(width: 24.adjusted, height: 2.adjustedH)
                            .padding(.top, 10)
                        
                        HStack(spacing: 4) {
                            Text("양수정님의 찐맛집")
                                .customFont(.body2b)
                            Text("\(viewModel.pickList.count)")
                                .customFont(.body2b)
                                .foregroundColor(.gray500)
                        }
                        .padding(.bottom, 8)
                    }
                    .frame(height: 60.adjustedH)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    
                    ScrollView(showsIndicators: false) {
                        GeometryReader { geometry in
                            Color.clear.preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geometry.frame(in: .named("scroll")).minY
                            )
                        }
                        .frame(height: 0)
                        
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.pickList.enumerated()), id: \.element.placeId) { index, pickCard in
                                BottomSheetListItem(pickCard: pickCard)
                                    .id(index)
                                    .onAppear {
                                        if index == 0 {
                                            firstVisibleItemIndex = 0
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            currentStyle = .full
                                        }
                                        viewModel.fetchFocusedPlace(placeId: pickCard.placeId)
                                    }
                            }
                            
                            if currentStyle == .full {
                                Color.clear.frame(height: 90.adjusted)
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                        if isDragging {
                            isAtTop = offset >= 0
                            scrollOffset = offset
                        }
                    }
                    .disabled(currentStyle == .half)
                }
                .background(Color.white)
            }
        }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct EmptyStateBottomSheet: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var isDisabled = false
    
    private let fixedStyle = FlexSheetStyle(
        animation: .spring(response: 0.3, dampingFraction: 0.7),
        dragSensitivity: 500,
        allowHide: false,
        fixedHeight: UIScreen.main.bounds.height * 0.5
    )
    
    var body: some View {
        FixedBottomSheet(style: fixedStyle) {
            VStack(spacing: 16) {
                Image(.imageGoToList)
                    .resizable()
                    .frame(width: 100.adjusted, height: 100.adjustedH)
                
                Text("아직 추가된 장소가 없어요.\n다른 사람의 리스트를 떠먹어 보세요!")
                    .customFont(.body2m)
                    .foregroundStyle(.gray500)
                    .multilineTextAlignment(.center)
                
                SpoonyButton(
                    style: .secondary,
                    size: .xsmall,
                    title: "떠먹으러 가기",
                    disabled: $isDisabled
                ) {
                    navigationManager.selectedTab = .explore
                }
                .padding(.top, 8)
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    Home().environmentObject(NavigationManager())
}
