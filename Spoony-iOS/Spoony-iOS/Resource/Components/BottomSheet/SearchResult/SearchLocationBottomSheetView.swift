//
//  SearchLocationBottomSheetView.swift
//  Spoony-iOS
//
//  Created by 이지훈 on 2/10/25.
//

import SwiftUI

import FlexSheet

struct SearchLocationBottomSheetView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var currentStyle: BottomSheetStyle = .half
    
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
                            Text("이 지역의 찐맛집")
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
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.pickList.enumerated()), id: \.element.placeId) { index, pickCard in
                                SearchLocationCardItem(pickCard: pickCard.toSearchLocationResult())
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
                    .disabled(currentStyle == .half)
                }
                .background(Color.white)
            }
        }
    }
}
