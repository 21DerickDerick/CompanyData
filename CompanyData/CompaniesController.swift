//
//  ViewController.swift
//  CompanyData
//
//  Created by Derick on 11/08/2018.
//  Copyright © 2018 IndiemaxCorp. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCompanies()
        
        setupUI()
    }

    // MARK: - Methods
    private func fetchCompanies() {
        print("Attempting to fetch data...")
        // attempt my core data fetch...
        
        let context = CoreDataManager.shared.persistenceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { (company) in
                print(company.name ?? "")
                
                self.companies = companies
                self.tableView.reloadData()
                
            }
        } catch let fetchErr {
            print("Error fetching core data: \(fetchErr)")
        }
    }
    
    // MARK: - Selectors
    
    @objc func addHandleCompany() {
        let createCompanyController = CreateCompanyController()
        let navigationController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let company = self.companies[indexPath.row]
        
        print("Attempting to delete company: \(company.name ?? "")")
        
        // remove the company from table view
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // delete the company from core data
        let context = CoreDataManager.shared.persistenceContainer.viewContext
        
        context.delete(company)
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete company: \(saveErr)")
        }
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        print("Attempting to edit company")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = CustomNavigationController(rootViewController: editCompanyController)
        present(navController, animated: true)
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteHandlerFunction)
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        
        deleteAction.backgroundColor = .lightRed
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction, editAction]
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = .teal
        
        let company = companies[indexPath.row]
        
        if let name = company.name, let founded = company.founded {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            let foundedDateString = dateFormatter.string(from: founded)
            
            //        let locale = Locale(identifier: "EN")
            
            let dateString = "\(name) - Founded in \(foundedDateString)"
            cell.textLabel?.text = dateString
        } else {
            cell.textLabel?.text = company.name
        }
        
//        cell.textLabel?.text = "\(company.name) - Founded: \(company.founded)"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return cell
    }
}

extension CompaniesController: CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
}
