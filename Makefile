all : Hours.app

inkscape = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
jdkpath = /System/Library/Java/JavaVirtualMachines/1.6.0.jdk
srcfiles = Hours HoursCategory HoursGroup HoursGroupList
src = $(patsubst %,src/%.java,$(srcfiles))
appstub = /System/Library/Frameworks/JavaVM.framework/Versions/Current/Resources/MacOS/JavaApplicationStub
jgoodiesfiles = jgoodies-common-1.8.0.jar jgoodies-looks-2.6.0.jar
jgoodies = $(addprefix jgoodies/,$(jgoodiesfiles))
iconnames = cancel clock clock2 edit gc greenc
icons = $(patsubst %,resources/%.pdf,$(iconnames))

.PHONY : all clean

hours.jar : $(src)
	rm -rf bin/
	mkdir -p bin/
	javac $(src) -d bin
	jar cf $@ -C bin hours

resources :
	mkdir -p resources

resources/%.pdf : svg_graphics/%.svg resources
	$(inkscape) -z -A $@ $<

ui.jar :
	cp $(jdkpath)/Contents/Classes/ui.jar ui.jar

Hours.app : hours.jar $(appstub) mac/Info.plist $(jgoodies) ui.jar $(icons)
	mkdir -p Hours.app/Contents/MacOS
	mkdir -p Hours.app/Contents/Resources/Java
	cp $(appstub) Hours.app/Contents/MacOS/
	cp mac/Info.plist Hours.app/Contents/
	cp mac/PkgInfo Hours.app/Contents/
	cp mac/Hours.icns Hours.app/Contents/Resources/
	cp hours.jar Hours.app/Contents/Resources/Java/jar_0.jar
	cp resources/*.pdf Hours.app/Contents/Resources/
	$(foreach jgoody,$(jgoodies),cp $(jgoody) Hours.app/Contents/Resources/Java/;)
	cp ui.jar Hours.app/Contents/Resources/Java/
	SetFile -a B Hours.app

clean :
	rm -rf bin
	rm -rf hours.jar
	rm -rf Hours.app
	rm -rf ui.jar
	rm -rf $(icons)
	rm -rf resources
