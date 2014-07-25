all : bin/hours/Hours.class
.PHONY : all clean
bin/hours/Hours.class : src/Hours.java src/HoursCategory.java src/HoursGroup.java src/HoursGroupList.java
	javac src/*.java -d bin
clean :
	rm -f bin/hours/Hours\$$1.class bin/hours/Hours\$$2.class bin/hours/Hours.class bin/hours/HoursCategory.class bin/hours/HoursGroup.class bin/hours/HoursGrouplist.class
	rmdir bin/hours
	rmdir bin
