//
//  AppDelegate.swift
//  AMate
//
//  Created by patrick on 2/12/17.
//  Copyright © 2017 patrickbdev. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var window: NSWindow!
    private let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    private let menuLogoLarge = NSImage(named:NSImage.Name("MenuLogoLarge"))
    private let menuLogoSmall = NSImage(named:NSImage.Name("MenuLogoSmall"))
    private let menu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        return menu
    }()
    private var shiftHeld = false {
        didSet {
            if let button = statusItem.button {
                button.image = shiftHeld ? menuLogoLarge : menuLogoSmall
            }
        }
    }
    fileprivate var optionHeld = false {
        didSet {
            statusItem.menu = optionHeld ? menu : nil
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        menu.delegate = self
        
        if let button = statusItem.button {
            button.image = menuLogoSmall
            button.action = #selector(statusBarTapped(_:))
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.flagsChanged) { (theEvent) -> Void in
            self.shiftHeld = theEvent.modifierFlags.contains(.shift)
            self.optionHeld = theEvent.modifierFlags.contains(.option)
        }
    }
    
    @objc private func statusBarTapped(_ sender: Any?) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        let text: NSString = shiftHeld ? "A" : "a"
        pasteBoard.writeObjects([text])
    }
    
    func menuDidClose(_ menu: NSMenu) {
        optionHeld = false
    }
}

