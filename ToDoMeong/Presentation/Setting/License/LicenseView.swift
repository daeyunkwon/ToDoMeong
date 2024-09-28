//
//  LicenseView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/27/24.
//

import SwiftUI

struct LicenseView: View {
    
    @EnvironmentObject private var tabViewManager: TabViewManager
    private let licenses = License.list
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(licenses, id: \.id) { item in
                    licenseRowView(item: item)
                }
                Divider()
                MITLicenseView()
                Divider()
                ApacheLicenseView()
                Divider()
            }
        }
        
        .navigationTitle("openSourceLicense".localized())
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            tabViewManager.isTabViewHidden = true
        }
        
        .onWillDisappear {
            tabViewManager.isTabViewHidden = false
        }
    }
    
    private func licenseRowView(item: License) -> some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(item.copyright)
                .font(.system(size: 13))
                .foregroundStyle(Color(uiColor: .systemGray))
            if let url = URL(string: item.url) {
                Link(item.url, destination: url)
                    .font(.system(size: 13))
                    .underline()
                    .foregroundStyle(.blue)
            }
        }
        .padding()
    }
}

#Preview {
    LicenseView()
}
