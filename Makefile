

HEADERS:=$(shell find src -type f -name '*.h')
DIA2CODE_DIR:=./dia2code

all: | clean dia2code configure build

clean:
	@rm -rf bin build
	@rm -f $(shell grep -ls '// Generated by dia2code' main.h ${HEADERS})

distclean: clean
	@rm -rf ${DIA2CODE_DIR}/bin ${DIA2CODE_DIR}/build ${DIA2CODE_DIR}/nbproject

dia2code: ${DIA2CODE_DIR}/bin/dia2code

${DIA2CODE_DIR}/bin/dia2code: 
	cd ${DIA2CODE_DIR} && ./build.sh

configure:
	@mkdir -p build 
	@cd build && cmake ..

build:
	@make -s -j4 -C build

run: build
	./bin/run

test:
	docker build -t plt-initial -f docker/plt-initial .
	docker build -t plt-build -f docker/plt-build .
	./docker/run_docker_x11.sh plt-build

dia2code-archive: distclean
	@zip -r ../dia2code.zip dia2code

start-kit: distclean
	@zip -r ../plt-start-kit.zip CMakeLists.txt Makefile .gitignore src docker rapport res dia2code

.PHONY: configure build clean run test start-kit
