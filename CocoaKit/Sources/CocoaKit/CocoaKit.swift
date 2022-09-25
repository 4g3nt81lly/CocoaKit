import Cocoa
import UniformTypeIdentifiers

public protocol Omnipotent : Introspective, LoopProtection {
    
}

@objcMembers
public final class Core : NSObject, Omnipotent {
    
    public var global: Global
    
    public dynamic var appDelegate: NSApplicationDelegate?
    
    public var bundle: Bundle
    
    public var mainStoryboard: NSStoryboard?
    
    public var userDefaults: UserDefaultsManager
    
    public var fileManager = FileManager.default
    
    public var workspace = NSWorkspace.shared
    
    public var notificationCenter = NotificationCenter.default

    @discardableResult
    public func alert(title: String, description: String, buttons: [String] = ["OK"], style: NSAlert.Style = .warning,
                      suppressionTitle: String? = nil) -> NSAlert {
        
        let alert = NSAlert()
        
        alert.alertStyle = style
        alert.messageText = title
        alert.informativeText = description
        
        for title in buttons {
            alert.addButton(withTitle: title)
        }
        
        if let checkboxTitle = suppressionTitle,
           let suppressionButton = alert.suppressionButton {
            suppressionButton.title = checkboxTitle
            alert.showsSuppressionButton = true
        }
        
        return alert
    }
    
    @discardableResult
    public func showModalAlert(title: String, description: String, buttons: [String] = ["OK"],
                               style: NSAlert.Style = .warning, alertMovable: Bool = true,
                               suppressionTitle: String? = nil, suppressionKey defaultsKey: String? = nil,
                               completionHandler: ((NSApplication.ModalResponse) -> Void)? = nil) -> NSApplication.ModalResponse? {
        
        let alert = self.alert(title: title, description: description, buttons: buttons,
                               style: style, suppressionTitle: suppressionTitle)
        
        alert.window.isMovable = alertMovable
        alert.window.isMovableByWindowBackground = alertMovable
        
        let response = alert.runModal()
        
        defer {
            if alert.suppressionButton?.state == .on, let key = defaultsKey {
                self.userDefaults.set(true, forKey: key)
            }
        }
        
        if let handler = completionHandler {
            handler(response)
            return nil
        }
        
        return response
    }
    
    public func showSheetAlert(inWindow window: NSWindow, title: String, description: String, buttons: [String] = ["OK"], style: NSAlert.Style = .warning, suppressionTitle: String? = nil, suppressionKey defaultsKey: String? = nil, completionHandler: ((NSApplication.ModalResponse) -> Void)? = nil) {
        
        let alert = self.alert(title: title, description: description, buttons: buttons,
                               style: style, suppressionTitle: suppressionTitle)
        
        alert.beginSheetModal(for: window) { response in
            if alert.suppressionButton?.state == .on, let key = defaultsKey {
                self.userDefaults.set(true, forKey: key)
            }
            completionHandler?(response)
        }
    }
    
    @available(macOS 11.0, *)
    func openPanel(withTitle title: String, allowedTypes: [UTType]? = nil,
                   showsHiddenFiles: Bool = false, showsResizeIndicator: Bool = true, showsToolbarButton: Bool = true, showsTagField: Bool = true,
                   canChooseFiles: Bool = true, canChooseDiretories: Bool = false, canCreateDirectories: Bool = true,
                   multipleSelection: Bool = false,
                   accessoryView: NSView? = nil, showAccessoryView: Bool = true) -> NSOpenPanel {
        
        let fileBrowser = NSOpenPanel()
        
        fileBrowser.title = title
        
        fileBrowser.showsHiddenFiles = showsHiddenFiles
        fileBrowser.showsResizeIndicator = showsResizeIndicator
        
        fileBrowser.canChooseFiles = canChooseFiles
        fileBrowser.canChooseDirectories = canChooseDiretories
        fileBrowser.canCreateDirectories = canCreateDirectories
        
        fileBrowser.allowsMultipleSelection = multipleSelection
        
        fileBrowser.showsToolbarButton = showsToolbarButton
        fileBrowser.showsTagField = showsTagField
        
        if let fileTypes = allowedTypes {
            fileBrowser.allowedContentTypes = fileTypes
        }
        if let view = accessoryView {
            fileBrowser.accessoryView = view
            fileBrowser.isAccessoryViewDisclosed = showAccessoryView
        }
        return fileBrowser
    }
    
