//
//  List.swift
//  NordPool
//
//  Created by Arturs Cirsis on 16/09/2022.
//
import Introspect
import SwiftUI

class InvisibleScroller: NSScroller {
    
    override class var isCompatibleWithOverlayScrollers: Bool {
        return true
    }
    
    override class func scrollerWidth(for controlSize: NSControl.ControlSize, scrollerStyle: NSScroller.Style) -> CGFloat {
        return CGFloat.leastNormalMagnitude // Dimension of scroller is equal to `FLT_MIN`
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Below assignments not really needed, but why not.
        scrollerStyle = .overlay
        alphaValue = 0
    }
}

extension List {
    //    List on macOS uses an opaque background with no option for
    //    removing/changing it. listRowBackground() doesn't work either.
    //    This workaround works because List is backed by NSTableView.
    //    https://github.com/siteline/SwiftUI-Introspect
    func removeBackground() -> some View {
        return introspectTableView { tableView in
            tableView.backgroundColor = .clear
            tableView.enclosingScrollView!.drawsBackground = false
            //            tableView.enclosingScrollView!.horizontalScrollElasticity = .none
            //            tableView.enclosingScrollView!.verticalScrollElasticity = .none
            //            tableView.enclosingScrollView!.automaticallyAdjustsContentInsets = false
            tableView.enclosingScrollView!.horizontalScroller = InvisibleScroller()
            tableView.enclosingScrollView!.verticalScroller = InvisibleScroller()
        }
    }
}
