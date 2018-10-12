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

        let inputNode = NodeID()
        let outputNode = NodeID()
        let plusNode = NodeID()
        let threeNode = NodeID()
        let structNode = NodeID()

        let fnMain = Function(
            name: "main",
            type: FunctionType(input: .primitive(.int), output: .primitive(.int)),
            source: .program(Program(
                nodes: [
                    Node(id: inputNode, kind: .input),
                    Node(id: outputNode, kind: .output),
                    Node(id: threeNode, kind: .constant(.int(3))),
                    Node(id: structNode, kind: .construct(Construct(definition: Definition(
                        package: "std",
                        modulePath: ["Math"],
                        name: "Operation"
                    )))),
                    Node(id: plusNode, kind: .function(FunctionCall(definition: Definition(
                        package: "std",
                        modulePath: ["Math"],
                        name: "+"
                    ))))
                ],
                edges: [
                    Edge(input: .node(inputNode), output: .construct(node: structNode, field: 0)),
                    Edge(input: .node(threeNode), output: .construct(node: structNode, field: 1)),
                    Edge(input: .node(structNode), output: .node(plusNode)),
                    Edge(input: .node(plusNode), output: .node(outputNode)),
                ]
            ))
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
            packages: [stdlib],
            rootModule: rootModule,
            initialValue: .value(.int(4))
        )

        Runtime.run(project: project)
    }
}
