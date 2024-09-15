//
//  CustomTabView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/14/24.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    private let tabBarItems: [(image: String, title: String)] = [
        ("checklist", "할 일"),
        ("calendar", "캘린더"),
        ("chart.pie", "차트"),
        ("gearshape", "설정")
    ]
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 65)
                .foregroundStyle(Color.init(uiColor: .systemBackground))
                .shadow(radius: 2)
            
            Capsule()
                .stroke(.gray, lineWidth: 0.1)
                .frame(height: 65)
                
            
            HStack {
                ForEach(0..<4) { index in
                    Button(action: {
                        withAnimation {
                            tabSelection = index
                        }
                    }, label: {
                        VStack(spacing: 8) {
                            Spacer()
                            
                            Image(systemName: tabBarItems[index].image)
                                .fontWeight(.bold)
                            
                            Text(tabBarItems[index].title)
                                .font(.caption)
                            
                            if index == tabSelection {
                                Capsule()
                                    .frame(height: 5)
                                    .foregroundStyle(.brandGreen)
                                    .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace)
                                    .offset(y: -2)
                            } else {
                                Capsule()
                                    .frame(height: 5)
                                    .foregroundStyle(.clear)
                                    .offset(y: -2)
                            }
                        }
                        .foregroundStyle(index == tabSelection ? .brandGreen : .gray)
                    })
                }
            }
            .frame(height: 70)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(0))
}
