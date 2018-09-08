//
//  ViewControllerNavigation.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-08.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
}

protocol ViewControllerNavigation {
    static var Storyboard: Storyboard { get }
    static var ID: String { get }
}

extension ViewControllerNavigation {
    static func instantiate() -> Self {
        return UIStoryboard(name: Self.Storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: ID) as! Self
    }
}
