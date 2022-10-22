//
//  MainViewController.swift
//  SearchWithKakaoApi
//
//  Created by 김윤석 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa
import UmaBasicAlertKit

class MainViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let contentView = MainView()
    
    private let viewModel: MainViewModel
    
    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        bind()
        attribute()
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private func bind() {
        contentView
            .obsverable
            .subscribe { event in
                switch event.element {
                case .search(let query):
                    self.viewModel.search(query)
                    
                case .filterButtonTapped:
                    let sortDate = UIAlertAction(
                        title: "Date",
                        style: .default) { action in
                            self.viewModel.sort(for: .date)
                    }
                    
                    let sortTitle = UIAlertAction(
                        title: "Title",
                        style: .default) { action in
                            self.viewModel.sort(for: .title)
                    }
                    
                    self.presentUmaActionAlert(title: "Filter",
                                               isCancelActionIncluded: true,
                                               preferredStyle: .actionSheet,
                                               with: sortDate, sortTitle)
                    
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        viewModel
            .observable
            .subscribe { noti in
                switch noti.element {
                case .searchResult(let data):
                    self.contentView.configure(with: data)
                  
                case .none:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        title = "Daum Blog Search"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
