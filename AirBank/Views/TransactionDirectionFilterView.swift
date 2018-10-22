//
//  TransactionDirectionFilterView.swift
//  AirBank
//
//  Created by Tom Kraina on 22/10/2018.
//  Copyright © 2018 Tom Kraina. All rights reserved.
//

import UIKit

protocol TransactionDirectionFilterViewDelegate: AnyObject {
    func filter(view: TransactionDirectionFilterView, didSelectSegment: TransactionDirectionFilterView.Segment)
}

@IBDesignable
class TransactionDirectionFilterView: UIView {

    enum Segment: Int, CaseIterable {
        case all
        case incoming
        case outgoing
        
        var localizedText: String {
            switch self {
            case .all:
                return NSLocalizedString("filter.all", comment: "Title for filter setting 'all'.")
            case .incoming:
                return NSLocalizedString("filter.incoming", comment: "Title for filter setting 'incoming'.")
            case .outgoing:
                return NSLocalizedString("filter.outgoing", comment: "Title for filter setting 'outgoing'.")
            }
        }
    }
    
    var selectedSegment: Segment = .all {
        didSet {
            segmentedControl.selectedSegmentIndex = selectedSegment.rawValue
        }
    }
    
    weak var delegate: TransactionDirectionFilterViewDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    // MARK: - UIView lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupNib()
        
        segmentedControl.tintColor = Asset.airBankGreen.color
        
        segmentedControl.removeAllSegments()
        for item in Segment.allCases {
            segmentedControl.insertSegment(withTitle: item.localizedText, at: item.rawValue, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedSegment.rawValue
    }
    
    // MARK: - IBAction
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        guard let segment = Segment(rawValue: sender.selectedSegmentIndex) else {
            fatalError("Unexpected selectedSegmentIndex: \(sender.selectedSegmentIndex)")
        }
        
        selectedSegment = segment
        delegate?.filter(view: self, didSelectSegment: selectedSegment)
    }
}
