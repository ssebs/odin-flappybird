run:
	odin run .

build:
	odin build . -resource:.\odin-flappybird.rc -out:OdinFlappybird.exe -subsystem:windows

.PHONY: run build
