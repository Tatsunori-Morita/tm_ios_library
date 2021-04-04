//
//  TestPhotoPickerConfig.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/02/21.
//

import Foundation
import Photos

public enum TestSelectMode {
    case multiple
    case single
}

public enum TestMediaType {
    case image
    case video
    case unsupported
    
    public func value() -> Int {
        switch self {
        case .image:
            return PHAssetMediaType.image.rawValue
        case .video:
            return PHAssetMediaType.video.rawValue
        case .unsupported:
            return PHAssetMediaType.unknown.rawValue
        }
    }
    
    init(withPHAssetMediaType type: PHAssetMediaType) {
        switch type {
        case .image:
            self = .image
        case .video:
            self = .video
        default:
            self = .unsupported
        }
    }
}

public struct TestPhotoPickerConfig {
    public var mediaTypes: [TestMediaType] = [.image]
    public var selectMode: TestSelectMode = .multiple
    public var maxImage: Int = 5
//    public var maxVideo: Int = 10
//    public var availableFilters: [FMFilterable]? = kDefaultAvailableFilters
//    public var availableCrops: [FMCroppable]? = kDefaultAvailableCrops
//    public var useCropFirst: Bool = false
//    public var alertController: FMAlertable = FMAlert()

    /// Whether you want FMPhotoPicker returns PHAsset instead of UIImage.
//    public var shouldReturnAsset: Bool = false
//
//    public var forceCropEnabled = false
//    public var eclipsePreviewEnabled = false
//
//    public var titleFontSize: CGFloat = 17
//    
//    public var strings: [String: String] = [
//        "picker_button_cancel":                     "Cancel",
//        "picker_button_select_done":                "Done",
//        "picker_warning_over_image_select_format":  "You can select maximum %d images",
//        "picker_warning_over_video_select_format":  "You can select maximum %d videos",
//
//        "present_title_photo_created_date_format":  "yyyy/M/d",
//        "present_button_back":                      "Back",
//        "present_button_edit_image":                "Edit",
//
//        "editor_button_cancel":                     "Cancel",
//        "editor_button_done":                       "Done",
//        "editor_menu_filter":                       "Filter",
//        "editor_menu_crop":                         "Crop",
//        "editor_menu_crop_button_reset":            "Reset",
//        "editor_menu_crop_button_rotate":           "Rotate",
//
//        "editor_crop_ratio4x3":                     "4:3",
//        "editor_crop_ratio16x9":                    "16:9",
//        "editor_crop_ratio9x16":                    "9x16",
//        "editor_crop_ratioCustom":                  "Custom",
//        "editor_crop_ratioOrigin":                  "Origin",
//        "editor_crop_ratioSquare":                  "Square",
//
//        "permission_dialog_title":                  "FMPhotoPicker",
//        "permission_dialog_message":                "FMPhotoPicker wants to access Photo Library",
//        "permission_button_ok":                     "OK",
//        "permission_button_cancel":                 "Cancel"
//    ]
    
    public init() {
        
    }
}
