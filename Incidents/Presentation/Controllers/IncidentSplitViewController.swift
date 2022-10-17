//
//  SplitViewController.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import UIKit

class IncidentSplitViewController: UISplitViewController {

    var primaryViewController: IncidentListViewController!
    var secondaryViewController: IncidentDetailViewController!
    let incidentListViewModel = AppDI.shared.incidentListDependencies()
    let incidentDetailViewModel = IncidentDetailViewModel()
    
    var primaryNavController: UINavigationController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewControllers()
    }
    
    
    init(){
        super.init(style: .doubleColumn)
        self.preferredDisplayMode = .oneBesideSecondary
        super.delegate = self
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadViewControllers(){
        self.primaryViewController = IncidentListViewController(viewModel: incidentListViewModel)
        self.primaryViewController.delegate = self
        primaryNavController = UINavigationController(rootViewController: self.primaryViewController)
        
        self.secondaryViewController = IncidentDetailViewController(viewModel: incidentDetailViewModel)
        self.viewControllers = [primaryNavController, secondaryViewController]
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            splitViewController?.preferredDisplayMode = .oneBesideSecondary
        } else {
            splitViewController?.preferredDisplayMode = .oneOverSecondary
        }
    }

}

// MARK: Passing data to DetailView Controller
extension IncidentSplitViewController: IncidentSelectionDelegate{
    
    func incidentSelected(_ newIncident: IncidentCellModel) {
        secondaryViewController.selectedIncident = newIncident
        self.show(secondaryViewController, sender: nil)
    }
    
    
    func onDataLoaded(firstData incident: IncidentCellModel){
        secondaryViewController.selectedIncident = incident
    }
    
    func onImageLoad(imageData: Data){
        secondaryViewController.imageData = imageData
    }
}


extension IncidentSplitViewController: UISplitViewControllerDelegate{
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }
}
