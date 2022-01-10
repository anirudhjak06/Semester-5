from pprint import pprint
import FirstAndFollow
from collections import deque
from collections import OrderedDict
from FirstAndFollow import production_record, nt_record as ntl, t_record as tl
nt_list, t_list=[], []

class State:
    _id=0
    def __init__(self, closure):
        self.closure=closure
        self.no=State._id
        State._id+=1

class Item(str):
    def __new__(cls, item, lookahead=list()):
        self=str.__new__(cls, item)
        self.lookahead=lookahead
        return self

    def __str__(self):
        return super(Item, self).__str__()+", "+'|'.join(self.lookahead)
        

def closure(items):
    def exists(newitem, items):
        for i in items:
            if i==newitem and sorted(set(i.lookahead))==sorted(set(newitem.lookahead)):
                return True
        return False

    global production_record

    while True:
        flag=0
        for i in items: 
            if i.index('.')==len(i)-1: continue
            Y=i.split('->')[1].split('.')[1][0]

            if i.index('.')+1<len(i)-1:
                lastr=list(FirstAndFollow.EvaluatingFirst(i[i.index('.')+2])-set(chr(1013)))
                
            else:
                lastr=i.lookahead
            
            for prod in production_record:
                head, body=prod.split('->')
                if head!=Y: continue
                newitem=Item(Y+'->.'+body, lastr)

                if not exists(newitem, items):
                    items.append(newitem)
                    flag=1
        if flag==0: break

    return items

def go_to(items, symbol):

    global production_record
    initial=[]

    for i in items:
        if i.index('.')==len(i)-1: continue

        head, body=i.split('->')
        seen, unseen=body.split('.')

        if unseen[0]==symbol and len(unseen) >= 1:
            initial.append(Item(head+'->'+seen+unseen[0]+'.'+unseen[1:], i.lookahead))

    return closure(initial)


def calc_states():

    def contains(states, t):

        for s in states:
            if len(s) != len(t): continue

            if sorted(s)==sorted(t):
                for i in range(len(s)):
                        if s[i].lookahead!=t[i].lookahead: break
                else: return True

        return False

    global production_record, nt_list, t_list

    head, body=production_record[0].split('->')
    states=[closure([Item(head+'->.'+body, ['$'])])]
    while True:
        flag=0
        for s in states:
            for e in nt_list+t_list:
                t=go_to(s, e)
                if t == [] or contains(states, t): continue
                states.append(t)
                flag=1

        if not flag: break
    
    return states 


def make_table(states):
    global nt_list, t_list

    def obtain_state_no(t):
        for s in states:
            if len(s.closure) != len(t): continue

            if sorted(s.closure)==sorted(t):
                for i in range(len(s.closure)):
                        if s.closure[i].lookahead!=t[i].lookahead: break
                else: return s.no

        return -1

    def obtain_production_no(closure):

        closure=''.join(closure).replace('.', '')
        return production_record.index(closure)

    SLR_Table=OrderedDict()
    
    for i in range(len(states)):
        states[i]=State(states[i])

    for s in states:
        SLR_Table[s.no]=OrderedDict()

        for item in s.closure:
            head, body=item.split('->')
            if body=='.': 
                for term in item.lookahead: 
                    if term not in SLR_Table[s.no].keys():
                        SLR_Table[s.no][term]={'r'+str(obtain_production_no(item))}
                    else: SLR_Table[s.no][term] |= {'r'+str(obtain_production_no(item))}
                continue

            nextsym=body.split('.')[1]
            if nextsym=='':
                if obtain_production_no(item)==0:
                    SLR_Table[s.no]['$']='accept'
                else:
                    for term in item.lookahead: 
                        if term not in SLR_Table[s.no].keys():
                            SLR_Table[s.no][term]={'r'+str(obtain_production_no(item))}
                        else: SLR_Table[s.no][term] |= {'r'+str(obtain_production_no(item))}
                continue

            nextsym=nextsym[0]
            t=go_to(s.closure, nextsym)
            if t != []: 
                if nextsym in t_list:
                    if nextsym not in SLR_Table[s.no].keys():
                        SLR_Table[s.no][nextsym]={'s'+str(obtain_state_no(t))}
                    else: SLR_Table[s.no][nextsym] |= {'s'+str(obtain_state_no(t))}

                else: SLR_Table[s.no][nextsym] = str(obtain_state_no(t))

    return SLR_Table

