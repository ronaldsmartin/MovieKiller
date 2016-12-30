//
//  VideoLibraryViewController.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/28/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class VideoLibraryViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = VideoLibraryViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindTableData() {
        let cellReuseId = "VideoLibraryCell"
        viewModel.videos()
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: cellReuseId)) { _, item, cell in
                cell.textLabel?.text = item.filename
                cell.detailTextLabel?.text = item.displayDate
                                        
                guard let imageView = cell.imageView else {
                    print("Warning: cell does not contain required image outlet.")
                    return
                }
                // Bind imageView to image updates.
                item.thumbnail.asDriver()
                    .drive(imageView.rx.image)
                    .addDisposableTo(self.disposeBag)
                // Make sure cell subviews resize to accomodate new thumbnails.
                item.thumbnail.asObservable()
                    .bindNext { _ in cell.sizeToFit() }
                    .addDisposableTo(self.disposeBag)
                // Request thumbnail asynchronously.
                item.getThumbnail(with: self.viewModel.thumbnailManager,
                                  size: self.viewModel.thumbnailSize)
            }
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
