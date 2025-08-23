//
//  AlarmSettingDetailView.swift
//  ToDoMeong
//
//  Created by 권대윤 on 8/9/25.
//

import SwiftUI

struct AlarmSettingDetailView: View {
    @EnvironmentObject private var tabViewManager: TabViewManager
    @ObservedObject var viewModel: SettingViewModel
    @State private var selectedTime = Date()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            
            DogMessageBubbleView(message: "localAlarm.setting.infoMessage".localized())
                .frame(height: 200)
                .padding(.horizontal, 10)
            
            Spacer().frame(height: 55)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(uiColor: .systemGray6))
                .overlay {
                    datePickerView()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
            
            Spacer().frame(height: 55)
            
            saveButtonView()
            Spacer().frame(height: 50)
        }
        .navigationTitle("localAlarm.setting.title".localized())
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            tabViewManager.isTabViewHidden = true
            selectedTime = viewModel.output.localAlarmTime
        }
        
        .onWillDisappear {
            tabViewManager.isTabViewHidden = false
        }
    }
    
    private func datePickerView() -> some View {
        DatePicker("", selection: .init(get: {
            viewModel.output.localAlarmTime
        }, set: { date in
            self.selectedTime = date
            print("DatePicker Value: \(date)")
        }), displayedComponents: [.hourAndMinute])
            .datePickerStyle(WheelDatePickerStyle())
            .frame(maxWidth: .infinity)
            .padding(.trailing, 50)
    }
    
    private func saveButtonView() -> some View {
        Button(action: {
            viewModel.action(.setLocalAlarmTime(time: self.selectedTime))
            HapticManager.shared.impact(style: .light)
            presentationMode.wrappedValue.dismiss()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .foregroundStyle(.brandGreen)
                Text("localAlarm.setting.save.title".localized())
                    .font(Constant.AppFont.tmoneyRoundWindExtraBold15)
                    .foregroundStyle(.white)
            }
        })
        .padding(.horizontal, 15)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AlarmSettingDetailView(viewModel: SettingViewModel())
        .environmentObject(TabViewManager.shared)
}
