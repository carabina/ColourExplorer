import Cocoa

class MainViewController: NSViewController, ColorViewDelegate, NSCollectionViewDelegate {
  
  @IBOutlet weak var solidColor: SolidColorView!
  @IBOutlet weak var previousColorChart: NSCollectionView!
  private(set) var previousColors = [NSColor]()
  private var goingBack = false
  private var backwardSteps = 0

  func viewDidGetNewColor(_ oldColor: NSColor) {
    if goingBack == false {
      activeDocument?.storedColors.append(oldColor)
      previousColorChart.reloadData()
    }
  }
  
  @IBOutlet weak var animationControl: NSSegmentedControl!
  
  override func viewDidLoad() {
    if globalSettings.animatedByDefault {
      animationControl.selectSegment(withTag: 1)
    } else {
      animationControl.selectSegment(withTag: 0)
    }
  }
  
  @IBAction func showRed(_ sender: NSButton) {
    solidColor.drawingFill = NSColor.red
  }
  
  @IBAction func showRandomColor(sender: NSButton) {
    goingBack = false
    backwardSteps = 0
    solidColor.drawingFill = NSColor.random()
  }
  
  @IBAction func showCustomColor(sender: NSButton) {
    let well = NSColorWell()
    well.action = #selector(customColorChosen(_:))
    well.activate(true)
    
  }
  
  @IBAction func DisplayModeSelected(_ sender: NSSegmentedControl) {
    if sender.selectedSegment == 1 {
      solidColor.animationEnabled = true
    } else {
      solidColor.animationEnabled = false
    }
  }
  
  
  @objc func customColorChosen(_ sender: NSColorWell) {
    solidColor.drawingFill = sender.color
  }
  
  @IBAction func showPreviousColor(sender: NSButton) {
    
    goingBack = true
    backwardSteps += 1
    
    let desiredIndex = (activeDocument?.storedColors.count)! - backwardSteps
    
    if desiredIndex < (activeDocument?.storedColors.count)! && desiredIndex >= 0 {
      solidColor.drawingFill = (activeDocument?.storedColors[desiredIndex])!
    }
    
  }
  
  func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    
    guard let selectedColor = collectionView.item(at: indexPaths.first!)?.representedObject as? NSColor else { return }
    
    goingBack = true
    solidColor.drawingFill = selectedColor
    
  }
  
  @IBAction func openPreferences(_ sender: NSMenuItem) {
    let prefs = PreferencesController()
    activeDocument?.windowForSheet?.beginSheet(prefs.window!, completionHandler: nil)
  }
  
  
}
