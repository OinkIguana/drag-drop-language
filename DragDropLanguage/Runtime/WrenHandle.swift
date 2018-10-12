//
//  WrenHandle.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-24.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

class WrenHandle {
    private unowned var vm: WrenVM
    let handle: OpaquePointer

    init(vm: WrenVM, slot: Int32) {
        self.vm = vm
        handle = wrenGetSlotHandle(vm.vm, slot)
    }

    init(vm: WrenVM, call name: String, argc: Int = 0) {
        self.vm = vm

        let params = Array(repeating: "_", count: argc).joined(separator: ",")
        let signature = "\(name)(\(params))"
        handle = wrenMakeCallHandle(vm.vm, signature)
    }

    init(vm: WrenVM, module: String? = nil, variable: String) {
        self.vm = vm

        wrenGetVariable(vm.vm, module ?? "main", variable, 0)
        handle = wrenGetSlotHandle(vm.vm, 0)
    }

    deinit {
        wrenReleaseHandle(vm.vm, handle)
    }
}
