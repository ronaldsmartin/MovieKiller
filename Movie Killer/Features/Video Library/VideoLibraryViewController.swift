//
//  VideoLibraryViewController.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/28/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import UIKit
import AVKit
import RxCocoa
import RxSwift

class VideoLibraryViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    
    private let viewModel = VideoLibraryViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind(data: viewModel.videos(), to: tableView.rx)
        bindClicks(on: tableView.rx, to: viewModel.onSelect(video:))
        prepareForPlayback()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bind(data: Observable<[Video]>, to observer: Reactive<UITableView>) {
        let cellReuseId = "VideoLibraryCell"
        
        let driver = data.asDriver(onErrorJustReturn: [])
        
        driver
            .distinctUntilChanged { $0 == $1 }
            .drive(observer.items(cellIdentifier: cellReuseId)) { _, item, cell in
                cell.textLabel?.text = item.filename
                cell.detailTextLabel?.text = item.displayDate
                
                guard let imageView = cell.imageView else {
                    assertionFailure("Warning: cell does not contain required image outlet.")
                    return
                }
                // Bind imageView to image updates.
                item.thumbnail.asDriver()
                    .do(onNext: { _ in
                        // Make sure cell subviews resize to accomodate new thumbnails.
                        cell.sizeToFit()
                    })
                    .drive(imageView.rx.image)
                    .addDisposableTo(self.disposeBag)
                
                // Request thumbnail asynchronously.
                item.getThumbnail(with: self.viewModel.thumbnailManager,
                                  size: self.viewModel.thumbnailSize)
            }
            .addDisposableTo(disposeBag)
        
        driver
            .map { $0.isEmpty }
            .drive(observer.isHidden)
            .addDisposableTo(disposeBag)
    }
    
    private func bindClicks(on view: Reactive<UITableView>, to callback: @escaping (Video) -> Void) {
        view.modelSelected(Video.self)
            .asDriver()
            .drive(onNext: callback)
            .addDisposableTo(disposeBag)
    }
    
    private func prepareForPlayback() {
        viewModel.player()
            .filter { $0.currentItem != nil }
            .drive(onNext: { player in
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            })
            .addDisposableTo(disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
