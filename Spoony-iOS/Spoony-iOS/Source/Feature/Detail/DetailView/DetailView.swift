//
//  DetailView.swift
//  SpoonMe
//
//  Created by 이명진 on 1/2/25.
//

import SwiftUI
import NMapsMap

enum SNError: Error {
    case networkFail
    case decodeError
    case etc
}

struct DetailView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var navigationManager: NavigationManager
    
    private let userImage = Image(.icCafeBlue)
    private let userName: String = "이명진"
    private let placeAdress: String = "서울시 마포구 합정동 금수저"
    
    @State private var searchName = "연남"
    @State private var appName: String = "Spoony"
    @State private var isMyPost: Bool = true
    @State private var isPresented: Bool = false
    @State private var popUpIsPresented: Bool = false
    @State private var privateMode: Bool = false
    @State private var toastMessage: Toast?
    @State private var toggleRedacted = false
    
    @State private var detailModel: ReviewDetailModel = .sample()
    
    // MARK: - body
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(
                style: .detailWithChip(count: detailModel.zzimCount),
                onBackTapped: {
                    navigationManager.pop(1)
                }
            )
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    userProfileSection
                    imageSection
                    reviewSection
                    placeInfoSection
                }
            }
            .simultaneousGesture(dragGesture)
            .onTapGesture {
                dismissDropDown()
            }
            .overlay(alignment: .topTrailing, content: {
                dropDownView
            })
            .scrollIndicators(.hidden)
            .toastView(toast: $toastMessage)
            .onAppear {
                DetailService().getReviewDetail(userId: 1, post: 1) { result in
                    switch result {
                    case .success(let data):
                        detailModel = data
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            bottomView
                .frame(height: 80.adjustedH)
        }
        .redacted(reason: toggleRedacted ? .placeholder : [])
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: Gesture
extension DetailView {
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { _ in
                dismissDropDown()
            }
    }
}

// MARK: Method
extension DetailView {
    private func dismissDropDown() {
        isPresented = false
    }
}

// MARK: - Subviews

extension DetailView {
    private var userProfileSection: some View {
        HStack(alignment: .center, spacing: 14.adjustedH) {
            
            Image(.imgMockProfile)
                .resizable()
                .scaledToFit()
                .frame(width: 48.adjusted, height: 48.adjustedH)
            
            VStack(alignment: .leading, spacing: 4.adjustedH) {
                Text(userName)
                    .customFont(.body2b)
                    .foregroundStyle(.black)
                
                Text(placeAdress)
                    .customFont(.caption1b)
                    .foregroundStyle(.gray400)
            }
            
            Spacer()
            
            if isMyPost {
                Image(.icMenu)
                    .onTapGesture {
                        isPresented.toggle()
                    }
            }
            
        }
        .padding(EdgeInsets(top: 8.adjustedH, leading: 20.adjusted, bottom: 8.adjustedH, trailing: 20.adjusted))
        .padding(.bottom, 24.adjustedH)
    }
    
    private var imageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10.adjusted) {
                ForEach(0..<4) { _ in
                    Image(.imgMockGodeung)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 278.adjusted)
                        .blur(radius: privateMode ? 12 : 0)
                        .cornerRadius(11.16)
                }
                .frame(height: 278.adjustedH)
            }
            .padding(EdgeInsets(top: 0, leading: 20.adjusted, bottom: 32.adjustedH, trailing: 20.adjusted))
        }
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 8.adjustedH) {
            IconChip(
                title: "주류",
                foodType: .bar,
                chipType: .small,
                color: .purple
            )
            
            Text("인생 이자카야. 고등어 초밥 안주가 그냥 미쳤어요.".splitZeroWidthSpace())
                .customFont(.title1b)
                .foregroundStyle(.black)
            
            Text("2025년 8월 21일")
                .customFont(.caption1m)
                .foregroundStyle(.gray400)
            
            Spacer()
                .frame(height: 16.adjustedH)
            
            Text("이자카야인데 친구랑 가서 안주만 5개 넘게 시킴.. 명성이 자자한 고등어봉 초밥은 꼭 시키세요! 입에 넣자마자 사르르 녹아 없어짐. 그리고 밤 후식 진짜 맛도리니까 밤 디저트 좋아하는 사람이면 꼭 먹어보기!")
                .font(.body2m)
                .foregroundStyle(.gray900)
            
        }
        .padding(EdgeInsets(top: 0, leading: 20.adjusted, bottom: 32.adjustedH, trailing: 20.adjusted))
    }
    
    private var placeInfoSection: some View {
        VStack(spacing: 0) {
            menuInfo
                .background {
                    Rectangle()
                        .cornerRadius(20)
                        .foregroundStyle(.gray0)
                        .frame(maxHeight: .infinity)
                }
                .overlay(alignment: .bottom) {
                    Line()
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 1.adjustedH,
                                dash: [8.adjusted]
                            )
                        )
                        .foregroundStyle(.gray200)
                        .frame(width: 266.adjusted, height: 1.adjustedH, alignment: .bottom)
                }
            
            locationInfo
                .background {
                    Rectangle()
                        .frame(maxHeight: 134.adjustedH)
                        .cornerRadius(20)
                        .foregroundStyle(.gray0)
                }
            
        }
        .padding(.horizontal, 20.adjusted)
        .blur(radius: privateMode ? 8 : 0)
    }
    
    private var menuInfo: some View {
        VStack(alignment: .leading, spacing: 12.adjustedH) {
            Text("Menu")
                .customFont(.body1b)
                .foregroundStyle(.spoonBlack)
            menuList()
        }
        .padding(EdgeInsets(top: 20.adjustedH, leading: 16.adjusted, bottom: 28.adjustedH, trailing: 20.adjusted))
    }
    
    private var locationInfo: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12.adjustedH) {
                Text("Location")
                    .customFont(.body1b)
                    .foregroundStyle(.spoonBlack)
                Text("상호명")
                    .customFont(.title2sb)
                    .foregroundStyle(.spoonBlack)
                HStack(spacing: 4.adjusted) {
                    Image(.icMapGray400)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20.adjusted, height: 20.adjustedH)
                    
                    Text("서울 마포구 연희로11가길 39")
                        .customFont(.body2m)
                        .foregroundStyle(.spoonBlack)
                }
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 21.adjustedH, leading: 16.adjusted, bottom: 21.adjustedH, trailing: 16.adjusted))
    }
    
    private var bottomView: some View {
        HStack(spacing: 0) {
            SpoonyButton(
                style: .secondary,
                size: privateMode ? .xlarge : .medium,
                title: privateMode ? "떠먹기" : "길찾기",
                isIcon: privateMode ? true : false,
                disabled: .constant(false)
            ) {
                
                if privateMode {
                
                    DetailService().scoopReview(userId: 1, post: 1)
                    
                    navigationManager.popup = .useSpoon(action: {
                        //TODO: 떠먹기 버튼 기능 구현
                        Task {
                            toggleRedacted = true
                            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 3초 대기
                            toggleRedacted = false
                            privateMode = false
                        }
                    })
                } else {
                    let url = URL(string: "nmap://search?query=\(searchName)&appname=\(appName)")!
                    let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
                    
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.open(appStoreURL)
                    }
                }
            }
            
            if !privateMode {
                Spacer()
                
                SpoonButton(toastMessage: $toastMessage)
            }
        }
        .padding(.horizontal, 20.adjusted)
    }
    
    private var dropDownView: some View {
        Group {
            if isPresented {
                DropDownMenu(
                    items: ["신고하기"],
                    isPresented: $isPresented
                ) { _ in
                    navigationManager.push(.report)
                    //                    print("선택된 메뉴: \(menu)")
                    //                    isPresented = false
                    //                    privateMode = true
                }
                .frame(alignment: .topTrailing)
                .padding(.top, 48.adjustedH)
                .padding(.trailing, 20.adjusted)
            }
        }
    }
}

