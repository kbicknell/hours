all : Hours.app

javafiles = Hours.java HoursCategory.java HoursGroup.java HoursGroupList.java
src = $(addprefix src/,$(javafiles))
appstub = /System/Library/Frameworks/JavaVM.framework/Versions/Current/Resources/MacOS/JavaApplicationStub
graphicsfiles = cancel.png clock.png clock2.png edit.png gc.png greenc.png process-stop.png
graphics = $(addprefix graphics/,$(graphicsfiles))
jgoodiesfiles = jgoodies-common.jar jgoodies-looks.jar ui.jar
jgoodies = $(addprefix jgoodies/,$(jgoodiesfiles))

.PHONY : all clean

hours.jar : bin/hours $(graphics)
	jar cf $@ graphics -C bin hours

bin/hours : $(src) | bin
	javac $(src) -d bin

bin:
	mkdir -p bin

Hours.app : hours.jar $(appstub) mac/Info.plist $(jgoodies)
	mkdir -p Hours.app/Contents/MacOS
	mkdir -p Hours.app/Contents/Resources/Java
	cp $(appstub) Hours.app/Contents/MacOS/
	cp mac/Info.plist Hours.app/Contents/
	cp mac/PkgInfo Hours.app/Contents/
	cp mac/Hours.icns Hours.app/Contents/Resources/
	cp hours.jar Hours.app/Contents/Resources/Java/jar_0.jar
	$(foreach jgoody,$(jgoodies),cp $(jgoody) Hours.app/Contents/Resources/Java/;)
	SetFile -a B Hours.app

clean :
	rm -rf bin/hours
	rm -rf hours.jar
	rm -rf Hours.app
