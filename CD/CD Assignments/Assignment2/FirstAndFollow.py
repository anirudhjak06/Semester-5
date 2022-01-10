from collections import OrderedDict
from re import *

t_record=OrderedDict()
nt_record=OrderedDict()
production_record=[]

class Terminals:

    def __init__(self, symbol):
        self.symbol=symbol

    def __str__(self):
        return self.symbol

class Non_Terminals:

    def __init__(self, symbol):
        self.symbol=symbol
        self.first=set()
        self.follow=set()

    def __str__(self):
        return self.symbol

    def addingFirst(self, symbols): self.first |= set(symbols) 
    def addingFollow(self, symbols): self.follow |= set(symbols)

def EvaluatingFirst(symbol): 

    global production_record, nt_record, t_record
    if symbol in t_record:
        return set(symbol)

    for prod in production_record:
        head, body=prod.split('->')
        
        if head!=symbol: continue
        if body=='':
            nt_record[symbol].addingFirst(chr(1013))
            continue

        for i, Y in enumerate(body):
            if body[i]==symbol: continue
            t=EvaluatingFirst(Y)
            nt_record[symbol].addingFirst(t-set(chr(1013)))
            if chr(1013) not in t:
                break 
            if i==len(body)-1: 
                nt_record[symbol].addingFirst(chr(1013))

    return nt_record[symbol].first

def obtainFirst(symbol): 
    return EvaluatingFirst(symbol)

def EvaluatingFollow(symbol):
    global production_record, nt_record, t_record

    if symbol == list(nt_record.keys())[0]: 
        nt_record[symbol].addingFollow('$')

    for prod in production_record:    
        head, body=prod.split('->')
        for i, B in enumerate(body):        
            if B != symbol: continue
            if i != len(body)-1:
                nt_record[symbol].addingFollow(obtainFirst(body[i+1]) - set(chr(1013)))

            if i == len(body)-1 or chr(1013) in obtainFirst(body[i+1]) and B != head: 
                nt_record[symbol].addingFollow(obtainFollow(head))

def obtainFollow(symbol):
    global nt_record, t_record
    if symbol in t_record.keys():
        return None
    
    return nt_record[symbol].follow

def main(pl=None):
    
    print('_____________________________________________________________________')
    print('\nCD ASSIGNMENT - 2')
    print('_____________________________________________________________________')
    print('\nNOTE : This Assignment has finished the below tasks : ')

    print('''   1. Creation of an LR(1) automaton \n   2. Creation of CLR(1) parse table \n   3. Parsing the given input.
   4. Output sequence of rightmost derivations, if the string is in the language and if the grammar is LR(1).
   5. Generating the appropriate error messages and displaying them  ''')

    print('\nNOTE: \n (1) Enter end or return to stop')
    print(''' (2) Format: "A->Y1Y2..Yn" {Yi - single char} OR "A->" {epsilon} ''')

    print('\nEnter the grammar productions : ')
    
    global production_record, t_record, nt_record
    ctr=1

    if pl==None:

        while True:
            production_record.append(input().replace(' ', ''))
            if production_record[-1].lower() in ['end', '']: 
                del production_record[-1]
                break

            head, body=production_record[ctr-1].split('->')

            if head not in nt_record.keys():
                nt_record[head]=Non_Terminals(head)

            for i in body:
                if not 65<=ord(i)<=90:
                    if i not in t_record.keys(): t_record[i]=Terminals(i)

                elif  i not in nt_record.keys(): nt_record[i]=Non_Terminals(i)
                
            ctr+=1
                
    return pl

#Main Function
if __name__=='__main__':
    main()

