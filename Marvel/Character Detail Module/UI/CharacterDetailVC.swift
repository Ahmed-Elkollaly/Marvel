//
//  CharacterDetailVC.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/4/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import UIKit
import SafariServices

class CharacterDetailVC: UIViewController {

    
  
    private lazy var scrollView : UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
      
        return scrollView
    }()
    
    
    
    private lazy var characterImageView :CachedImageView = {
       
        
        let imageView = CachedImageView(frame: CGRect.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            if let imageUrl = strongSelf.marvelCharacterDetailViewModel.imageViewURL {
                
                imageView.loadImage(urlString: imageUrl)
            
            }
        
        }
        return imageView
        
    }()
    
    private lazy var nameHeadingLabel :UILabel  = {
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "NAME"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 13)
        
        
        return label
    }()
    private lazy var characterNameLabel :UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = marvelCharacterDetailViewModel.characterName
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        
        
        return label
        
        
    }()
    
    private lazy var descriptionHeadingLabel :UILabel  = {
        
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "DESCRIPTION"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 13)
        
        
        return label
    }()
    private lazy var descriptionTextView :UITextView = {
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.text = marvelCharacterDetailViewModel.bio
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = false
        
        return textView
        
        
    }()
    //this variable used for checking for adding shadow view above character imageview to avoid duplicate additions of shadow layer
    private var isFirstTimeToAddShadowView = true
    
    private let sectionHeight :CGFloat = 230
    private lazy var sectionsTableView :UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = sectionHeight
        tableView.register(TableViewCollectionSectionCell.self, forCellReuseIdentifier: TableViewCollectionSectionCell.identifier)
        tableView.register(RelatedLinksTableViewCell.self, forCellReuseIdentifier: RelatedLinksTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
   
    private let marvelCharacterDetailViewModel:CharacterDetailViewModel
    init(marvelCharacterDetailViewModel:CharacterDetailViewModel) {
        
        self.marvelCharacterDetailViewModel = marvelCharacterDetailViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            
            strongSelf.setupUI()
            
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavControllerUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
       
        
        if characterImageView.bounds != CGRect.zero && isFirstTimeToAddShadowView  {
            
            isFirstTimeToAddShadowView = false
            
            //shadow layer to insert above character imageview to make sure back button is always visible
            let shadowView = UIView(frame: characterImageView.frame)
            shadowView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.15)
            
            self.scrollView.insertSubview(shadowView, aboveSubview: characterImageView)
            
        }
        
        
    }
    //MARK: Actions
    @objc func dismiss(_ sender :UIBarButtonItem){
        
        dismiss(animated: false, completion: nil)
        
    }

    

}

//MARK: Setup UI
extension CharacterDetailVC {
    
    func setupUI(){
        view.backgroundColor = .clear
        insertBlurView(view: view, style: .dark)
        setupScrollViewUI()
        setupBackButtonUI()
        setupCharacterImageView()
        setupHeadingNameLabelUI()
        setupCharacterNameLaberlUI()
        setupHeadingDescLabelUI()
        setupCharacterDescTextViewUI()
        setupSectionsTableView()
    }
    func setupNavControllerUI(){

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func setupBackButtonUI(){
        
        let dismissImageView = UIImageView(frame: CGRect(x: 8, y: 30, width: 28, height: 28))
        
        if let image = UIImage(named:"icn-nav-back-white") {
            
            dismissImageView.image = image
            dismissImageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismiss(_:)))
            
            dismissImageView.addGestureRecognizer(tapGesture)

            
            
            
        }
        
