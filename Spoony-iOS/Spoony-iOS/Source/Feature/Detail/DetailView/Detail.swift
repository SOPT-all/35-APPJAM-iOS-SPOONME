//
//  Detail.swift
//  SpoonMe
//
//  Created by 이지훈 on 1/2/25.
//

import SwiftUI
import NMapsMap

struct Detail: View {
    
    private let userImage = Image(.icCafeBlue)
    private let userName: String = "럭키 백희"
    private let placeAdress: String = "서울시 마포구 수저"
    
    private var searchName = "연남"
    private var appName: String = "Spoony"
    
    var body: some View {
        
        CustomNavigationBar(style: .detailWithChip(count: 99)) {
            print("하이")
        }
        
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                firstSection
                secondSection
                thirdSection
                fourthSection
            }
        }
        
        HStack(spacing: 0) {
            SpoonyButton(style: .secondary, size: .medium, title: "길찾기", disabled: .constant(false)) {
                let url = URL(string: "nmap://search?query=\(searchName)&appname=\(appName)")!
                let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.open(appStoreURL)
                }
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(.icAddmapGray400)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56.adjusted, height: 32.adjustedH)
                
                Text("99")
                    .font(.caption1m)
                    .foregroundStyle(.gray800)
            }
        }.padding(.horizontal, 20.adjusted)
    }
}

extension Detail {
    private var firstSection: some View {
        
        HStack(spacing: 16.0) {
            
            Circle()
                .fill(Color.pink)
                .scaledToFit()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userName)
                    .font(.body2b)
                    .foregroundStyle(.black)
                
                Text(placeAdress)
                    .font(.caption1b)
                    .foregroundStyle(.gray400)
            }
            
            Spacer()
            
            Image(.icMenu)
            
        }.padding(EdgeInsets(top: 11.5, leading: 20, bottom: 11.5, trailing: 20))
            .padding(.bottom, 24.adjustedH)
    }
    
    private var secondSection: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<4) { _ in
                    Image(.imgFood)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 278)
                    //                        .blur(radius: 12)
                        .cornerRadius(11.16)
                }
                .frame(height: 278)
            }
            .padding(.leading, 20.adjusted)
            .padding(.trailing, 20.adjusted)
            .padding(.bottom, 32.adjustedH)
        }
    }
    
    private var thirdSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .frame(width: 61, height: 24)
                .cornerRadius(12)
                .foregroundStyle(.purple400)
            
            Text("인생 이자카야. 고등어 초밥 안주가 그냥 미쳤어요.".splitZeroWidthSpace())
                .font(.title1b)
                .foregroundStyle(.black)
            
            Text("2025년 1월 2일")
                .font(.caption1m)
                .foregroundStyle(.gray400)
            
            Spacer().frame(height: 16.adjustedH)
            
            Text("이자카야인데 친구랑 가서 안주만 5개 넘게 시킴.. 명성이 자자한 고등어봉 초밥은 꼭 시키세요! 입에 넣자마자 사르르 녹아 없어짐. 그리고 밤 후식 진짜 맛도리니까 밤 디저트 좋아하는 사람이면 꼭 먹어보기! ")
                .font(.body2m)
                .foregroundStyle(.gray900)
            
        }
        .padding(.horizontal, 20.adjusted)
        .padding(.bottom, 32.adjustedH)
    }
    
    private var fourthSection: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .frame(height: 166.adjustedH)
                    .cornerRadius(20)
                    .foregroundStyle(.gray0)
                    .overlay {
                        fifthSection
                    }
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [8.adjustedH]))
                    .foregroundStyle(.gray200)
                    .frame(width: 266.adjusted, height: 1)
                
            }
            ZStack {
                Rectangle()
                    .frame(height: 134)
                    .cornerRadius(20)
                    .foregroundStyle(.gray0)
                
                sixthSection
            }
        }.padding(.horizontal, 20.adjusted)
    }
    
    private var fifthSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12.adjustedH) {
                Text("Menu")
                    .font(.body1b)
                    .foregroundStyle(.spoonBlack)
                menuList
                menuList
                menuList
            }
            Spacer()
        }.padding(.leading, 16.adjusted)
    }
    
    private var sixthSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12.adjustedH) {
                Text("Location")
                    .font(.body1b)
                    .foregroundStyle(.spoonBlack)
                Text("상호명")
                    .font(.title2sb)
                    .foregroundStyle(.spoonBlack)
                HStack(spacing: 4) {
                    Image(.icMapGray400)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("주소")
                        .font(.body2m)
                        .foregroundStyle(.spoonBlack)
                }
            }
            Spacer()
        }.padding(.leading, 16.adjusted)
    }
    
    private var menuList: some View {
        HStack(spacing: 4) {
            Image(.icSpoonGray600)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            Text("메뉴")
                .font(.body2m)
        }
    }
}

#Preview {
    Detail()
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
