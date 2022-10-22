//
//  MainViewModel.swift
//  SearchWithKakaoApi
//
//  Created by 김윤석 on 2022/10/21.
//

import RxSwift
import Foundation

enum MainViewModelNotification {
    case searchResult([BlogListCellData])
}

class MainViewModel {
    private let disposeBag = DisposeBag()
    
    private(set) lazy var observable = subject.asObservable()
    private let subject = PublishSubject<MainViewModelNotification>()
    
    private var datum = [BlogListCellData]()
    
    func search(_ query: String) {
        SearchBlogNetwork().searchBlog(query: query)
            .asObservable().subscribe { event in
                switch event.element {
                case .success(let result):
                    self.datum = self.change(result)
                    self.subject.onNext(.searchResult(self.datum))
                
                case .failure(let error):
                    print(error)
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func change(_ blog: DKBlog) -> [BlogListCellData] {
        blog
            .documents
            .map { blog -> BlogListCellData in
                let thumbnailUrl = URL(string: blog.thumbnail ?? "")
                return BlogListCellData(thumbnailUrl: thumbnailUrl,
                                        name: blog.name,
                                        title: blog.title,
                                        datetime: blog.datetime)
            }
    }
    
    enum SortType {
        case date
        case title
    }
    
    public func sort(for type: SortType) {
        switch type {
        case .title:
            self.datum.sort { $0.title ?? "" < $1.title ?? "" }
            
        case .date:
            self.datum.sort { $0.datetime ?? Date() > $1.datetime ?? Date() }
        }
        
        subject.onNext(.searchResult(self.datum))
    }
}
