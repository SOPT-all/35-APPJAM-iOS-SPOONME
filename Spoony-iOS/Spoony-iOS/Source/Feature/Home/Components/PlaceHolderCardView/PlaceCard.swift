//
//  PlaceCard.swift
//  Spoony-iOS
//
//  Created by 이지훈 on 1/15/25.
//

import SwiftUI

struct PlaceCard: View {
    let places: [CardPlace]
    @Binding var currentPage: Int
    
    var body: some View {
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(places.indices, id: \.self) { index in
                        PlaceCardItem(place: places[index])
                            .tag(index)
                            .padding(.horizontal, 26)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 264.adjusted)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(.clear)
                
                ZStack {
                    if places.count > 1 {
                        PageIndicator(
                            currentPage: currentPage,
                            pageCount: places.count
                        )
                        .padding(.vertical, 4)
                    }
                }
                .frame(height: 8) 
            }
        }
}

private struct PlaceCardItem: View {
    let place: CardPlace
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                PlaceImagesLayout(images: place.images)
                
                PlaceHeaderSection(place: place)
                    .padding(15)
            }
            .background(.white)
            
            PlaceInfoSection(place: place)
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray0)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct PlaceHeaderSection: View {
    let place: CardPlace
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 6) {
                Text(place.name)
                    .customFont(.body1b)
                    .lineLimit(1)
                
                CategoryLabel(place: place)
                
                Spacer()
                
                VisitorCountLabel(count: place.visitorCount)
            }
        }
    }
}

private struct CategoryLabel: View {
    let place: CardPlace
    
    var body: some View {
        HStack(spacing: 4) {
            AsyncImage(url: URL(string: place.categoryIcon)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            } placeholder: {
                Rectangle().redacted(reason: .placeholder)
            }
            
            Text(place.description)
                .customFont(.caption1m)
        }
        .foregroundColor(Color(hex: place.categoryTextColor))
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color(hex: place.categoryColor))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private struct VisitorCountLabel: View {
    let count: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(.icAddmapGray400)
            Text(count)
                .customFont(.caption2b)
        }
    }
}

private struct PlaceInfoSection: View {
    let place: CardPlace
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(place.title)
                    .customFont(.body2sb)
                    .lineLimit(1)
                    .foregroundStyle(.gray900)
                Text(place.address)
                    .customFont(.caption1m)
                    .foregroundColor(.gray600)
            }
            Text(place.subTitle)
                .customFont(.caption1m)
                .foregroundColor(.spoonBlack)
        }
    }
}
