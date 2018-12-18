bin/ROM.gb: $(patsubst src/%.asm,bin/%.o,$(wildcard src/*.asm))
	rgblink -p 0xff -t -d -o $@ -m $(@:.gb=.map) -n $(@:.gb=.sym) $^
	rgbfix -p 0xff -v $@

bin/%.o: src/%.asm
	rgbasm -p 0xff -i src/ -o $@ $<