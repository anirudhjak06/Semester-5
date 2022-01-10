from os import listdir
from os.path import isfile, join
from nltk.stem import PorterStemmer
import json
from os import getcwd, path

class PostingListItem:
    def __init__(self, doc_id, freq) -> None:
        self.doc_id = doc_id.split(".")[0]
        self.freq = freq

    def __str__(self) -> str:
        return f"({self.doc_id},{self.freq})"

class InvertedIndexer:
    
    def __init__(self) -> None:
        self.posting = dict()


    def process_word(self, word):

        if "“" in word:
            word = word.replace("“", "")

        if "”" in word:
            word = word.replace("”", "")
        
        if "’" in word:
            word = word.replace("’", "")

        if "‘" in word:
            word = word.replace("‘", "")
 
        if "&" in word:
            word = word.replace("&", "")        

        if "\n" in word:
            word = word.replace("\n", "")

        if "," in word:
            word = word.split(",")[0]
        
        if "." in word:
            word = word.replace(".", "")

        if "'" in word:
            word = word.replace("'", "")
        if "(" in word:
            word=word.replace("(","")
        if ")" in word:
            word=word.replace(")","")
        if "-" in word:
            word=word.replace("-","")
        
        stemmer = PorterStemmer()
        return stemmer.stem(word)
    

    def process_file(self, file_name, file_content):
        print(f"Processing file {file_name}...")
        document_term_map = dict()
        words = file_content.split(" ")

        for word in words:
            word = self.process_word(word)

            if word in document_term_map.keys():
                document_term_map[word] += 1
            else:
                document_term_map[word] = 1
        
        for item in document_term_map.items():
            term, freq = item
            posting_list_item = PostingListItem(file_name, freq)
            if term in self.posting.keys():
                self.posting[term].append(posting_list_item)
            else:
                self.posting[term] = list([posting_list_item])


    def index_directory(self, dir_path):
        files = [ f for f in listdir(dir_path) if isfile(join(dir_path, f))]
        print(f"Processing directory {dir_path}")
        print(f"{len(files)} found")
        for f in files:
            file_content = open(join(dir_path, f), encoding='utf-8')
            self.process_file(f, file_content.read())
    
    def export_index(self, output_file_name="Assign012019123-output"):
        print(f"Exporting results to {output_file_name}.txt....")
        for item in list(self.posting.items()):
            key, value  = item
            output_string = f"{key} : "
            posting_list = "".join([f"{str(posting_item.doc_id)}," for posting_item in value])
            output_string += f"( {len(value)} , [{posting_list}])\n" 
            with open(f"{output_file_name}.txt", 'a', encoding="utf-8") as f:
                f.write(output_string)

            
if __name__ == "__main__":
    
    MY_PATH = path.abspath(getcwd()) + r"\th-dataset"

    inverted_indexer = InvertedIndexer()
    inverted_indexer.index_directory(dir_path=MY_PATH)

    inverted_indexer.export_index()
   