    @available(macOS, deprecated: 12.0, renamed: "openPanel(withTitle:allowedTypes:showsHiddenFiles:showsResizeIndicator:showsToolbarButton:showsTagField:canChooseFiles:canChooseDirectories:canCreateDirectories:multipleSelection:accessoryView:showAccessoryView:)")
    func openPanel(withTitle title: String, allowedFileTypes: [String]? = nil,
                   showsHiddenFiles: Bool = false, showsResizeIndicator: Bool = true, showsToolbarButton: Bool = true, showsTagField: Bool = true,
                   canChooseFiles: Bool = true, canChooseDiretories: Bool = false, canCreateDirectories: Bool = true,
                   multipleSelection: Bool = false,
                   accessoryView: NSView? = nil, showAccessoryView: Bool = true) -> NSOpenPanel {
        
        let fileBrowser = NSOpenPanel()
        
        fileBrowser.title = title
        
        fileBrowser.showsHiddenFiles = showsHiddenFiles
        fileBrowser.showsResizeIndicator = showsResizeIndicator
        
        fileBrowser.canChooseFiles = canChooseFiles
        fileBrowser.canChooseDirectories = canChooseDiretories
        fileBrowser.canCreateDirectories = canCreateDirectories
        
        fileBrowser.allowsMultipleSelection = multipleSelection
        
        fileBrowser.showsToolbarButton = showsToolbarButton
        fileBrowser.showsTagField = showsTagField
        
        if let fileTypes = allowedFileTypes {
            fileBrowser.allowedFileTypes = fileTypes
        }
        if let view = accessoryView {
            fileBrowser.accessoryView = view
            fileBrowser.isAccessoryViewDisclosed = showAccessoryView
        }
        return fileBrowser
    }
    
    @available(macOS 11.0, *)
    public func savePanel(title: String, message: String,
                          nameFieldLabel nameLabel: String? = nil, defaultName: String = "Untitled",
                          accessoryView view: NSView? = nil,
                          allowedTypes fileTypes: [UTType] = [],
                          showsHiddenFiles: Bool = false, showsResizeIndicator: Bool = false,
                          canCreateDirectories: Bool = true, canSelectHiddenExtension: Bool = true,
                          showsToolbarButton: Bool = true, showsTagField: Bool = true) -> NSSavePanel {
        
        let panel = NSSavePanel()
        
        panel.title = title
        panel.message = message
        
        if let label = nameLabel {
            panel.nameFieldLabel = label
        }
        panel.nameFieldStringValue = defaultName
        
        panel.accessoryView = view
        
        panel.allowedContentTypes = fileTypes
        
        panel.showsHiddenFiles = showsHiddenFiles
        panel.showsResizeIndicator = showsResizeIndicator
        
        panel.canCreateDirectories = canCreateDirectories
        panel.canSelectHiddenExtension = canSelectHiddenExtension
        
        panel.showsToolbarButton = showsToolbarButton
        panel.showsTagField = showsTagField
        
        return panel
    }
    
    @available(macOS, deprecated: 12.0, renamed: "savePanel(title:message:nameFieldLabel:defaultName:accessoryView:allowedTypes:showsHiddenFiles:showsResizeIndicator:canCreateDirectories:canSelectHiddenExtension:showsToolbarButton:showsTagField:)")
    public func savePanel(title: String, message: String,
                          nameFieldLabel nameLabel: String? = nil, defaultName: String = "Untitled",
                          accessoryView view: NSView? = nil,
                          allowedFileTypes fileTypes: [String] = [],
                          showsHiddenFiles: Bool = false, showsResizeIndicator: Bool = false,
                          canCreateDirectories: Bool = true, canSelectHiddenExtension: Bool = true,
                          showsToolbarButton: Bool = true, showsTagField: Bool = true) -> NSSavePanel {
        
        let panel = NSSavePanel()
        
        panel.title = title
        panel.message = message
        
        if let label = nameLabel {
            panel.nameFieldLabel = label
        }
        panel.nameFieldStringValue = defaultName
        
        panel.accessoryView = view
        
        panel.allowedFileTypes = fileTypes
        
        panel.showsHiddenFiles = showsHiddenFiles
        panel.showsResizeIndicator = showsResizeIndicator
        
        panel.canCreateDirectories = canCreateDirectories
        panel.canSelectHiddenExtension = canSelectHiddenExtension
        
        panel.showsToolbarButton = showsToolbarButton
        panel.showsTagField = showsTagField
        
        return panel
    }
    
    public func mainThread(delay: DispatchTime = .now(), _ code: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: delay) {
            code()
        }
    }
    
    public init(global: Global = Global(),
                appDelegate: NSApplicationDelegate? = nil,
                bundle: Bundle = .main,
                storyboardName storyboard: NSStoryboard.Name? = nil,
                userDefaultsSuiteName: String? = nil) {
        self.global = global
        self.appDelegate = appDelegate
        self.bundle = bundle
        if let storyboardName = storyboard {
            self.mainStoryboard = NSStoryboard(name: storyboardName, bundle: bundle)
        }
        self.userDefaults = UserDefaultsManager(suiteName: userDefaultsSuiteName)
    }
    
}
