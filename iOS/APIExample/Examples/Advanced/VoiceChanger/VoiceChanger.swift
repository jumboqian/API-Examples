//
//  VoiceChanger.swift
//  APIExample
//
//  Created by 张乾泽 on 2020/7/24.
//  Copyright © 2020 Agora Corp. All rights reserved.
//

import Foundation
import UIKit
import AgoraRtcKit
import AGEVideoLayout


class VoiceChangerEntry : UIViewController
{
    @IBOutlet weak var joinButton: AGButton!
    @IBOutlet weak var channelTextField: AGTextField!
    let identifier = "VoiceChanger"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doJoinPressed(sender: AGButton) {
        guard let channelName = channelTextField.text else {return}
        //resign channel text field
        channelTextField.resignFirstResponder()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: identifier, bundle: nil)
        // create new view controller every time to ensure we get a clean vc
        guard let newViewController = storyBoard.instantiateViewController(withIdentifier: identifier) as? BaseViewController else {return}
        newViewController.title = channelName
        newViewController.configs = ["channelName":channelName]
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}

class VoiceChangerMain: BaseViewController {
    var agoraKit: AgoraRtcEngineKit!
    @IBOutlet weak var chatBeautifierBtn: UIButton!
    @IBOutlet weak var timbreTransformationBtn: UIButton!
    @IBOutlet weak var voiceChangerBtn: UIButton!
    @IBOutlet weak var styleTransformationBtn: UIButton!
    @IBOutlet weak var roomAcousticsBtn: UIButton!
    @IBOutlet weak var equalizationFreqBtn: UIButton!
    @IBOutlet weak var reverbKeyBtn: UIButton!
    @IBOutlet weak var reverbValueSlider: UISlider!
    @IBOutlet weak var container: AGEVideoContainer!
    var audioViews: [UInt:VideoView] = [:]
    var equalizationFreq: AgoraAudioEqualizationBandFrequency = .band31
    var equalizationGain: Int = 0
    var reverbType: AgoraAudioReverbType = .dryLevel
    var reverbMap:[AgoraAudioReverbType:Int] = [
        .dryLevel:0,
        .wetLevel:0,
        .roomSize:0,
        .wetDelay:0,
        .strength:0
    ]
    
    // indicate if current instance has joined channel
    var isJoined: Bool = false
    
    func resetVoiceChanger() {
        chatBeautifierBtn.setTitle("Off", for: .normal)
        timbreTransformationBtn.setTitle("Off", for: .normal)
        voiceChangerBtn.setTitle("Off", for: .normal)
        styleTransformationBtn.setTitle("Off", for: .normal)
        roomAcousticsBtn.setTitle("Off", for: .normal)
    }
    
