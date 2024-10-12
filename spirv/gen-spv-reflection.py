from common import *
import os
import io
import sys

def emit(emitter: str, scanner: SpirvGrammarScanner, file: io.FileIO):
    program = open(emitter).read()
    exec(program, {}, { 'scanner': scanner, 'file': file })

if (len(sys.argv) == 1):
    print("gen-spv-reflection.py <[emitters...] | all>")
    exit(-1)

scanner = SpirvGrammarScanner("spirv.core.grammar.json")
fileList = list[str]()

if sys.argv[1] == "all":
    for file in os.listdir("emitters/"):
        f = os.path.join("emitters/", file)
        if os.path.isfile(f):
            fileList.append(os.path.splitext(file)[0])
else:
    fileList = sys.argv[1:]

for name in fileList:
    f = os.path.join("emitters/", name + ".py")
    if (os.path.isfile(f)):
        emit(f, scanner, open(f"../source/spirv/reflection/{name}.d", "w"))