//
//  WrenVM.swift
//  DragDropLanguage
//
//  Created by Cameron Eldridge on 2018-09-24.
//  Copyright © 2018 Cameron Eldridge. All rights reserved.
//

struct WrenCompileError: Error {}
struct WrenRuntimeError: Error {}

class WrenVM {
    let vm: OpaquePointer
    var handles: [WrenHandle] = []

    init() {
        var config = WrenConfiguration()
        wrenInitConfiguration(&config)
        vm = wrenNewVM(&config)
    }

    deinit {
        handles = [] // drop all the handles to run their deinits
        wrenFreeVM(vm)
    }
}

extension WrenVM {
    func interpret(module: String? = nil, _ source: String) throws {
        switch wrenInterpret(vm, module ?? "main", source) {
        case WREN_RESULT_COMPILE_ERROR:
            throw WrenCompileError()
        case WREN_RESULT_RUNTIME_ERROR:
            throw WrenRuntimeError()
        default: break
        }
    }

    func call(_ receiver: WrenHandle, _ name: String, args: [WrenValue] = []) throws -> WrenValue {
        wrenEnsureSlots(vm, Int32(args.count + 1))
        let handle = WrenHandle(vm: self, call: name, argc: args.count)
        wrenSetSlotHandle(vm, 0, receiver.handle)
        for (index, value) in args.enumerated() {
            setSlot(Int32(index + 1), value: value)
        }
        switch wrenCall(vm, handle.handle) {
        case WREN_RESULT_SUCCESS:
            return retrieveSlot(0)
        case WREN_RESULT_RUNTIME_ERROR:
            throw WrenRuntimeError()
        default: fatalError("Unreachable")
        }
    }

    func variable(module: String? = nil, name: String) -> WrenHandle {
        wrenEnsureSlots(vm, 1)
        return WrenHandle(vm: self, module: module ?? "main", variable: name)
    }

    func setSlot(_ index: Int32, value: WrenValue) {
        wrenEnsureSlots(vm, index + 1)
        switch value {
        case .bool(let bool): wrenSetSlotBool(vm, index, bool)
        case .double(let double): wrenSetSlotDouble(vm, index, double)
        case .int(let int): wrenSetSlotDouble(vm, index, Double(int))
        case .string(let string): wrenSetSlotString(vm, index, string)
        case .handle(let handle):
            wrenSetSlotHandle(vm, index, handle.handle)
        case .list(let list):
            wrenEnsureSlots(vm, index + 2)
            wrenSetSlotNewList(vm, index)
            list.enumerated().forEach { (i, element) in
                setSlot(index + 1, value: element)
                wrenInsertInList(vm, index, Int32(i), index + 1)
            }
        case .foreign: fatalError("Unimplemented")
        case .null: wrenSetSlotNull(vm, index)
        }
    }

    func retrieveSlot(_ index: Int32) -> WrenValue {
        switch wrenGetSlotType(vm, index) {
        case WREN_TYPE_NUM:
            return .double(wrenGetSlotDouble(vm, index))
        case WREN_TYPE_BOOL:
            return .bool(wrenGetSlotBool(vm, index))
        case WREN_TYPE_STRING:
            return .string(String(cString: wrenGetSlotString(vm, index)))
        case WREN_TYPE_LIST:
            let count = wrenGetSlotCount(vm)
            wrenEnsureSlots(vm, count + 1)
            let length = wrenGetListCount(vm, index)
            return .list((0...length).map {
                wrenGetListElement(vm, index, $0, count)
                return retrieveSlot(count)
            })
        case WREN_TYPE_FOREIGN:
            fatalError("Unimplemented")
        case WREN_TYPE_NULL:
            return .null
        default:
            return .handle(WrenHandle(vm: self, slot: index))
        }
    }
}
