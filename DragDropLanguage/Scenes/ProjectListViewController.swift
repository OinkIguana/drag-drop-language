//
//  ProjectListViewController.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-07.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

import UIKit

class ProjectListViewController: UIViewController {
    @IBOutlet weak var projectsCollectionView: UICollectionView!
}

// MARK: - Lifecycle

extension ProjectListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let fnMain = Function(
            name: "main",
            type: FunctionType(input: .primitive(.int), output: .primitive(.int)),
            source: .script(Script(source: "return input + 3"))
        )

        let rootModule = Module(
            name: "main",
            types: [],
            functions: [fnMain],
            submodules: []
        )

        let project = Project(
            name: "Tests",
            lastModified: Date(),
            packages: [],
            rootModule: rootModule,
            initialValue: .value(.int(4))
        )

        Runtime.run(project: project)
    }
}
