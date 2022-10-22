//
//  MainView.swift
//  SearchWithKakaoApi
//
//  Created by 김윤석 on 2022/10/21.
//

import RxSwift
import UIKit

enum MainViewAction {
    case search(String)
    case filterButtonTapped
}

class MainView: UIView {
    private let disposeBag = DisposeBag()
    
    private let searchBar = SearchBar()
    private let listView = BlogListView()
    
    private(set) lazy var obsverable = subject.asObservable()
    private let subject = PublishSubject<MainViewAction>()
    
    init() {
        super.init(frame: .zero)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with data: [BlogListCellData]) {
        listView.configure(with: data)
    }
    
    private func bind() {
        searchBar
            .observable
            .subscribe { action in
                switch action.element {
                case .searchButtonTapped(let query):
                    self.subject.onNext(.search(query))
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        listView
            .observable
            .subscribe { action in
                switch action.element {
                case .filterButtonTapped:
                    self.subject.onNext(.filterButtonTapped)
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [searchBar, listView].forEach { uv in
            addSubview(uv)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