    func getChatBeautifierAction(_ chatBeautifier:AgoraAudioVoiceChanger) -> UIAlertAction{
        return UIAlertAction(title: "\(chatBeautifier.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceReverbPreset,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceChanger(chatBeautifier)
            self.chatBeautifierBtn.setTitle("\(chatBeautifier.description())", for: .normal)
        })
    }
    
    func getTimbreTransformationAction(_ timbreTransformation:AgoraAudioVoiceChanger) -> UIAlertAction{
        return UIAlertAction(title: "\(timbreTransformation.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceReverbPreset,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceChanger(timbreTransformation)
            self.timbreTransformationBtn.setTitle("\(timbreTransformation.description())", for: .normal)
        })
    }
    
    func getVoiceChangerAction(_ voiceChanger:AgoraAudioVoiceChanger) -> UIAlertAction{
        return UIAlertAction(title: "\(voiceChanger.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceReverbPreset,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceChanger(voiceChanger)
            self.voiceChangerBtn.setTitle("\(voiceChanger.description())", for: .normal)
        })
    }
    
    func getVoiceChangerAction(_ voiceChanger:AgoraAudioReverbPreset) -> UIAlertAction{
        return UIAlertAction(title: "\(voiceChanger.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceChanger,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceReverbPreset(voiceChanger)
            self.voiceChangerBtn.setTitle("\(voiceChanger.description())", for: .normal)
        })
    }
    
    func getStyleTransformationAction(_ styleTransformation:AgoraAudioReverbPreset) -> UIAlertAction{
        return UIAlertAction(title: "\(styleTransformation.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceChanger,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceReverbPreset(styleTransformation)
            self.styleTransformationBtn.setTitle("\(styleTransformation.description())", for: .normal)
        })
    }
    
    func getRoomAcousticsAction(_ roomAcoustics:AgoraAudioVoiceChanger) -> UIAlertAction{
        return UIAlertAction(title: "\(roomAcoustics.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceReverbPreset,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceChanger(roomAcoustics)
            self.roomAcousticsBtn.setTitle("\(roomAcoustics.description())", for: .normal)
        })
    }
    
    func getRoomAcousticsAction(_ roomAcoustics:AgoraAudioReverbPreset) -> UIAlertAction{
        return UIAlertAction(title: "\(roomAcoustics.description())", style: .default, handler: {[unowned self] action in
            self.resetVoiceChanger()
            //when using this method with setLocalVoiceChanger,
            //the method called later overrides the one called earlier
            self.agoraKit.setLocalVoiceReverbPreset(roomAcoustics)
            self.roomAcousticsBtn.setTitle("\(roomAcoustics.description())", for: .normal)
        })
    }
    
    func getEqualizationFreqAction(_ freq:AgoraAudioEqualizationBandFrequency) -> UIAlertAction {
        return UIAlertAction(title: "\(freq.description())", style: .default, handler: {[unowned self] action in
            self.equalizationFreq = freq
            self.equalizationFreqBtn.setTitle("\(freq.description())", for: .normal)
            LogUtils.log(message: "onLocalVoiceEqualizationGain \(self.equalizationFreq.description()) \(self.equalizationGain)", level: .info)
            self.agoraKit.setLocalVoiceEqualizationOf(self.equalizationFreq, withGain: self.equalizationGain)
        })
    }
    
    func getReverbKeyAction(_ reverbType:AgoraAudioReverbType) -> UIAlertAction {
        return UIAlertAction(title: "\(reverbType.description())", style: .default, handler: {[unowned self] action in
            self.updateReverbValueRange(reverbKey: reverbType)
            self.reverbKeyBtn.setTitle("\(reverbType.description())", for: .normal)
        })
    }
    
    /// callback when voice changer button hit
    @IBAction func onChatBeautifier() {
        let alert = UIAlertController(title: "Set Chat Beautifier", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getChatBeautifierAction(.voiceChangerOff))
        alert.addAction(getChatBeautifierAction(.generalBeautyVoiceFemaleFresh))
        alert.addAction(getChatBeautifierAction(.generalBeautyVoiceFemaleVitality))
        alert.addAction(getChatBeautifierAction(.generalBeautyVoiceMaleMagnetic))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    /// callback when voice changer button hit
    @IBAction func onTimbreTransformation() {
        let alert = UIAlertController(title: "Set Timbre Transformation", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getTimbreTransformationAction(.voiceChangerOff))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyVigorous))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyDeep))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyMellow))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyFalsetto))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyFull))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyClear))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyResounding))
        alert.addAction(getTimbreTransformationAction(.voiceBeautyRinging))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    /// callback when voice changer button hit
    @IBAction func onVoiceChanger() {
        let alert = UIAlertController(title: "Set Voice Changer", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getVoiceChangerAction(.voiceChangerOff))
        alert.addAction(getVoiceChangerAction(.voiceChangerOldMan))
        alert.addAction(getVoiceChangerAction(.voiceChangerBabyBoy))
        alert.addAction(getVoiceChangerAction(.voiceChangerBabyGirl))
        alert.addAction(getVoiceChangerAction(.voiceChangerZhuBaJie))
        alert.addAction(getVoiceChangerAction(.voiceChangerHulk))
        alert.addAction(getVoiceChangerAction(.fxUncle))
        alert.addAction(getVoiceChangerAction(.fxSister))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    /// callback when voice changer button hit
    @IBAction func onStyleTransformation() {
        let alert = UIAlertController(title: "Set Style Transformation", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getStyleTransformationAction(.fxPopular))
        alert.addAction(getStyleTransformationAction(.popular))
        alert.addAction(getStyleTransformationAction(.fxRNB))
        alert.addAction(getStyleTransformationAction(.rnB))
        alert.addAction(getStyleTransformationAction(.rock))
        alert.addAction(getStyleTransformationAction(.hipHop))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    /// callback when voice changer button hit
    @IBAction func onRoomAcoustics() {
        let alert = UIAlertController(title: "Set Room Acoustics", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getRoomAcousticsAction(.voiceBeautySpacial))
        alert.addAction(getRoomAcousticsAction(.voiceChangerEthereal))
        alert.addAction(getRoomAcousticsAction(.fxVocalConcert))
        alert.addAction(getRoomAcousticsAction(.vocalConcert))
        alert.addAction(getRoomAcousticsAction(.fxKTV))
        alert.addAction(getRoomAcousticsAction(.KTV))
        alert.addAction(getRoomAcousticsAction(.fxStudio))
        alert.addAction(getRoomAcousticsAction(.studio))
        alert.addAction(getRoomAcousticsAction(.fxPhonograph))
        alert.addAction(getRoomAcousticsAction(.virtualStereo))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLocalVoicePitch(_ sender:UISlider) {
        LogUtils.log(message: "onLocalVoicePitch \(Double(sender.value))", level: .info)
        agoraKit.setLocalVoicePitch(Double(sender.value))
    }
    
    @IBAction func onLocalVoiceEqualizaitonFreq(_ sender:UIButton) {
        let alert = UIAlertController(title: "Set Band Frequency", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getEqualizationFreqAction(.band31))
        alert.addAction(getEqualizationFreqAction(.band62))
        alert.addAction(getEqualizationFreqAction(.band125))
        alert.addAction(getEqualizationFreqAction(.band250))
        alert.addAction(getEqualizationFreqAction(.band500))
        alert.addAction(getEqualizationFreqAction(.band1K))
        alert.addAction(getEqualizationFreqAction(.band2K))
        alert.addAction(getEqualizationFreqAction(.band4K))
        alert.addAction(getEqualizationFreqAction(.band8K))
        alert.addAction(getEqualizationFreqAction(.band16K))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLocalVoiceEqualizationGain(_ sender:UISlider) {
        equalizationGain = Int(sender.value)
        LogUtils.log(message: "onLocalVoiceEqualizationGain \(equalizationFreq.description()) \(equalizationGain)", level: .info)
        agoraKit.setLocalVoiceEqualizationOf(equalizationFreq, withGain: equalizationGain)
    }
    
    func updateReverbValueRange(reverbKey:AgoraAudioReverbType) {
        var min:Float = 0, max:Float = 0
        switch reverbKey {
        case .dryLevel:
            min = -20
            max = 10
            break
        case .wetLevel:
            min = -20
            max = 10
            break
        case .roomSize:
            min = 0
            max = 100
            break
        case .wetDelay:
            min = 0
            max = 200
            break
        case .strength:
            min = 0
            max = 100
            break
        default: break
        }
        reverbValueSlider.minimumValue = min
        reverbValueSlider.maximumValue = max
        reverbValueSlider.value = Float(reverbMap[reverbType] ?? 0)
    }
    
    @IBAction func onLocalVoiceReverbKey(_ sender:UIButton) {
        let alert = UIAlertController(title: "Set Reverb Key", message: nil, preferredStyle: .actionSheet)
        alert.addAction(getReverbKeyAction(.dryLevel))
        alert.addAction(getReverbKeyAction(.wetLevel))
        alert.addAction(getReverbKeyAction(.roomSize))
        alert.addAction(getReverbKeyAction(.wetDelay))
        alert.addAction(getReverbKeyAction(.strength))
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLocalVoiceReverbValue(_ sender:UISlider) {
        let value = Int(sender.value)
        reverbMap[reverbType] = value
        LogUtils.log(message: "onLocalVoiceReverbValue \(reverbType.description()) \(value)", level: .info)
        agoraKit.setLocalVoiceReverbOf(reverbType, withValue: value)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // set up agora instance when view loadedlet config = AgoraRtcEngineConfig()
        let config = AgoraRtcEngineConfig()
        config.appId = KeyCenter.AppId
        config.areaCode = GlobalSettings.shared.area.rawValue
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        
        guard let channelName = configs["channelName"] as? String else {return}
        self.title = channelName
        
        // reset voice changer options
        resetVoiceChanger()
        equalizationFreqBtn.setTitle("\(equalizationFreq.description())", for: .normal)
        reverbKeyBtn.setTitle("\(reverbType.description())", for: .normal)
        
        // Before calling the method, you need to set the profile
        // parameter of setAudioProfile to AUDIO_PROFILE_MUSIC_HIGH_QUALITY(4)
        // or AUDIO_PROFILE_MUSIC_HIGH_QUALITY_STEREO(5), and to set
        // scenario parameter to AUDIO_SCENARIO_GAME_STREAMING(3).
        agoraKit.setAudioProfile(.musicHighQualityStereo, scenario: .gameStreaming)
        
        // make myself a broadcaster
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(.broadcaster)
        
        // disable video module
        agoraKit.disableVideo()
        
        // Set audio route to speaker
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
        // start joining channel
        // 1. Users can only see each other after they join the
        // same channel successfully using the same app id.
        // 2. If app certificate is turned on at dashboard, token is needed
        // when joining channel. The channel name and uid used to calculate
        // the token has to match the ones used for channel join
        let result = agoraKit.joinChannel(byToken: nil, channelId: channelName, info: nil, uid: 0) {[unowned self] (channel, uid, elapsed) -> Void in
            self.isJoined = true
            LogUtils.log(message: "Join \(channel) with uid \(uid) elapsed \(elapsed)ms", level: .info)
            
            //set up local audio view, this view will not show video but just a placeholder
            let view = Bundle.loadView(fromNib: "VideoView", withType: VideoView.self)
            self.audioViews[uid] = view
            view.setPlaceholder(text: self.getAudioLabel(uid: uid, isLocal: true))
            self.container.layoutStream2x1(views: Array(self.audioViews.values))
        }
        if result != 0 {
            // Usually happens with invalid parameters
            // Error code description can be found at:
            // en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
            // cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
            self.showAlert(title: "Error", message: "joinChannel call failed: \(result), please check your params")
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            // leave channel when exiting the view
            if isJoined {
                agoraKit.leaveChannel { (stats) -> Void in
                    LogUtils.log(message: "left channel, duration: \(stats.duration)", level: .info)
                }
            }
        }
    }
}

/// agora rtc engine delegate events
extension VoiceChangerMain: AgoraRtcEngineDelegate {
    /// callback when warning occured for agora sdk, warning can usually be ignored, still it's nice to check out
    /// what is happening
    /// Warning code description can be found at:
    /// en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraWarningCode.html
    /// @param warningCode warning code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        LogUtils.log(message: "warning: \(warningCode.description)", level: .warning)
    }
    
    /// callback when error occured for agora sdk, you are recommended to display the error descriptions on demand
    /// to let user know something wrong is happening
    /// Error code description can be found at:
    /// en: https://docs.agora.io/en/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// cn: https://docs.agora.io/cn/Voice/API%20Reference/oc/Constants/AgoraErrorCode.html
    /// @param errorCode error code of the problem
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        LogUtils.log(message: "error: \(errorCode)", level: .error)
        self.showAlert(title: "Error", message: "Error \(errorCode.description) occur")
    }
    
    /// callback when a remote user is joinning the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param elapsed time elapse since current sdk instance join the channel in ms
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        LogUtils.log(message: "remote user join: \(uid) \(elapsed)ms", level: .info)
        
        //set up remote audio view, this view will not show video but just a placeholder
        let view = Bundle.loadView(fromNib: "VideoView", withType: VideoView.self)
        self.audioViews[uid] = view
        view.setPlaceholder(text: self.getAudioLabel(uid: uid, isLocal: false))
        self.container.layoutStream2x1(views: Array(self.audioViews.values))
        self.container.reload(level: 0, animated: true)
    }
    
    /// callback when a remote user is leaving the channel, note audience in live broadcast mode will NOT trigger this event
    /// @param uid uid of remote joined user
    /// @param reason reason why this user left, note this event may be triggered when the remote user
    /// become an audience in live broadcasting profile
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        LogUtils.log(message: "remote user left: \(uid) reason \(reason)", level: .info)
        
        //remove remote audio view
        self.audioViews.removeValue(forKey: uid)
        self.container.layoutStream2x1(views: Array(self.audioViews.values))
        self.container.reload(level: 0, animated: true)
    }
}
