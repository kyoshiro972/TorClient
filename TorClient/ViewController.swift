//
//  ViewController.swift
//  TorClient
//
//  Created by Hafizh on 13/06/18.
//  Copyright © 2018 Hafizh. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var LogTorText: NSTextField!
    
    @IBOutlet weak var SockTorLabel: NSTextField!
    
    @IBOutlet weak var StartBtn: NSButton!
    
    @IBOutlet weak var ProxyTorLabel: NSTextField!
    
    @IBOutlet weak var PortTorLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

    // MARK: - Task Utilities
    func runShellCommand(command: String) -> String? {
        let args: [String] = command.split { $0 == " " }.map(String.init)
        let other = args[1..<args.count]
        let outputPipe = Pipe()
        let task = Process()
        task.launchPath = args[0]
        task.arguments = other.map { $0 }
        task.standardOutput = outputPipe
        task.launch()
        task.waitUntilExit()
        
        guard task.terminationStatus == 0 else { return nil }
        
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return String(data:outputData, encoding: String.Encoding.utf8)
    }
    
    // MARK: - File System Utilities
    func fileExists(filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    func mkdir(path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - String Utilities
    func trim(_ s: String) -> String {
        return ((s as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String)
    }
    
    func trim(_ s: String?) -> String? {
        return (s == nil) ? nil : (trim(s!) as String)
    }
    
    func reportError(message: String) -> Never {
        print("ERROR: \(message)")
        exit(1)
    }

    
    func cmd(_ args: String...)-> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        
        return task.terminationStatus
    }
    var BtnIsOn = false
    @IBAction func StartBtnPressed(_ sender: NSButton) {
        if BtnIsOn == false{
            BtnIsOn = true
            SockTorLabel.isEnabled = false
            ProxyTorLabel.isEnabled = false
            PortTorLabel.isEnabled = false
            print("Tor start at 9050")
            StartBtn.title = "Stop"
            
            cmd("uname", "-a")
            cmd("ls", "-l")
           // cmd("sudo /Users/hafizh/Desktop/Tor/tor.real")
        
        }else{
            SockTorLabel.isEnabled = true
            ProxyTorLabel.isEnabled = true
            PortTorLabel.isEnabled = true
            BtnIsOn = false
            StartBtn.title = "Start"
            print("Tor is stop")
            print("Close port 9050")
        }
    }
    
    @IBAction func NStextFieldAction(_ sender: NSTextField) {
    }
    
    
}

