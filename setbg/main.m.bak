#import <Cocoa/Cocoa.h>

@interface ImageView : NSView

-(id) initWithFrame: (NSRect)frame Image: (NSImage*)image;

@end

@implementation ImageView
{
    NSImage *backgroundImage;
}

-(id) initWithFrame: (NSRect)frame Image: (NSImage*)image
{
    if ((self = [super initWithFrame: frame]))
    {
        [image setSize: frame.size];
        backgroundImage = [image retain];
    }
    
    return self;
}

-(void) drawRect: (NSRect)dirtyRect
{
    [backgroundImage drawInRect: dirtyRect fromRect: dirtyRect operation: NSCompositeCopy fraction: 1.0f];
}

-(void) dealloc
{
    [backgroundImage release];
    
    [super dealloc];
}

@end

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NSApplication sharedApplication];
        
        const NSRect Frame = [[NSScreen mainScreen] frame];
        NSWindow *Window = [[[NSWindow alloc] initWithContentRect: Frame styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: NO] autorelease];
        
        [Window setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces];
        [Window setOpaque: YES];
        [Window setBackgroundColor: [NSColor blackColor]];
        [[Window contentView] setFrame: Frame];
        [Window setLevel: kCGDesktopWindowLevel];
        [Window makeKeyAndOrderFront: nil];
        
        [[Window contentView] addSubview: [[[ImageView alloc] initWithFrame: Frame Image: [[[NSImage alloc] initWithContentsOfFile: [NSString stringWithUTF8String: argv[1]]] autorelease]] autorelease]];
        
        [[NSRunLoop currentRunLoop] run];
    }
    
    return 0;
}
