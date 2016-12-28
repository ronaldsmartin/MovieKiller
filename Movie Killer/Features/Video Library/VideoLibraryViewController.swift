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
import Photos

class VideoLibraryViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = VideoLibraryViewModel()
    private let disposeBag = DisposeBag()
    
    private let CellReuseId = "VideoLibraryCell"
    
    
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
        viewModel.videos()
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: CellReuseId,
                                      cellType: UITableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = "\(item.sourceType) #\(row)"
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
