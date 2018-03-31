import Cocoa

class MainViewController: NSViewController, ColorViewDelegate, NSCollectionViewDelegate {
  
  @IBOutlet weak var solidColor: SolidColorView!
  @IBOutlet weak var previousColorChart: NSCollectionView!
  @IBOutlet weak var animationControl: NSSegmentedControl!
  
  private var goingBack = false
  private var backwardSteps = 0

  func viewDidGetNewColor(_ oldColor: NSColor) {
    if goingBack == false {
      activeDocument?.storedColors.append(oldColor)
      previousColorChart.reloadData()
    }
  }
  
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if globalSettings.animatedByDefault {
      animationControl.selectSegment(withTag: 1)
    } else {
      animationControl.selectSegment(withTag: 0)
    }
    
  }
  
  override func keyUp(with event: NSEvent) {
    if event.keyCode == 51 && previousColorChart.selectionIndexPaths.count == 1 {
      guard let itemToRemove = previousColorChart.selectionIndexPaths.first?.item else { return }
      activeDocument?.storedColors.remove(at: itemToRemove)
      previousColorChart.reloadData()
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
    
    (collectionView.item(at: indexPaths.first!)?.view as? ColorColletionViewItemSubview)?.isSelected = true
    
    goingBack = true
    solidColor.drawingFill = selectedColor
    
  }
  
  func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
    (collectionView.item(at: indexPaths.first!)?.view as? ColorColletionViewItemSubview)?.isSelected = false
  }
  
  func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
    return activeDocument?.storedColors[indexPath.item]
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    previousColorChart.reloadData()
  }
  
}
