from os import listdir
from os.path import isfile, join
from nltk.stem import PorterStemmer
import json

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
        if "\n" in word:
            word = word.replace("\n", "")

        if "," in word:
            word = word.split(",")[0]
        
        if "." in word:
            word = word.replace(".", "")
        
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

    # def index_file(self, file_path):
    #     file_content = open(file_path, "r")
    #     self.process_file(file_name="",file_content=file_content.read())
    #     file_content.close()

    def export_results(self, output_file_name="output"):
        print(f"Exporting results to {output_file_name}.txt....")
        for item in list(self.posting.items()):
            key, value  = item
            output_string = f"[{key}] : "
            output_string += "".join([f"{str(posting_item)}," for posting_item in value])
            with open(f"{output_file_name}.txt", 'a', encoding="utf-8") as f:
                f.write(output_string)

    def export_json(self, output_file_name="output"):
        print(f"Exporting results to {output_file_name}.json....")
        serializable_posting = dict()

        for item in self.posting.items():
            key, value = item
            posting_items = [str(posting_item) for posting_item in value]
            serializable_posting[key] = posting_items

        json_object = json.dumps(serializable_posting)
        with open(f"{output_file_name}.json", "w", encoding='utf-8') as output:
            output.write(json_object)
        

    def print_posting(self):

        for item in list(self.posting.items())[:10]:
            key, value = item
            print(f"{key} : ", end="")
            list_items = "".join(f"{str(posting_item)},"  for posting_item in value)
            print(list_items)

    def process_string_from_input(self, value):
        terms = value.split(",")
        doc_id = terms[0][1:]
        freq = terms[0][:-2]
        return tuple(int(doc_id), int(freq))


    def index_from_json(self, file_name):

        with open(file_name, "r") as f:
            json_object = json.load(f)
        print(json_object)

        for item in json_object.items():
            key, value = item
            




    def index_from_input_file(self, file_path):
        pass


if __name__ == "__main__":
    
    MY_PATH = r"th-dataset"

    inverted_indexer = InvertedIndexer()
    inverted_indexer.index_directory(dir_path=MY_PATH)

    inverted_indexer.export_results(output_file_name="results")

    inverted_indexer.export_json(output_file_name="results_json")

    # input_indexer = InvertedIndexer()
    # input_indexer.index_from_json(file_name=r"H:\STUDIES\SEMESTER5\IR\Assignment-1\indexed.json")
