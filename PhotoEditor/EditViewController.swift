import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var image: UIImage!
    var ciImage = CIImage()
    
    var brightness: Float! = 0
    var saturation: Float! = 1
    var contrast: Float! = 1
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var BrightnessValue: UILabel!
    @IBOutlet weak var SaturationValue: UILabel!
    @IBOutlet weak var ContrastValue: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Image.image = image
        ciImage = CIImage(cgImage: (image?.cgImage)!)
    }

    @IBAction func SaveButtonClick(_ sender: Any) {
        let imageData = Image.image!.jpegData(compressionQuality: 0.6)
        let compressedJPGImage = UIImage(data: imageData!)!
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
    }
    
    
    @IBAction func BrightnessChange(_ sender: UISlider) {
        brightness = round(sender.value * 100) / 100.0
        BrightnessValue.text = String(brightness)
        
        let filteredImage = applyFilters(image: ciImage, brightness: brightness, saturation: saturation, contrast: contrast)
        Image.image = filteredImage
    }
    
    @IBAction func SaturationChange(_ sender: UISlider) {
        saturation = round(sender.value * 100) / 100.0
        SaturationValue.text = String(saturation)
        
        let filteredImage = applyFilters(image: ciImage, brightness: brightness, saturation: saturation, contrast: contrast)
        Image.image = filteredImage
    }
    
    @IBAction func ContrastChange(_ sender: UISlider) {
        contrast = round(sender.value * 100) / 100.0
        ContrastValue.text = String(contrast)
        
        let filteredImage = applyFilters(image: ciImage, brightness: brightness, saturation: saturation, contrast: contrast)
        Image.image = filteredImage
    }
    
    func applyFilters(image: CIImage, brightness: Float, saturation: Float, contrast: Float) -> UIImage? {
        let brightnessFilter = CIFilter(name: "CIColorControls")!
        brightnessFilter.setValue(image, forKey: kCIInputImageKey)
        brightnessFilter.setValue(brightness, forKey: kCIInputBrightnessKey)
        guard let brightnessOutput = brightnessFilter.outputImage else { return nil }
        
        let saturationFilter = CIFilter(name: "CIColorControls")!
        saturationFilter.setValue(brightnessOutput, forKey: kCIInputImageKey)
        saturationFilter.setValue(saturation, forKey: kCIInputSaturationKey)
        guard let saturationOutput = saturationFilter.outputImage else { return nil }
        
        let contrastFilter = CIFilter(name: "CIColorControls")!
        contrastFilter.setValue(saturationOutput, forKey: kCIInputImageKey)
        contrastFilter.setValue(contrast, forKey: kCIInputContrastKey)
        guard let contrastOutput = contrastFilter.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(contrastOutput, from: contrastOutput.extent) else { return nil }
        let processedImage = UIImage(cgImage: cgImage)
        
        return processedImage
    }
}
