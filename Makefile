run:
	odin run .

build-win:
	odin build . -resource:.\odin-flappybird.rc -out:OdinFlappybird.exe -target:windows_amd64
build-mac:
	odin build . -resource:.\odin-flappybird.rc -out:OdinFlappybird.exe -target:darwin_arm64
build-lnx:
	odin build . -resource:.\odin-flappybird.rc -out:OdinFlappybird.exe -target:linux_amd64

.PHONY: run build-win build-mac build-lnx
