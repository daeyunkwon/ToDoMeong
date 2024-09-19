//
//  EditTodoViewModel.swift
//  ToDoMeong
//
//  Created by 권대윤 on 9/17/24.
//

import Foundation
import Combine
import RealmSwift

final class EditTodoViewModel: ViewModelType {
    
    private var todoItem: Todo
    
    private var onDelete: () -> Void
    private var onEdit: (String, Data?) -> Void
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    struct Input {
        let text = PassthroughSubject<String, Never>()
        let deleteButtonTapped = PassthroughSubject<Void, Never>()
        let editButtonTapped = PassthroughSubject<Void, Never>()
        let selectedImage = PassthroughSubject<Data, Never>()
        let removeSelectedImage = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var text = ""
        var photo: String?
        var selectedImageData: Data?
    }
    
    init(todoItem: Todo, onDelete: @escaping () -> Void, onEdit: @escaping (String, Data?) -> Void) {
        self.todoItem = todoItem
        self.onDelete = onDelete
        self.onEdit = onEdit
        
        output.text = todoItem.content
        output.photo = todoItem.photo
        
        transform()
    }
    
    func transform() {
        input.text
            .sink { [weak self] text in
                guard let self else { return }
                self.output.text = text
            }
            .store(in: &cancellables)
        
        input.deleteButtonTapped
            .sink { [weak self] _ in
                self?.onDelete()
            }
            .store(in: &cancellables)
        
        input.editButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                //self.onEdit(self.output.text, <#String?#>)
            }
            .store(in: &cancellables)
        
        input.selectedImage
            .sink { [weak self] data in
                self?.output.selectedImageData = data
            }
            .store(in: &cancellables)
        
        input.removeSelectedImage
            .sink { [weak self] _ in
                self?.output.selectedImageData = nil
            }
            .store(in: &cancellables)
    }
}

//MARK: - Action

extension EditTodoViewModel {
    enum Action {
        case deleteButtonTapped
        case editButtonTapped
        case selectedImage(imageData: Data)
        case removeSelectedImage
    }
    
    func action(_ action: Action) {
        switch action {
        case .deleteButtonTapped:
            input.deleteButtonTapped.send(())
        
        case .editButtonTapped:
            input.editButtonTapped.send(())
        
        case .selectedImage(let data):
            input.selectedImage.send(data)
            
        case .removeSelectedImage:
            input.removeSelectedImage.send(())
        }
    }
}
