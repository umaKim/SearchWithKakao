//
//  BlogListView.swift
//  SearchWithKakaoApi
//
//  Created by 김윤석 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

enum BlogListAction {
    case filterButtonTapped
}

class BlogListView: UITableView {
    private let disposeBag = DisposeBag()
    
    private let headerView = FilterView(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
    
    private let cellData = PublishSubject<[BlogListCellData]>()
    
    private(set) lazy var observable = subject.asObservable()
    private let subject = PublishSubject<BlogListAction>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
    }
    
    public func configure(with data: [BlogListCellData]) {
        DispatchQueue.main.async {
            self.cellData.onNext(data)
        }
    }
    
    private func bind() {
        headerView
            .observable
            .subscribe { event in
                switch event.element {
                case .filterButtonTapped:
                    self.subject.onNext(.filterButtonTapped)
                    
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tableView, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! BlogListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
