//
//  TabBarController.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 3/12/24.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage.trackersTabBarIcon,
                                                         selectedImage: nil)

        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                           image: UIImage.statisticsTabBarIcon,
                                                           selectedImage: nil)

        self.viewControllers = [trackersViewController, statisticsViewController]
    }

}
