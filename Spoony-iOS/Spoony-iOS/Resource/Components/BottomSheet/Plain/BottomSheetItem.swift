//
//  BottomSheetItem.swift
//  Spoony-iOS
//
//  Created by 이지훈 on 1/30/25.
//

import SwiftUI

struct BottomSheetListItem: View {
    let pickCard: PickListCardResponse
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(pickCard.placeName)
                        .customFont(.body1b)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    // 카테고리 칩
                    HStack(spacing: 4) {
                        // 카테고리 아이콘
                        AsyncImage(url: URL(string: pickCard.categoryColorResponse.iconUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                            default:
                                Color.clear
                                    .frame(width: 16, height: 16)
                            }
                        }
                        
                        Text(pickCard.categoryColorResponse.categoryName)
                            .customFont(.caption1m)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: pickCard.categoryColorResponse.iconBackgroundColor))
                    .foregroundColor(Color(hex: pickCard.categoryColorResponse.iconTextColor))
                    .cornerRadius(12)
                }
                
                Text(pickCard.placeAddress)
                    .customFont(.caption1m)
                    .foregroundColor(.gray600)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(pickCard.postTitle)
                    .customFont(.caption1m)
                    .foregroundColor(.spoonBlack)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.gray0), lineWidth: 1)
                    )
                    .shadow(
                        color: Color(.gray0),
                        radius: 16,
                        x: 0,
                        y: 2
                    )
            }
            // 이미지
            AsyncImage(url: URL(string: pickCard.photoUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    defaultPlaceholder
                case .empty:
                    defaultPlaceholder
                @unknown default:
                    defaultPlaceholder
                }
            }
            .frame(width: 98.adjusted, height: 98.adjusted)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .layoutPriority(0)
        }
        .padding(.horizontal, 16)
        .frame(height: 120.adjusted)
    }
    
    private var defaultPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.1))
    }
}
