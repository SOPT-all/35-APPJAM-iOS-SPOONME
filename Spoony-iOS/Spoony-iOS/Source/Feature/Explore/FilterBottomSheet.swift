//
//  FilterBottomSheet.swift
//  Spoony-iOS
//
//  Created by 최주리 on 1/14/25.
//

import SwiftUI

enum FilterType: CaseIterable {
    case latest
    case popularity
    
    var title: String {
        switch self {
        case .latest:
            "최신순"
        case .popularity:
            "인기순"
        }
    }
}

struct FilterBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var selectedFilter: FilterType = .latest
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(FilterType.allCases, id: \.self) { filter in
                SpoonyButton(
                    style: selectedFilter == filter ? .activate : .deactivate,
                    size: .xlarge,
                    title: filter.title,
                    disabled: .constant(false)
                ) {
                    selectedFilter = filter
                }
            }
            SpoonyButton(
                style: .secondary,
                size: .xlarge,
                title: "취소",
                disabled: .constant(false)
            ) {
                isPresented = false
            }
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 22)
    }
}

#Preview {
    FilterBottomSheet(isPresented: .constant(true))
}