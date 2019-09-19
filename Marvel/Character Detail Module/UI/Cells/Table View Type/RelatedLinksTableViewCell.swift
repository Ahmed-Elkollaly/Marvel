//
//  RelatedLinksTableViewCell.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/4/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit


class RelatedLinksTableViewCell: UITableViewCell {

    static let identifier = "RelatedLinksTableViewCell"
    
    private let linkCellIdentifier = "LinkCell"
    
    
    
    private var numberOfItems :Int {
        
        return cellsViewModels.count
    }
    
    private var sectionNumber = 0
    private var cellsViewModels :[LinkViewModelCell] = []
    
    var cellDidSelected : ( (_ _section:Int,_ _index:Int,_ url:String) -> (Void) )?
    
    private var linksTableView: UITableView = {
        
        let tableView =  UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        
        return tableView
    }()
   

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

            setupCellUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// Configure Cell and Load table view Data
    ///
    /// - Parameters:
    ///   - tableSectionNumber: section number of this cell
    ///   - data: to be loaded in tableview
    func configureData(tableSectionNumber:Int,data:[LinkViewModelCell]) {
        
        self.sectionNumber = tableSectionNumber
        self.cellsViewModels = data
        
        linksTableView.reloadData()
        
    }
    
    
   
}

//MARK : Setup UI
extension RelatedLinksTableViewCell {
    
    private func setupCellUI(){
        
        self.backgroundColor = .clear
        
        setupLinksTableViewConstraints()
        
        configureLinksTableView()
        
        
    }
    fileprivate func setupLinksTableViewConstraints() {
        
        addSubview(linksTableView)
        
        NSLayoutConstraint.activate([
            self.linksTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.linksTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.linksTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.linksTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
            ])
    }
    
    fileprivate func configureLinksTableView() {
        linksTableView.register(UITableViewCell.self, forCellReuseIdentifier: linkCellIdentifier)
        
        linksTableView.delegate = self
        linksTableView.dataSource = self
    }

    
}

//MARK: Table View Delegate methods
extension RelatedLinksTableViewCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: linkCellIdentifier, for: indexPath)
    
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .white
        cell.backgroundColor = .clear
        cell.textLabel?.text = cellsViewModels[indexPath.item].type.capitalizingFirstLetter()
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        
        guard index < cellsViewModels.count else { return }
        
        if let link = cellsViewModels[index].url {
    
            cellDidSelected?(sectionNumber,index,link)
    
        }
        
        
    }
    
}
