// https://www.youtube.com/watch?v=p6GA8ODlnX0

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start up the camera
        let captureSesion = AVCaptureSession()
        captureSesion.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSesion.addInput(input)
        
        captureSesion.startRunning()
        
        
        // add what the camera sees
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSesion)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        // acces to camera frame layer
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
        captureSesion.addOutput(dataOutput)

//        VNImageRequestHandler(ciImage: <#T##CIImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("camera was able to capture a frame: ", Date())
        
        guard let pixelbuffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedRequest, err) in
            // perhaps take care of the err
//            print(finishedRequest.results)
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            print(firstObservation.identifier, firstObservation.confidence)
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelbuffer, options: [:]).perform([request])

    }
}

