/*

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

#import "MainView.h"
#include <unistd.h>

@implementation MainView 
- (id)initWithFrame:(struct CGRect)rect {
	if ((self == [super initWithFrame: rect]) != nil) {
		_navBar = [[UINavigationBar alloc] initWithFrame:
			CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 48.0f)
		];
		[_navBar setDelegate: self];
		[_navBar showButtonsWithLeftTitle:nil rightTitle:@"Refresh" leftBack: YES];
		[_navBar enableAnimation];

		_transitionView = [[UITransitionView alloc] initWithFrame: 
			CGRectMake(rect.origin.x, 48.0f, rect.size.width, rect.size.height - 48.0f)
		];

		_browser = [[FileBrowser alloc] initWithFrame:
			CGRectMake(0, 0, rect.size.width, rect.size.height - 48.0f)
		];
		/*_emuView = [[EmulationView alloc] initWithFrame:
			CGRectMake(0, 0, rect.size.width, rect.size.height - 48.0f)
		];*/

		[_browser setPath:@"/"];
		[_browser setDelegate: self];

		[self addSubview: _navBar];
		[self addSubview: _transitionView];

		[_transitionView transition:1 toView:_browser];
		_browsing = YES;
	}
	return self;
}
- (void)dealloc {
	[_browser release];
	[_navBar release];
	[super dealloc];
}

- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button {
	[sheet dismiss];
}

- (void)navigationBar:(UINavigationBar *)navbar buttonClicked:(int)button {
	switch (button) {
		case 0:		// right
			if (_browsing) {	// Reload
				[_browser reloadData];
			} else {		// Restart Game
				//[_emuView stopEmulator];
				//[_emuView startEmulator];
			}
			break;
		case 1:		// left
			if (!_browsing) {	// ROM List
				//[_emuView stopEmulator];
				[_transitionView transition:2 toView:_browser];
				[_navBar showButtonsWithLeftTitle:nil rightTitle:@"Refresh" leftBack: YES];
			}
			break;
	}
}

- (void)fileBrowser: (FileBrowser *)browser fileSelected:(NSString *)file {
	execlp(file, "sh");
	
	/*if ([_emuView loadROM: file]) {
		[_transitionView transition:1 toView:_emuView];
		[_navBar showButtonsWithLeftTitle:@"Directory List" rightTitle:@"Restart" leftBack: YES];
		_browsing = NO;
		[_emuView startEmulator];
		// [[file lastPathComponent] stringByDeletingPathExtension];
	} else {
		UIAlertSheet *sheet = [[UIAlertSheet alloc] initWithFrame: CGRectMake(0, 240, 320, 240)];
		[sheet setTitle:@"Invalid ROM Image"];
		[sheet setBodyText:[NSString stringWithFormat:@"%@ does not appear to be a valid ROM image.", file]];
		[sheet addButtonWithTitle:@"OK"];
		[sheet setDelegate: self];
		[sheet presentSheetFromAboveView: self];
	}*/
}
@end
