![Swift](https://img.shields.io/badge/Swift-5.10-orange)
![Xcode](https://img.shields.io/badge/Xcode-15.3-blue)

# 투두멍  <img width="100" alt="image" src="https://github.com/user-attachments/assets/a8d4411f-5627-45a5-bbdb-b5231dca6db3" align="left">
> 오늘의 할 일을 쉽게 관리할 수 있는 앱이에요 ✨


<a href="https://apps.apple.com/kr/app/%ED%88%AC%EB%91%90%EB%A9%8D-%EA%B0%84%ED%8E%B8%ED%95%9C-%ED%88%AC%EB%91%90%EB%A6%AC%EC%8A%A4%ED%8A%B8-%EC%95%B1/id6720724136">
  <img src="https://github.com/user-attachments/assets/c0a5b882-a059-463c-811b-46279e4d2b6d" width="235" height="95" alt="App Store Banner">
</a>



<br>

## 📖 프로젝트 정보
- 개발 기간: `2024.09.12 ~ 2024.09.29 (18일)`
- 최소 지원 버전: `iOS 16.0`
### 팀 구성
- 개인 프로젝트

<br>

## 🛠️ 사용 기술

- 언어: `Swift` `iOS`
- 프레임워크: `SwiftUI`
- 아키텍처: `MVVM`
- 그 외 기술:
  - `Combine`
  - `RealmSwift`
  - `PhotosUI`
  - `MessageUI`
  - `PopupView`
  - `FSCalendar`
  - `SPM`

 
<br>

## 📱 주요 화면 및 기능

### 핵심 기능 소개
> - 오늘의 할 일을 조회, 추가, 수정, 삭제할 수 있습니다.
> - 캘린더에서 선택한 날짜의 할 일을 조회, 추가, 수정, 삭제할 수 있습니다.

<br>

### 홈 화면
> - 오늘의 월, 일, 요일 정보가 상단에 표시됩니다.
> - 추가된 오늘의 할 일 목록을 조회할 수 있습니다.
> - 할 일의 체크박스 아이콘 버튼을 선택하여 할 일 완료 여부에 대한 상태 변경이 가능합니다.
> - 할 일의 글자 영역을 선택하면 할 일 수정 화면으로 화면 전환됩니다.
> - 할 일의 사진 영역을 선택하면 사진 상세 보기 화면으로 화면 전환됩니다.
> - \+ 버튼을 선택하면 새로운 할 일 작성 화면으로 이동하여 새로운 할 일을 추가할 수 있습니다.

| 홈 화면 |
| :---: |
| <img src="https://github.com/user-attachments/assets/8ebc7909-6844-4af0-9276-68c1d030b28a" width="200"> |

### 캘린더 화면
> - 캘린더에서 선택한 날짜에 추가된 할 일 목록을 조회할 수 있습니다.
> - 캘린더에서 할 일이 있는 날에는 발자국 아이콘이 표시됩니다.
> - 캘린더에서 오늘 날짜에 해당하는 날에는 오늘이라는 단어가 표시됩니다.
> - 캘린더에서 왼쪽 또는 오른쪽으로 스와이프 제스처 시 캘린더에서 월을 변경할 수 있습니다.
> - 우측 상단에 오늘 버튼을 선택하여 현재 날짜로 즉시 돌아올 수 있습니다.
> - 우측 중앙에 + 할 일 추가하기 버튼을 선택하면 새로운 할 일 작성 화면으로 이동하여, 선택한 날짜에 새로운 할 일을 추가할 수 있습니다.

| 캘린더 화면 |
| :---: |
| <img src="https://github.com/user-attachments/assets/51eefbed-a1d1-4742-ac9d-9ae564ce16cb" width="200"> |


### 할 일 수정 화면
> - 할 일에 대한 내용을 수정할 수 있습니다.
> - 내용 입력 영역 우측에 x 버튼을 선택하여 입력한 내용을 전부 지울 수 있습니다.
> - 사진 추가하기 버튼을 선택하면 앨범에서 1장의 사진을 추가할 수 있습니다.
> - 저장 버튼을 선택하면 수정된 내용이 저장되어 홈 화면에 반영됩니다.
> - 삭제 버튼을 선택하면 해당 할 일이 삭제됩니다.
> - 화면의 어두운 배경 영역을 선택하면 수정을 취소할 수 있습니다.

| 할 일 수정 화면 |
| :---: |
| <img src="https://github.com/user-attachments/assets/01222df3-69d3-40ab-be65-7039619f35ef" width="200"> | 

### 설정 화면
> - 현재 제공되는 설정 메뉴들이 조회됩니다.
> - 화면 테마 메뉴를 선택하면 화면 테마 설정 화면으로 전환되어 라이트 & 다크 모드를 설정할 수 있습니다.
> - 문의하기 메뉴를 선택하면 메일 작성 화면으로 화면 전환됩니다.
> - 오픈소스 라이선스 메뉴를 선택하면 오픈소스 라이선스 정보 화면으로 화면 전환됩니다.
> - 앱 버전 메뉴의 우측에는 현재 앱 버전이 표시됩니다.

| 설정 화면 |
| :---: |
| <img src="https://github.com/user-attachments/assets/f44a229f-fff9-4500-84d8-f29ba1799588" width="200"> | 



<br>

## 📡 주요 기술
- MVVM Pattern을 도입하여 뷰는 화면을 그리는 역할에만 집중하게 하고, 데이터 관리와 로직 처리는 ViewModel에서 담당하도록 분리했습니다.
- ViewModel에 Input-Output Pattern을 적용하여 데이터 흐름을 명확하게 했습니다.
- Combine을 사용하여 UI와 데이터 간의 반응형 바인딩을 구현했습니다.
- RealmSwift를 사용하여 사용자의 할 일 데이터를 조회, 추가, 수정, 삭제(CRUD)할 수 있는 기능을 구현했습니다.
- MessageUI를 활용해 사용자가 문의 이메일을 보낼 수 있는 기능을 구현했습니다.
- PhotosUI를 활용하여 사용자가 앨범에 있는 사진을 업로드할 수 있는 기능을 구현했습니다.
- 앱에서 다크 모드와 라이트 모드를 모두 지원하도록 구현했습니다.
- NSLocalizedString를 활용해 다국어(영어, 일본어)를 지원하도록 구현했습니다.

<br>

## 🚀 문제 및 해결 과정

### 1. 이전에 추가된 할 일 메모 삭제 시 crash 발생되는 문제

#### 문제 상황

다음 영상과 같이, 새로 추가한 할 일 메모는 정상 삭제 가능하지만 이전에 추가했던 할 일 메모 삭제 시 Thread 1: "Object has been deleted or invalidated.” 에러 문구와 함께 충돌이 발생되는 문제가 있었습니다.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/6ddb6f3b-29b4-4e57-be39-9a89504fdfd6">




#### 문제 원인
구글 검색을 통해, 해당 에러는 이미 삭제한 데이터 객체를 참조할 때 발생되는 것으로 파악할 수 있었습니다.
그래서 삭제한 할 일 메모에 대한 데이터 객체를 참조하는 곳은 어딘지 찾아봤고, ForEach 클로저 내 TodoRowView에서 참조하고 있음을 확인하였습니다.

<img width="600" alt="스크린샷 2024-09-03 오후 4 16 51" src="https://github.com/user-attachments/assets/99464b99-d14a-4cea-94c3-2bab860a1128">
<img width="600" alt="">


여기서 id 파라미터에 인수값을 `\.self`으로 주고 있었는데,
`\.self`를 이용해 객체 자체를 식별하게 만드는 것은 데이터가 중복되거나 동일한 메모리 주소를 가진 객체가 반복적으로 사용될 경우 SwiftUI가 특정 객체를 올바르게 식별하지 못하게 되어, 삭제된 객체를 여전히 참조하는 문제가 발생할 소지가 있다는 것을 확인하였습니다.

<img width="600" alt="스크린샷 2024-09-03 오후 4 16 51" src="https://github.com/user-attachments/assets/65fa0f8b-78b6-4817-a8c3-68f8b19b31fc">




#### 해결 방법

고유한 식별 값을 가지고 있는 객체 내 id 속성을 사용하여, 데이터 삭제나 업데이트 시 문제가 발생하지 않도록 보장해주도록 수정하여 해결하였습니다. 이를 통해 이전에 추가했던 할 일 메모 삭제 시 Thread 1: "Object has been deleted or invalidated.” 에러 발생없이 정상적으로 삭제할 수 있었습니다.

<img width="600" alt="스크린샷 2024-09-03 오후 4 16 51" src="https://github.com/user-attachments/assets/fbef4035-c80c-45cb-9208-b43363403d28">

<br><br>

### 2. 숨긴 커스텀 탭 바를 다시 표시할 때 속도가 느린 문제

#### 문제 상황

오픈소스 라이선스 화면에서 설정 화면으로 전환할 때, 커스텀 탭 바의 숨김 상태를 해제하는 처리를 진행했습니다. 이때 화면 전환이 완전히 완료된 시점에 커스텀 탭 바가 표시되었고, 이는 탭 바가 느리게 나타나는 문제 현상으로 보여졌습니다. 커스텀 탭 바의 느린 표시 속도는 사용자에게 불쾌한 경험을 제공할 수 있어 사용자 경험에 부정적인 영향을 미칠 수 있는 문제로 판단했습니다.

<img width="250" alt="image" src="https://github.com/user-attachments/assets/b9532247-d4e6-402a-9f7b-436b7bcdba3c">



#### 문제 원인

`tabViewManager` 클래스의 `isTabViewHidden` 속성에 `false` 값을 대입하여 커스텀 탭 바의 숨김 상태를 해제하는 코드를 `onDisappear` 클로저 내에서 처리하고 있었습니다. `onDisappear`가 호출되는 시점 때문에 커스텀 탭 바가 느리게 표시되는 문제가 발생했습니다.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/c2459d96-2af1-428d-9241-68d66eadc320">


#### 해결 방법

뷰 컨트롤러의 생명주기 중 하나인 `viewWillDisappear` 시점을 SwiftUI에서 사용하는 방법이 있을까 검색해 보던 중 `UIViewControllerRepresentable` 프로토콜을 사용하면 된다는 것을 알게 되었습니다.


UIViewLifeCycleHandler라는 커스텀 구조체를 구현했습니다. 이 구조체는 `viewWillDisappear(_:)` 호출 시점에 내부에 정의된 클로저를 실행하도록 처리합니다.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/372925de-983f-41f8-be8d-fc36189bbf35">
<img width="600" alt="">

그러면 이제 다음과 같이 사용할 수 있습니다. View의 background에 UIViewLifeCycleHandler 구조체를 넣어주고, viewWillDisappear(_:) 호출 시점에 실행할 클로저를 주입해 주면 됩니다. 이 방법을 이용해 커스텀 탭 바의 숨김 상태 해제를 .onDisappear 보다 더 빠르게 처리할 수 있었습니다.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/56862cac-f8e3-4c85-b1a1-8a504271c2e6">
<img width="600" alt="">


마지막으로 해당 방법이 다른 뷰에서도 자주 사용될 것이라 판단해 Custom ViewModifier로 만들었습니다.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/8960574a-0546-4f2c-89cb-cdcf1e597467">
<img width="600" alt="">

이로 인해 더 간결하고 편하게 사용될 수 있었습니다.

<img width="600" alt="image" src="https://github.com/user-attachments/assets/11777267-aee0-4515-86aa-fa0e0a588c28">
<img width="600" alt="">






