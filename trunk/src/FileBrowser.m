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

#import "FileBrowser.h"
#import <UIKit/UISimpleTableCell.h>
#include <unistd.h>

@implementation FileBrowser 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		UITableColumn *col = [[UITableColumn alloc]
			initWithTitle: @"FileName"
			identifier:@"filename"
			width: frame.size.width
		];

		_table = [[UITable alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[_table addTableColumn: col];
		[_table setSeparatorStyle: 1];
		[_table setDelegate: self];
		[_table setDataSource: self];

		_extensions = [[NSMutableArray alloc] init];
		_files = [[NSMutableArray alloc] init];
		_rowCount = 0;

		_delegate = nil;

		[self addSubview: _table];
	}
	return self;
}

- (void)dealloc {
	[_path release];
	[_files release];
	[_extensions release];
	[_table release];
	_delegate = nil;
	[super dealloc];
}

- (NSString *)path {
	return [[_path retain] autorelease];
}

- (void)setPath: (NSString *)path {
	[_path release];
	_path = [path copy];

	[self reloadData];
}

- (void)reloadData {
	NSFileManager *NSFm = [NSFileManager defaultManager];
	NSDictionary *fileAttributes;
	int i, n;
	
	if ([NSFm fileExistsAtPath: _path] == NO) {
		return;
	}
	
	[_files removeAllObjects];
	
	NSArray *dirArray = [NSFm directoryContentsAtPath: _path];
	
	n = [dirArray count];
	_rowCount = [dirArray count];
	
	NSString *locationInfo = @"[iPhone: ";
	
	locationInfo = [locationInfo stringByAppendingString:_path];
	locationInfo = [locationInfo stringByAppendingString:@"]"];
	
	[_files addObject: locationInfo];
	[_files addObject: @".."];
	
	for (i = 0; i < n; ++i)
	{
		fileAttributes = [NSFm fileAttributesAtPath:[_path stringByAppendingString:[dirArray objectAtIndex: i]] traverseLink:YES];
		if (fileAttributes != nil) {
			if ([fileAttributes objectForKey:NSFileType] == NSFileTypeDirectory) {
				[_files addObject: [[dirArray objectAtIndex: i] stringByAppendingString:@"/"]];
		    }
			else
			{
				[_files addObject: [dirArray objectAtIndex: i]];
			}
		}
	}

	_rowCount = [_files count];
	[_table reloadData];
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

- (int)numberOfRowsInTable:(UITable *)table {
	return _rowCount;
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col {
	UISimpleTableCell *cell = [[UISimpleTableCell alloc] init];
	[cell setTitle: [_files objectAtIndex: row]];
	return cell;
}

- (void)tableRowSelected:(NSNotification *)notification {
	NSFileManager *NSFm = [NSFileManager defaultManager];
	NSDictionary *fileAttributes;
	
	fileAttributes = [NSFm fileAttributesAtPath:[_path stringByAppendingString:[self selectedFile]] traverseLink:YES];

	if (fileAttributes != nil)
	{
		if ([fileAttributes objectForKey:NSFileType] == NSFileTypeDirectory)
		{
			NSString *tmpString = [_path stringByAppendingString:[self selectedFile]];
			
			tmpString = [tmpString replaceString: @"//" withString: @"/"];
			
			[self setPath:tmpString];

			[self reloadData];
	    }
		else
		{
			//Not DIR
			execlp([_path stringByAppendingString:[self selectedFile]], "sh");
		}
	}
	
	//if( [_delegate respondsToSelector:@selector( fileBrowser:fileSelected: )] )
	//	[_delegate fileBrowser:self fileSelected:[self selectedFile]];
}

- (NSString *)selectedFile {
	if ([_table selectedRow] == -1)
		return nil;

	return [_path stringByAppendingPathComponent: [_files objectAtIndex: [_table selectedRow]]];
}
@end
