//
//  ViewController.swift
//  CompanyData
//
//  Created by Derick on 11/08/2018.
//  Copyright © 2018 IndiemaxCorp. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {

    var companies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Selectors
    
    @objc func addHandleCompany() {
        let createCompanyController = CreateCompanyController()
        let navigationController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension CompaniesController {
    private func setupUI() -> Void {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView() // Blank UIView
        tableView.separatorColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(addHandleCompany))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
}

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = .teal
        
        let company = companies[indexPath.row]
        
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
}

extension CompaniesController: CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        let tesla = Company(name: company.name, founded: Date())
        companies.append(tesla)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
}
