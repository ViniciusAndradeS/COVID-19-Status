//
//  HomeViewController.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var phaseLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var statusColorView: UIView!
  @IBOutlet weak var trafficLightImageView: UIImageView!
  @IBOutlet weak var casesPer100kLabel: UILabel!
  @IBOutlet weak var bottomButton: UIButton!
  
  private let viewModel = HomeViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.delegate = self
    
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(willEnterForeground),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
    viewModel.checkForState()
  }
  
  @objc
  func willEnterForeground() {
    viewModel.checkForState()
  }
  
  private func setupUI() {
    statusColorView.layer.cornerRadius = 20
    bottomButton.layer.cornerRadius = bottomButton.frame.height/2
  }
  
  private func updateUI(toState state: State, withInfo info: CovidInfoModel?) {
    
    topLabel.backgroundColor = .none
    topLabel.textColor = .label
    phaseLabel.backgroundColor = .none
    phaseLabel.textColor = .label
    locationLabel.backgroundColor = .none
    locationLabel.textColor = .label
    
    if let county = info?.county, let cases = info?.cases100k {
      phaseLabel.text = state.description().localized
      locationLabel.text = "in \(county)"
      casesPer100kLabel.text = String(format: "%.2f %@".localized, cases, "cases/100k people".localized)
      
      topLabel.isHidden = false
      locationLabel.isHidden = false
      
      defaultBottomButon()
    }
    
    
    switch state {
    case .green:
      statusColorView.backgroundColor = .customGreen
      trafficLightImageView.image = UIImage(named: "TrafficLightGreen")
      casesPer100kLabel.textColor = .darkGray
      break
    case .yellow:
      statusColorView.backgroundColor = .customYellow
      trafficLightImageView.image = UIImage(named: "TrafficLightYellow")
      casesPer100kLabel.textColor = .darkGray
      break
    case .red:
      statusColorView.backgroundColor = .customRed
      trafficLightImageView.image = UIImage(named: "TrafficLightRed")
      casesPer100kLabel.textColor = .darkGray
      break
    case .darkRed:
      statusColorView.backgroundColor = .customDarkRed
      trafficLightImageView.image = UIImage(named: "Alert")
      trafficLightImageView.tintColor = .systemGray6
      casesPer100kLabel.textColor = .systemGray6
      break
    case .error(let error):
      topLabel.isHidden = true
      locationLabel.isHidden = true
      phaseLabel.text = error.title().localized
      casesPer100kLabel.text = error.message().localized
      statusColorView.backgroundColor = .systemGray6
      trafficLightImageView.image = UIImage(named: "Alert")
      trafficLightImageView.tintColor = .systemGray4
      casesPer100kLabel.textColor = .darkGray
      customizeBottomButon(error: error)
      break
    }
  }
  
  private func customizeBottomButon(error: CustomError) {
    switch error {
    case .noLocation:
      bottomButton.isEnabled = true
      bottomButton.setTitle("Go to Settings".localized, for: .normal)
    case .noInternet, .genericError:
      bottomButton.isEnabled = true
      bottomButton.setTitle("Try again".localized, for: .normal)
    default:
      bottomButton.isEnabled = false
      bottomButton.setTitle("Check out current guidelines".localized, for: .normal)
      break
    }
  }
  
  private func defaultBottomButon() {
    bottomButton.isEnabled = true
    bottomButton.setTitle("Check out current guidelines".localized, for: .normal)
  }
  
  @IBAction func bottomButonAction(_ sender: Any) {
    viewModel.didClickBottomButton()
  }
  
  private func openGuidlines(with state: State) {
    let guidelinesVC = GuidelinesViewController(state: state)
    navigationController?.pushViewController(guidelinesVC, animated: true)
  }
  
}

extension HomeViewController: HomeViewUIDelegate {
  
  func changed(_ viewModel: HomeViewModel, toState state: State, withInfo info: CovidInfoModel?) {
    updateUI(toState: state, withInfo: info)
  }
  
  func goToGuidelines(_ viewModel: HomeViewModel, withState state: State) {
    openGuidlines(with: state)
  }
  
}
