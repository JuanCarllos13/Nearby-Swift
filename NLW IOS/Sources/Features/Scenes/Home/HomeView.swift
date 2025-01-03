//
//  HomeView.swift
//  NLW IOS
//
//  Created by Juan Carlos on 11/12/24.
//

import Foundation
import MapKit

class HomeView: UIView {
    private var filterButtonAction: ((Category) -> Void)?
    private var categories: [Category] = []
    private var selectedButton: UIButton?
    
    
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    private let filterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.gray100
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.backgroundColor = Colors.gray300
        
        return view
        
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = Colors.gray600
        descriptionLabel.font = Typography.textMD
        descriptionLabel.text = "Explore locais perto de você!"
        
        return descriptionLabel
    }()
    
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 9
        stackView.isUserInteractionEnabled = true
        stackView.distribution = .fill
        
        return stackView
        
    }()
    
    
    private let placeTableView: UITableView = {
        let placeTableView = UITableView()
        placeTableView.translatesAutoresizingMaskIntoConstraints = false
        placeTableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        
        return placeTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var containerTopConstraint: NSLayoutConstraint!
    
    private func setupUI() {
        addSubview(mapView)
        addSubview(filterScrollView)
        addSubview(containerView)
        
        filterScrollView.addSubview(filterStackView)
        
        
        
        containerView.addSubview(dragIndicatorView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(placeTableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            
            filterScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 48),
            filterScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            filterScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 86),
            
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
            
        ])
        
        containerTopConstraint = containerView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16)
        containerTopConstraint.isActive = true
        
        NSLayoutConstraint.activate(([
            dragIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            dragIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: 80),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 4),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: dragIndicatorView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            
            placeTableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            placeTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            placeTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            placeTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
        ]))
        
    }
    
    func configurePlaceTableView(_ delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        placeTableView.delegate = delegate
        placeTableView.dataSource = dataSource
        
    }
    
    
    func updateFilterButtons(with categories: [Category], action: @escaping (Category) -> Void) {
        let categoryIcons: [String: String] = [
            "Alimentação": "fork.knife",
            "Compras": "cart",
            "Hospedagem": "bed.double",
            "Padria": "cup.and.saucer",
        ]
        
        
        self.categories = categories
        self.filterButtonAction = action
        
        
        for (index, category) in categories.enumerated() {
            let iconName = categoryIcons[category.name] ?? "questionmark.circle"
            let button = createFilterButton(title: category.name, iconName: iconName)
            button.tag = index
            button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
        }
    }
    
    private func createFilterButton(title: String, iconName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = Colors.gray100
        button.backgroundColor = Colors.gray600
        button.setTitleColor(Colors.gray600, for: .normal)
        button.titleLabel?.font = Typography.textSM
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 13).isActive = true
        button.imageView?.widthAnchor.constraint(equalToConstant: 13).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        filterStackView.isLayoutMarginsRelativeArrangement = true
        filterStackView.layoutMargins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        
        return button
    }
    
    private func updateButtonSelection(button: UIButton) {
         if let previousButton = selectedButton {
             previousButton.backgroundColor = Colors.gray100
             previousButton.setTitleColor(Colors.gray600, for: .normal)
             previousButton.tintColor = Colors.gray600
             previousButton.layer.borderWidth = 1
             previousButton.layer.borderColor = Colors.gray300.cgColor
         }
         
         button.backgroundColor = Colors.greenBase
         button.setTitleColor(Colors.gray100, for: .normal)
         button.tintColor = Colors.gray100
         button.layer.borderWidth = 0
         
         selectedButton = button
     }
     
     @objc
     private func filterButtonTapped(_ sender: UIButton) {
         let selectedCategory = categories[sender.tag]
         updateButtonSelection(button: sender)
         filterButtonAction?(selectedCategory)
     }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.placeTableView.reloadData()
        }
    }
}