struct menuList: View {
    var menus: [String] = ["고등어봉초밥", "고등어봉초밥", "고등어봉초밥"]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<menus.count, id: \.self) { index in
                HStack(spacing: 4) {
                    Image(.icSpoonGray600)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20.adjusted, height: 20.adjustedH)
                    Text(menus[index])
                        .customFont(.body2m)
                        .lineLimit(2)
                    Spacer()
                }
            }
        }
    }
}

struct SpoonButton: View {
    @Binding var toastMessage: Toast?
    @State private var isScrap: Bool = false
    @State private var scrapCount: Int = 100
    
    var body: some View {
        VStack(spacing: 4) {
            Image(isScrap ? .icAddmapMain400 : .icAddmapGray400)
                .resizable()
                .scaledToFit()
                .frame(width: 32.adjusted, height: 32.adjustedH)
                .onTapGesture {
                    if isScrap {
                        DetailService().unScrapReview(userId: 1, post: 1)
                        scrapCount -= 1
                        toastMessage = Toast(style: .gray, message: "내 지도에서 삭제되었어요.", yOffset: 539.adjustedH)
                    } else {
                        
                        DetailService().scrapReview(userId: 1, post: 1)
                        scrapCount += 1
                        toastMessage = Toast(style: .gray, message: "내 지도에 추가되었어요.",
                                             yOffset: 539.adjustedH)
                        
                    }
                    isScrap.toggle()
                }
                .padding(EdgeInsets(top: 1.5, leading: 12, bottom: 4, trailing: 12))
            
            Text("\(scrapCount)")
                .customFont(.caption1m)
                .foregroundStyle(isScrap ? .main400 : .gray800)
                .padding(.bottom, 1.5)
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// MARK: - Network
// TODO: - Service 분리
public struct DetailService {
    
    let detailProvider = Providers.detailProvider
    
    func getReviewDetail(userId: Int, post: Int, completion: @escaping (Result<ReviewDetailModel, SNError>) -> Void) {
        detailProvider.request(.getDetailReview(userId: 1, postId: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    let responseDto = try response.map(BaseResponse<ReviewDetailModel>.self)
                    
                    if let data = responseDto.data {
                        completion(.success(data))
                    } else {
                        completion(.failure(.decodeError))
                    }
                    
                } catch {
                    print("decode map to error")
                }
            case .failure(let error):
                print("통신 실패: \(error)")
            }
        }
    }
    
    func scrapReview(userId: Int, post: Int) {
        detailProvider.request(.scrapReview(userId: 1, postId: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    let _ = try response.map(BaseResponse<BlankData>.self)
                    
                } catch {
                    print("decode map to error")
                }
            case .failure(let error):
                print("통신 실패: \(error)")
            }
        }
    }
    
    func unScrapReview(userId: Int, post: Int) {
        detailProvider.request(.unScrapReview(userId: 1, postId: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    let _ = try response.map(BaseResponse<BlankData>.self)
                    
                } catch {
                    print("decode map to error")
                }
            case .failure(let error):
                print("통신 실패: \(error)")
            }
        }
    }
    
    func scoopReview(userId: Int, post: Int) {
        detailProvider.request(.scoopReview(userId: 1, postId: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    let _ = try response.map(BaseResponse<BlankData>.self)
                    
                } catch {
                    print("decode map to error")
                }
            case .failure(let error):
                print("통신 실패: \(error)")
            }
        }
    }
}

#Preview {
    DetailView()
}
