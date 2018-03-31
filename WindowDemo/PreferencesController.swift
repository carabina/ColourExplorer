import Cocoa

class globalSettings {
  
  static var defaultColor: NSColor {
    guard let objOrig  = UserDefaults.standard.data(forKey: PreferenceKeys.MainColorSettingName) else { return NSColor.gray }
    let extractedObj = NSKeyedUnarchiver.unarchiveObject(with: objOrig)
    return (extractedObj as? NSColor) ?? NSColor.yellow
    
  }
  
  static var animatedByDefault: Bool {
    return UserDefaults.standard.bool(forKey: PreferenceKeys.AnimateAtStartupSettingName)
  }

}

class PreferencesController: NSWindowController, NSWindowDelegate {
  
  @IBOutlet weak var picker: NSColorWell!
  @IBOutlet weak var animateOnStartup: NSButton!
  var animatedByDefault: Bool? = globalSettings.animatedByDefault
  
  override var windowNibName: NSNib.Name? { return NSNib.Name.PrefWindow }
  
  @IBOutlet weak var animationOffButton: NSButton!
  @IBOutlet weak var animationOnButton: NSButton!
  
  override func windowDidLoad() {
    
    if animatedByDefault == true {
      animationOnButton.state = .on
    } else {
      animationOffButton.state = .on
    }
    
    picker.color = globalSettings.defaultColor
    
  }

  
  private func grabAndSaveDefaults() {
    
    if animatedByDefault != globalSettings.animatedByDefault {
      UserDefaults.standard.set(animatedByDefault, forKey: PreferenceKeys.AnimateAtStartupSettingName)
    }
      
      let colorToSendToSettings = NSKeyedArchiver.archivedData(withRootObject: picker.color)
      UserDefaults.standard.set(colorToSendToSettings, forKey: PreferenceKeys.MainColorSettingName)

  }
  
  @IBAction func changedAnimationDefault(_ sender: NSButton) {
    if sender.title == "Enabled" {
      animatedByDefault = true
    } else {
      animatedByDefault = false
    }
  }
  
  
  @IBAction func newDefaultsSelected(_ sender: NSButton) {
    grabAndSaveDefaults()
    self.close()
  }
  
  @IBAction func cancelPreferences(_ sender: NSButton) {
    self.close()
  }
  
}

