//
//  ProfileHelpers.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 21.11.2026.
//
import UIKit

struct ProfileDisplayData {
    let name: String
    let loginName: String
    let bio: String
}

enum ProfileDisplayHelper {
    static func makeDisplayData(from profile: Profile) -> ProfileDisplayData {
        ProfileDisplayData(
            name: profile.name.isEmpty ? "Имя не указано" : profile.name,
            loginName: profile.loginName.isEmpty ? "@неизвестный_пользователь" : profile.loginName,
            bio: (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : (profile.bio ?? "")
        )
    }
}

final class ProfileShimmerHelper {
    private var shimmerViews: [GradientAnimationView] = []

    func show(on targets: [(view: UIView, cornerRadius: CGFloat)]) {
        hide()

        for item in targets {
            let shimmer = GradientAnimationView()
            shimmer.translatesAutoresizingMaskIntoConstraints = false
            shimmer.layer.cornerRadius = item.cornerRadius
            shimmer.clipsToBounds = true

            item.view.addSubview(shimmer)

            NSLayoutConstraint.activate([
                shimmer.topAnchor.constraint(equalTo: item.view.topAnchor),
                shimmer.bottomAnchor.constraint(equalTo: item.view.bottomAnchor),
                shimmer.leadingAnchor.constraint(equalTo: item.view.leadingAnchor),
                shimmer.trailingAnchor.constraint(equalTo: item.view.trailingAnchor)
            ])

            shimmer.startAnimating()
            shimmerViews.append(shimmer)
        }
    }

    func hide() {
        shimmerViews.forEach { shimmer in
            shimmer.stopAnimating()
            shimmer.removeFromSuperview()
        }
        shimmerViews.removeAll()
    }
}
