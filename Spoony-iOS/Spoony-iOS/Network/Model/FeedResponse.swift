//
//  FeedResponse.swift
//  Spoony-iOS
//
//  Created by 최주리 on 1/20/25.
//

import Foundation

struct FeedListResponse: Codable {
    let feedResponseList: [FeedResponse]
}

struct FeedResponse: Codable {
    let userId: Int
    let userName: String
    let createdAt: String
    let userRegion: String
    let postId: Int
    let title: String
    let categoryColorResponse: CategoryColorResponse
    let zzimCount: Int
}

struct CategoryColorResponse: Codable, Hashable {
    let categoryName: String
    let iconUrl: String
    let iconTextColor: String
    let iconBackgroundColor: String
}

extension FeedListResponse {
    func toEntity() -> [FeedEntity] {
        feedResponseList.map { feed in
            .init(
                id: UUID(),
                postId: feed.postId,
                userName: feed.userName,
                userRegion: feed.userRegion,
                title: feed.title,
                categorColorResponse: feed.categoryColorResponse,
                zzimCount: feed.zzimCount
            )
        }
    }
    
    static let sample: FeedResponse = .init(
        userId: Config.userId,
        userName: "안용아안용",
        createdAt: "2025-01-19T22:58:53.622066",
        userRegion: "서울시 성북구",
        postId: 1,
        title: "테스트 title",
        categoryColorResponse: .init(
            categoryName: "로컬 수저",
            iconUrl: "url",
            iconTextColor: "hexa code",
            iconBackgroundColor: "hexa code"
        ),
        zzimCount: 1
    )
}

extension CategoryColorResponse {
    func toEntity() -> ChipColorEntity {
        .init(
            name: self.categoryName,
            iconUrl: self.iconUrl,
            textColor: self.iconTextColor,
            backgroundColor: self.iconBackgroundColor
        )
    }
}
