//
//  FilterView.swift
//  SearchWithKakaoApi
//
//  Created by 김윤석 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum FilterViewAction {
    case filterButtonTapped
}

class FilterView: UITableViewHeaderFooterView {
    private let disposeBag = DisposeBag()
    
    private let sortButton = UIButton()
    private let bottomBorder = UIView()
    
    private(set) lazy var observable = subject.asObservable()
    private let subject = PublishSubject<FilterViewAction>()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        sortButton.rx.tap.subscribe { _ in
            self.subject.onNext(.filterButtonTapped)
        }
        .disposed(by: disposeBag)
    }
    
    private func attribute() {
        sortButton.setImage(.init(systemName: "list.bullet"), for: .normal)
        bottomBorder.backgroundColor = .lightGray
    }
    
    private func layout() {
        [sortButton, bottomBorder].forEach { uv in
            addSubview(uv)
        }
        
        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.top.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        bottomBorder.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
