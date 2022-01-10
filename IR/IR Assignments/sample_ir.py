import os
def createDictionary():
    wordsAdded = {}
    cwd = os.getcwd()
    os.chdir('th-dataset')
    punc = '''!()-[]{};:'\, <>./?‘’"“”@#$%^&*_~'''
    fileList = os.listdir(os.getcwd())
    for file in fileList:
        with open(file, 'r',encoding="utf8") as f:
            words = f.read().lower().split()
            for word in words:
                for i in word:
                    if i in punc:
                        word=word.replace(i,"")
                if word not in wordsAdded.keys():
                    wordsAdded[word] = [f.name]
                else:
                    if file not in wordsAdded[word]:
                        wordsAdded[word] += [f.name]

    return wordsAdded, cwd

def writeToFile(words, cwd):
    os.chdir(cwd)
    with open('index-file.txt', 'w',encoding="utf8") as indexFile:
        for word, files in words.items():
            indexFile.write(word + " ")
            for file in files:
                indexFile.write(file[:file.find(".txt")] + " ")
            indexFile.write(f'{len(files)}\n')


writeToFile(*createDictionary())