//
//  SearchBar.swift
//  SearchWithKakaoApi
//
//  Created by 김윤석 on 2022/10/20.
//
import SnapKit
import UIKit
import RxCocoa
import RxSwift

enum SearchBarAction {
    case searchButtonTapped(String)
}

class SearchBar: UISearchBar {
    private let disposeBag = DisposeBag()
    
    private let searchButton = UIButton()
    
    private(set) lazy var observable = subject.asObservable()
    private let subject = PublishSubject<SearchBarAction>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        Observable.merge(
            self.rx.searchButtonClicked.asObservable(),
            searchButton.rx.tap.asObservable()
        )
        .subscribe({ event in
            self.subject.onNext(.searchButtonTapped(self.text ?? ""))
        })
        .disposed(by: disposeBag)
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
}
