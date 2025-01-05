//
//  WelcomeView.swift
//  NLW IOS
//
//  Created by Juan Carlos on 11/12/24.
//

import Foundation
import UIKit

class WelcomeView: UIView {
    var didTapButton: (() -> Void)?
    
    private let logoImageview: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView

    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Boas vindas ao Nearby!"
        label.font = Typography.titleXL
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text =
            "Tenha cupons de vantagem para usar em seus estabelicmentos favoritos."
        label.font = Typography.textMD
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
  
        return label
    }()
    
    private let SubTexForTips: UILabel = {
        let label = UILabel()
        label.text = "Veja como funciona."
        label.font = Typography.textMD
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tipsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Começar", for: .normal)
        button.backgroundColor = Colors.greenBase
        button.setTitleColor(Colors.gray100, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Typography.action
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }

    private func setupUI() {
        setupTips()
        addSubview(logoImageview)
        addSubview(welcomeLabel)
        addSubview(descriptionLabel)
        addSubview(tipsStackView)
        addSubview(SubTexForTips)
        addSubview(startButton)
        
        setupContraints()
    }

    private func setupContraints() {
        NSLayoutConstraint.activate([
            logoImageview.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            logoImageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            logoImageview.widthAnchor.constraint(equalToConstant: 48),
            logoImageview.widthAnchor.constraint(equalToConstant: 48),
            
            welcomeLabel.topAnchor.constraint(equalTo: logoImageview.bottomAnchor, constant: 8),
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            SubTexForTips.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            SubTexForTips.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            tipsStackView.topAnchor.constraint(equalTo: SubTexForTips.bottomAnchor, constant: 24),
            tipsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            tipsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            startButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            startButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])

    }
    
    @objc
    private func didTap(){
        didTapButton?()
    }
    
    private func setupTips() {
        guard let icon1 = UIImage(named: "mapIcon") else { return }
        let tip1 = TipsView(
            icon: icon1,
            title: "Encontre estabelecimento",
            description: "Veja locais perto de você que são parceiros Nearby"
        )

        let tip2 = TipsView(
            icon: UIImage(named: "qrcode") ?? UIImage(),
            title: "Ative o cupom com QR Code",
            description:
                "Escaneie o código no estabelecimento para usar o benefício")
        
        let tip3 = TipsView(
            icon: UIImage(named: "ticket") ?? UIImage(),
            title: "Garanta vantagens perto de você",
            description:
                "Ative cupons onde estiver, em diferentes tipos de estabelecimento")
        
        
        tipsStackView.addArrangedSubview(tip1)
        tipsStackView.addArrangedSubview(tip2)
        tipsStackView.addArrangedSubview(tip3)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
