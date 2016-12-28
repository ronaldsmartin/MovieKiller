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
        tableView?.rx.setDataSource(viewModel)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
