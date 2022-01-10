#This Assignment is done by Anirudh Jakhotia
#Roll No: S20190010007

import json
from os.path import isfile, join
from os import getcwd, path
from nltk.stem import PorterStemmer
from os import listdir

#Prints the frequency of elements
class PositoningElements:
    def __init__(self, record_id, repition) -> None:
        self.record_id = record_id.split(".")[0]
        self.repition = repition

    def __str__(self) -> str:
        return f"({self.record_id},{self.repition})"

#Computes the Inverted Index of the file.
class Inverted_Positions:
    
    def __init__(self) -> None:
        self.posting = dict()

    #Processing or Complete tasks of words
    def Task_strings(self, strings):

        if "(" in strings:
            strings=strings.replace("(","")

        if ")" in strings:
            strings=strings.replace(")","")

        if "”" in strings:
            strings = strings.replace("”", "")
        
        if "‘" in strings:
            strings = strings.replace("‘", "")
 
        if "\n" in strings:
            strings = strings.replace("\n", "")

        if "," in strings:
            strings = strings.split(",")[0]

        if "’" in strings:
            strings = strings.replace("’", "")
    
        if "." in strings:
            strings = strings.replace(".", "")

        if "'" in strings:
            strings = strings.replace("'", "")
    
        if "-" in strings:
            strings=strings.replace("-","") 

        if "&" in strings:
            strings = strings.replace("&", "") 

        if "“" in strings:
            strings = strings.replace("“", "")        
        
        stripper = PorterStemmer()
        return stripper.stem(strings)
    
    #Processes all the files from 101.txt to 281.txt
    def Task_record(self, file_name, file_content):
        print(f"Reading the file {file_name}.")
        record_label_chart = dict()
        phrases = file_content.split(" ")

        for strings in phrases:
            strings = self.Task_strings(strings)
            if strings in record_label_chart.keys():
                record_label_chart[strings] += 1
            else:
                record_label_chart[strings] = 1
        
        for element in record_label_chart.items():
            label, repition = element
            posting_list_item = PositoningElements(file_name, repition)
            if label in self.posting.keys():
                self.posting[label].append(posting_list_item)
            else:
                self.posting[label] = list([posting_list_item])

    #Computes the dictionary indexes.
    def position_archive(self, wordbook_track):
        record = [ file for file in listdir(wordbook_track) if isfile(join(wordbook_track, file))]
        print(f"Reading the directory : {wordbook_track}")
        print(f"{len(record)} text files found")
        for file in record:
            record_content = open(join(wordbook_track, file), encoding='utf-8')
            self.Task_record(file, record_content.read())
    
    #Exporting the indexes to output.txt file
    def export_index(self, output_file_name="Assign012019007-output"):
        print(f"Computing output and sending it to {output_file_name}.txt.")
        for element in list(self.posting.items()):
            key, value  = element
            final_string = f"{key} : "
            posting_list = "".join([f"{str(posting_item.record_id)}," for posting_item in value])
            final_string += f"( {len(value)} , [{posting_list}])\n" 
            with open(f"{output_file_name}.txt", 'a', encoding="utf-8") as f:
                f.write(final_string)

#Main/Driver Code
if __name__ == "__main__":
    
    MY_PATH = path.abspath(getcwd()) + r"\th-dataset"
    print("IR Assignment - 01")
    inverted_pos = Inverted_Positions()
    inverted_pos.position_archive(wordbook_track=MY_PATH)
    inverted_pos.export_index()
    print("The Computed Inverted Index can now be viewed in Output.txt file ")
    print("Thank You!")