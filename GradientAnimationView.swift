//
//  GradientAnimationView.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 04.11.2026.
//

import UIKit

final class GradientAnimationView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Гарантируем, что frame градиента строго совпадает с размером UIView
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        // Серые цвета для шиммера
        gradientLayer.colors = [
            UIColor(white: 0.2, alpha: 0.8).cgColor,
            UIColor(white: 0.4, alpha: 0.8).cgColor,
            UIColor(white: 0.2, alpha: 0.8).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.addSublayer(gradientLayer)
    }
    
    func startAnimating() {
        gradientLayer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }
}
