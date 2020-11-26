//
//  PagingViewController.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 22/11/20.
//

import UIKit

private let reuseIdentifier = "pageIdentifier"

class PagingViewController: UIViewController {
  
  let dataSource: [PageInfo]
  let pageTitle: String
  
  var timer: Timer?
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  init(dataSource: [PageInfo], title: String) {
    self.dataSource = dataSource
    self.pageTitle = title
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    titleLabel.text = pageTitle
    
    pageControl.numberOfPages = dataSource.count
    
    setup()
    
    startTimer()
  }
  
  func setup() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(UINib(nibName: "PageViewCell", bundle: nil),
                            forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  @objc
  func scrollToNextCell() {
    guard let currentCell = collectionView.visibleCells.first else { return }
    guard let currentIndexPath = collectionView.indexPath(for: currentCell) else { return }
    let oneBasedRow = currentIndexPath.row + 1
    
    if oneBasedRow < dataSource.count {
      pageControl.currentPage = oneBasedRow
      
      collectionView.scrollToItem(at: IndexPath(row: oneBasedRow, section: 0),
                                       at: .centeredVertically,
                                       animated: true)
    } else {
      pageControl.currentPage = 0
      
      collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                       at: .centeredVertically,
                                       animated: true)
    }
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
  }
  
}

extension PagingViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                        for: indexPath)
            as? PageViewCell else { return UICollectionViewCell() }
    let guideline = dataSource[indexPath.row]
    
    cell.setupCell(with: guideline)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    timer?.invalidate()
    startTimer()
    pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
  }
}

extension PagingViewController: UICollectionViewDelegateFlowLayout {
  
}
