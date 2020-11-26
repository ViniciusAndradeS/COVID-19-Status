//
//  GuidelinesViewController.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import UIKit

class GuidelinesViewController: UIViewController {
  
  @IBOutlet weak var stackView: UIStackView!
  
  var state: State
  
  init(state: State) {
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let standardGuidelines = PagingViewController(dataSource: PagesRepository.getStandardGuidelines(for: state),
                                     title: "Always important...".localized)
    
    let phaseGuidelines = PagingViewController(dataSource: PagesRepository.getPhaseGuidelines(for: state),
                                      title: "Precautions in this phase...".localized)
    
    addChild(standardGuidelines)
    addChild(phaseGuidelines)
    
    stackView.addArrangedSubview(standardGuidelines.view)
    stackView.addArrangedSubview(phaseGuidelines.view)
    
    standardGuidelines.didMove(toParent: self)
    phaseGuidelines.didMove(toParent: self)
    
    title = "Guidelines".localized
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = false
  }
  
}

