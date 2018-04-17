//
//  MultipleParticipantViewController.h
//  Talkto
//
//  Created by Dinesh Kumar on 2/2/18.
//  Copyright © 2018 Talk.to FZC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioVideo/TwilioVideo.h>

@interface MultipleParticipantViewController : UIViewController

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, strong) NSString * preferredCodec;

@end

@interface TDTParticipantCell : UITableViewCell

- (void)bindWithParticipant:(TVIRemoteParticipant *)participant;

@end
