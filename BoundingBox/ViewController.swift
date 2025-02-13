//
//  ViewController.swift
//  BoundingBox
//
//  Created by Atik Hasan on 2/13/25.
//

import UIKit

class ViewController: UIViewController {
    
    var selectionView: UIView?
    var dashedBorder: CAShapeLayer?
    var startPoint: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add image in background
        let imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "MyImage")
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        // Add pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        imageView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)

    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        selectionView?.removeFromSuperview()                 /// Remove older View
        selectionView = nil
    }

    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        print("location : ", location.x)
        switch gesture.state {
        case .began:
            /// Remove older View
            selectionView?.removeFromSuperview()
            
            /// Create New View
            startPoint = location
            let selectionView = UIView(frame: CGRect(x: startPoint.x, y: startPoint.y, width: 0, height: 0))
            selectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            view.addSubview(selectionView)
            self.selectionView = selectionView
            addDashedBorder(to: selectionView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            selectionView.addGestureRecognizer(tapGesture)
            
        case .changed:
            let width = location.x - startPoint.x
            let height = location.y - startPoint.y
            selectionView?.frame = CGRect(x: startPoint.x, y: startPoint.y, width: width, height: height)
            updateDashedBorder()
            
        case .ended, .cancelled:
            addBlurEffectToSelectionView()
            
        default:
            break
        }
    }
    
    /// Add Blur Effect
    func addBlurEffectToSelectionView() {
        guard let selectionView = selectionView else { return }
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = selectionView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectionView.addSubview(blurView)
    }
    
    ///Border Style
    func addDashedBorder(to view: UIView) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.green.cgColor
        borderLayer.lineDashPattern = [6, 4]
        borderLayer.fillColor = nil
        borderLayer.lineWidth = 2
        view.layer.addSublayer(borderLayer)
        
        dashedBorder = borderLayer
        updateDashedBorder()
    }
    
    func updateDashedBorder() {
        guard let selectionView = selectionView, let dashedBorder = dashedBorder else { return }
        let path = UIBezierPath(rect: selectionView.bounds)
        dashedBorder.path = path.cgPath
        dashedBorder.frame = selectionView.bounds
    }

}
