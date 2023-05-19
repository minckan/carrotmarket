//
//  ProductDetailVC.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/19.
//

import SwiftUI

struct ProductDetailVC : View {
    @State private var offsetY: CGFloat = CGFloat.zero
    
    let contents = ["Seoul", "Daejeon", "Daegu", "Busan"]
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                setOffset(offset: offset)
                ZStack {
                    Image("product_sample")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    Text("대한민국")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(
                    width: geometry.size.width,
                    height: 250 + (offset > 0 ? offset : 0)
                )
                .offset(y: (offset > 0 ? -offset : 0))
            }
            .frame(minHeight: 250)
            
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(header: Header()) {
                    VStack {
                        ForEach(contents, id: \.self) { name in
                            ListItem(title: name)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .overlay(
            Rectangle()
                .foregroundColor(.white)
                .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.all)
                .opacity(offsetY > -250 ? 0 : 1)
            , alignment: .top
        )
        .navigationBarTitle("", displayMode: .automatic)
        .navigationBarHidden(true)
    }
    
    func setOffset(offset: CGFloat) -> some View {
        DispatchQueue.main.async {
            self.offsetY = offset
        }
        return EmptyView()
    }
}

struct Header: View {
    var body: some View {
        VStack {
            Spacer()
            Text("City of Korea")
                .fontWeight(.bold)
            Text("한국의 도시")
            Spacer()
            Divider()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 56)
        .background(Rectangle().foregroundColor(.white))
    }
}

struct ListItem: View {
    let title: String
    
    var body: some View {
        ZStack {
            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.black)
                .opacity(0.5)
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}


// 제네릭스 타입에 SwiftUI 뷰를 넣어주기만하면 완성
final class MyHostingController: UIHostingController<ProductDetailVC> {
}
