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
    scrollView.showsVerticalScrollIndicator = false
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
    
    setupPanGesture()
    setupConstraints()
}

private func setupConstraints() {
    NSLayoutConstraint.activate([
        mapView.topAnchor.constraint(equalTo: topAnchor),
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
        mapView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
        
        filterScrollView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
        filterScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
        filterScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        filterScrollView.heightAnchor.constraint(equalTo: filterStackView.heightAnchor),
        
        
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
        
        filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
        filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor),
        filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor),
        filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
        
        filterStackView.heightAnchor.constraint(equalToConstant: 40)
        
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
        placeTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
        
    ]))
    
}

func configurePlaceTableView(_ delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
    placeTableView.delegate = delegate
    placeTableView.dataSource = dataSource
    
}

  func setupPanGesture() {
     let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
     containerView.addGestureRecognizer(panGesture)
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
            if category.name == "Alimentação"{
                updateButtonSelection(button: button)
            }
            filterStackView.addArrangedSubview(button)
        }
    
    
    }
                                                      
     private func createFilterButton(title: String, iconName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = Colors.gray600
        button.backgroundColor = Colors.gray100
        button.setTitleColor(Colors.gray600, for: .normal)
        button.titleLabel?.font = Typography.textSM
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 13).isActive = true
        button.imageView?.widthAnchor.constraint(equalToConstant: 13).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
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
                                                      
     @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .changed:
            let newConstant = containerTopConstraint.constant + translation.y
            if newConstant <= 0 && newConstant >= frame.height * 0.5 {
                containerTopConstraint.constant = newConstant
                gesture.setTranslation(.zero, in: self)
            }
        case .ended:
            let halfScreenHeight = -frame.height * 0.25
            let finalPosition: CGFloat
            
            if velocity.y > 0 {
                finalPosition = -16
            } else {
                finalPosition = halfScreenHeight
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.containerTopConstraint.constant = finalPosition
                self.layoutIfNeeded()
            })
            
        default:
            break
        }
    }
                                                      }