def augment_grammar():

    for i in range(ord('Z'), ord('A')-1, -1):
        if chr(i) not in nt_list:
            start_prod=production_record[0]
            production_record.insert(0, chr(i)+'->'+start_prod.split('->')[0]) 
            return

def main():

    global production_record, ntl, nt_list, tl, t_list    
    FirstAndFollow.main()
    print("\tFIRST AND FOLLOW OF NON-TERMINALS")
    for nt in ntl:
        FirstAndFollow.EvaluatingFirst(nt)
        FirstAndFollow.EvaluatingFollow(nt)
        print(nt)
        print("\tFirst:\t", FirstAndFollow.obtainFirst(nt))
        print("\tFollow:\t", FirstAndFollow.obtainFollow(nt), "\n")  
    

    augment_grammar()
    nt_list=list(ntl.keys())
    t_list=list(tl.keys()) + ['$']

    print("Terminals : ",nt_list)
    print("Non-Terminals : ",t_list)
    print('')

    j=calc_states()

    ctr=0
    print('LR(1) Items')
    for s in j:
        print("Item{}:".format(ctr))
        for i in s:
            print("\t", i)
        ctr+=1

    table=make_table(j)
    print('_____________________________________________________________________')
    print("\n\tCLR(1) TABLE\n")
    sym_list = nt_list + t_list
    sr, rr=0, 0
    print('_____________________________________________________________________')
    print('\t|  ','\t|  '.join(sym_list),'\t\t|')
    print('_____________________________________________________________________')
    for i, j in table.items():
            
        print(i, "\t|  ", '\t|  '.join(list(j.get(sym,' ') if type(j.get(sym))in (str , None) else next(iter(j.get(sym,' ')))  for sym in sym_list)),'\t\t|')
        s, r=0, 0

        for p in j.values():
            if p!='accept' and len(p)>1:
                p=list(p)
                if('r' in p[0]): r+=1
                else: s+=1
                if('r' in p[1]): r+=1
                else: s+=1      
        if r>0 and s>0: sr+=1
        elif r>0: rr+=1
    print('_____________________________________________________________________')
    print("\n", sr, "s/r conflicts |", rr, "r/r conflicts")
    print('_____________________________________________________________________')
    print("Enter the string to be parsed")
    Input=input()+'$'
    try:
        stack=['0']
        a=list(table.items())
        print("productions\t:",production_record)
        print('stack',"\t \t\t \t",'Input')
        print(*stack,"\t \t\t \t",*Input,sep="")
        while(len(Input)!=0):
            b=list(a[int(stack[-1])][1][Input[0]])
            if(b[0][0]=="s" ):
                stack.append(Input[0])
                stack.append(b[0][1:])
                Input=Input[1:]
                print(*stack,"\t \t\t \t",*Input,sep="")
            elif(b[0][0]=="r" ):
                s=int(b[0][1:])
                l=len(production_record[s])-3
                prod=production_record[s]
                l*=2
                l=len(stack)-l
                stack=stack[:l]
                s=a[int(stack[-1])][1][prod[0]]
                stack+=list(prod[0])
                stack.append(s)
                print(*stack,"\t \t\t \t",*Input,sep="")
            elif(b[0][0]=="a"):
                print("\n\tThe given string is accepted\n")
                break
    except:
        print('\n\tString is INCORRECT for given Grammar!\n')
    return 

if __name__=="__main__":
    main()
    




