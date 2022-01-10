review_1 = "The Glider II is a great soccer ball"
review_2 = "What a bad soccer-ball"
review_3 = "I am happy with The glider"
docs = [review_1, review_2, review_3]
print(docs)
unique_terms = {term for doc in docs for term in doc.split()}
print(unique_terms)
inverted_index = {}

for i, doc in enumerate(docs):
    for term in doc.split():
        if term in inverted_index:
            inverted_index[term].add(i)
        else: inverted_index[term] = {i}

for x, y in inverted_index.items():
    print(x,end = " ")
    for val in y:
        print(val,end = " ") 
    print(len(y))

# for x in inverted_index.values():
#     for val in x:
#         print(val,end = " ") 
#     print(len(x))