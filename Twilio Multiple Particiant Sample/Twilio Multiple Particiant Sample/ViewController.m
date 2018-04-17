

#import "ViewController.h"
#import "Utils.h"

#import <TwilioVideo/TwilioVideo.h>
#import "MultipleParticipantViewController.h"

@interface ViewController ()

// Configure access token manually for testing in `ViewDidLoad`, if desired! Create one manually in the console.
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *tokenUrl;


#pragma mark UI Element Outlets and handles


@property (nonatomic, weak) IBOutlet UIView *connectButton;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UITextField *roomTextField;
@property (nonatomic, weak) IBOutlet UITextField *identityTextField;
@property (nonatomic, weak) IBOutlet UILabel *roomLabel;
@property (nonatomic, weak) IBOutlet UILabel *roomLine;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self logMessage:[NSString stringWithFormat:@"TwilioVideo v%@", [TwilioVideo version]]];
    
    // Configure access token for testing. Create one manually in the console
    // at https://www.twilio.com/console/video/runtime/testing-tools
    self.accessToken = @"TWILIO_ACCESS_TOKEN";
    
    // Using a token server to provide access tokens? Make sure the tokenURL is pointing to the correct location.
    self.tokenUrl = @"http://37de21f7.ngrok.io?";
    
    self.roomTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
}

#pragma mark - Public

- (IBAction)connectButtonPressed:(id)sender {
    if (self.identityTextField.text.length < 1 ) {
        [self logMessage:[NSString stringWithFormat:@"Identity not specified"]];
        return;
    }
    if (self.roomTextField.text.length < 1 ) {
        [self logMessage:[NSString stringWithFormat:@"Room name not specified"]];
        return;
    }
    [self dismissKeyboard];
    
    [self logMessage:[NSString stringWithFormat:@"Fetching an access token"]];
    //http://localhost:3000?identity=alice&room=example
    NSMutableString *tokenFetchURL = [NSMutableString stringWithString:self.tokenUrl];
    [tokenFetchURL appendFormat:@"identity=%@",self.identityTextField.text];
    [tokenFetchURL appendFormat:@"&room=%@",self.roomTextField.text];
    [TokenUtils retrieveAccessTokenFromURL:tokenFetchURL completion:^(NSString *token, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                self.accessToken = token;
                [self doConnect];
            } else {
                [self logMessage:[NSString stringWithFormat:@"Error retrieving the access token"]];
            }
        });
    }];
}

- (IBAction)dismissButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doConnect {
    [self performSegueWithIdentifier:@"video" sender:self];
}

- (TVIVideoCodec)mapIndexToCodec:(NSInteger)index {
    switch (index) {
        case 0: return TVIVideoCodecH264;
        case 1: return TVIVideoCodecVP8;
        case 2: return TVIVideoCodecVP9;
        default: return TVIVideoCodecVP8;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MultipleParticipantViewController * controller = [segue destinationViewController];
    
    controller.preferredCodec = [self mapIndexToCodec:self.segmentedControl.selectedSegmentIndex];
    controller.accessToken = self.accessToken;
    controller.roomName = self.roomTextField.text;
}

- (void)logMessage:(NSString *)msg {
    NSLog(@"%@", msg);
    self.messageLabel.text = msg;
}



- (void)dismissKeyboard {
    if (self.roomTextField.isFirstResponder) {
        [self.roomTextField resignFirstResponder];
    }
    if (self.identityTextField.isFirstResponder) {
        [self.identityTextField resignFirstResponder];
    }
}

@end