        self.view.addSubview(dismissImageView)
        
        
    }
    func setupScrollViewUI(){
        
        self.view.addSubview(scrollView)
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        
        
        
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: safeGuides.bottomAnchor)
            ])
        
        
        
        
    }

    func setupCharacterImageView(){
        
        self.scrollView.addSubview(characterImageView)
        
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        NSLayoutConstraint.activate([
            self.characterImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant:-statusBarHeight),
            self.characterImageView.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor),
            self.characterImageView.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.characterImageView.heightAnchor.constraint(equalToConstant: safeGuides.layoutFrame.width)
            
            ])
        
        
       
    
        
  
        
        
    }
    func setupHeadingNameLabelUI(){
        
        self.scrollView.addSubview(nameHeadingLabel)
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.nameHeadingLabel.topAnchor.constraint(equalTo: self.characterImageView.bottomAnchor,constant:20),
            self.nameHeadingLabel.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor,constant:8),
            self.nameHeadingLabel.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.nameHeadingLabel.heightAnchor.constraint(equalToConstant: 15)
            
            ])
    }
    func setupCharacterNameLaberlUI(){
        
        self.scrollView.addSubview(characterNameLabel)
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.characterNameLabel.topAnchor.constraint(equalTo: self.nameHeadingLabel.bottomAnchor,constant:10),
            self.characterNameLabel.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor,constant:8),
            self.characterNameLabel.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.characterNameLabel.heightAnchor.constraint(equalToConstant: 20)
            
            ])
    }
    func setupHeadingDescLabelUI(){
        
        self.scrollView.addSubview(descriptionHeadingLabel)
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.descriptionHeadingLabel.topAnchor.constraint(equalTo: self.characterNameLabel.bottomAnchor,constant:20),
            self.descriptionHeadingLabel.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor,constant:8),
            self.descriptionHeadingLabel.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.descriptionHeadingLabel.heightAnchor.constraint(equalToConstant: 15)
            
            ])
    }
    func setupCharacterDescTextViewUI(){
        
        self.scrollView.addSubview(descriptionTextView)
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.descriptionTextView.topAnchor.constraint(equalTo: self.descriptionHeadingLabel.bottomAnchor,constant:10),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor,constant:8),
            self.descriptionTextView.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.descriptionTextView.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    func setupSectionsTableView(){
        
        self.scrollView.addSubview(sectionsTableView)
        
        let safeGuides = self.view.safeAreaLayoutGuide
        
        
        
        
        let spacing :CGFloat = 35
        let numberOfSections = CGFloat(marvelCharacterDetailViewModel.numberOfSectionsOfContainerTableView)
        let height = numberOfSections * sectionHeight + spacing * numberOfSections
        
        NSLayoutConstraint.activate([
            self.sectionsTableView.topAnchor.constraint(equalTo: self.descriptionTextView.bottomAnchor,constant:30),
            self.sectionsTableView.leadingAnchor.constraint(equalTo: safeGuides.leadingAnchor),
            self.sectionsTableView.trailingAnchor.constraint(equalTo: safeGuides.trailingAnchor),
            self.sectionsTableView.heightAnchor.constraint(equalToConstant: height), self.sectionsTableView.bottomAnchor.constraint(equalTo:self.scrollView.bottomAnchor,constant:-10)
           
            
            ])
        
        
        
    }
}

extension CharacterDetailVC : UITableViewDelegate, UITableViewDataSource {
    
  
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView()
        
        let label = UILabel(frame: CGRect(x: 8, y: 0, width: 100, height: 15))
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = marvelCharacterDetailViewModel.getSectionHeader(section: section) ?? ""
        label.textColor = .red
        
        headerView.addSubview(label)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return marvelCharacterDetailViewModel.numberOfSectionsOfContainerTableView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marvelCharacterDetailViewModel.numberOfRowsOfContainerTableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        
        
        if marvelCharacterDetailViewModel.isSectionIsRelatedLinksTableViewSection(section: indexPath.section) {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RelatedLinksTableViewCell.identifier, for: indexPath) as? RelatedLinksTableViewCell else { print("Link is nil");return UITableViewCell() }
            
             let data = marvelCharacterDetailViewModel.getRelatedLinkViewModels()
            
            cell.configureData(tableSectionNumber: indexPath.section, data: data)
            
            
            cell.cellDidSelected = {
                
                section,index,urlString in
                
            
                guard let url = URL(string: urlString) else { return }
                
                
                async_main {
                    [weak self] in
                    
                    guard let strongSelf = self else { return }
                    
                    let safariVC = SFSafariViewController(url: url)
                    
                    strongSelf.present(safariVC, animated: true, completion: nil)
                    
                    
                    
                    
                }
               
                
                
                
            }
            
            
            
            return cell
            
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCollectionSectionCell.identifier, for: indexPath) as? TableViewCollectionSectionCell else { print("Table is nil");return UITableViewCell()}
            
            
            if let data = marvelCharacterDetailViewModel.getSectionCellsViewModels(section: indexPath.section) {
                cell.configureData(tableSectionNumber: indexPath.section, data: data)
            }
            
            cell.getImageForCell = {
                
                [weak self] section, index in
                
               
                guard let strongSelf = self else { return }
                
                strongSelf.marvelCharacterDetailViewModel.fetchMovieThumbnailURL(section: section, index: index)
                
                
            }
            
            cell.cellDidSelected = {
                section, index in
                
        
                
                
            }
            
            return cell
        }
        
    }
    
    
}
extension CharacterDetailVC : CharacterDetailViewModelDelegate {
    
    
    
    func thumbnailURlDidFetched(forSection: Int, index: Int,url:String?) {
        
        
        
       
        
        
        let indexPath = IndexPath(row: 0, section: forSection)
        
        async_main {
            [weak self] in
            
            guard let strongSelf = self else { return }
            
            guard let cell = strongSelf.sectionsTableView.cellForRow(at: indexPath) as? TableViewCollectionSectionCell else { return }
            
            cell.loadImageForCell(index: index,url:url)
        }
       
  
        
    }
    
    
    
    
}


