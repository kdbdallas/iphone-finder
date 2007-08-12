CC=arm-apple-darwin-cc 
LD=$(CC)
LDFLAGS=-lobjc -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit -framework CoreGraphics -larmfp -framework GraphicsServices -framework CoreSurface -Isrc

all:	Finder package

Finder:	src/main.o src/App.o src/MainView.o src/FileBrowser.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o:	%.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:	%.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:	%.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

package:
	rm -rf build
	mkdir build
	cp -r ./src/Finder.app ./build
	mv Finder ./build/Finder.app

clean:
	rm -f src/*.o Finder
	rm -rf ./build
