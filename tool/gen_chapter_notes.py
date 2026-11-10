# Zdroj: tool/chapter_notes/NN.txt, řádky "kap:verš druh Nadpis | text" v ANGLICKÉM (BKR) číslování.
# Výstup: assets/content/chapter_notes/NN.json v kanonickém (hebrejském) číslování.
import json,re,sys,glob,os,sqlite3
here=os.path.dirname(os.path.abspath(__file__))+'/chapter_notes'
root=os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
dart=open(root+'/lib/domain/services/versification_data.dart',encoding='utf-8').read()
e2h=dart.split('const engToHebRuns =')[1].split(';\n')[0]
runs=[list(map(int,r.split())) for r in ''.join(re.findall(r"'([^']*)'",e2h)).split(';') if r.strip()]
def conv(b,c,v):
    for B,C,V,C2,V2,L in runs:
        if B==b and C==c and V<=v<V+L: return C2,V2+(v-V)
    return c,v
db=sqlite3.connect(root+'/assets/db/bible.db')
counts={(b,c):n for b,c,n in db.execute("select book_id,chapter,verse_count from chapters where translation_id='BKR'")}
nch={}
for (b,c) in counts: nch[b]=max(nch.get(b,0),c)
out=root+'/assets/content/chapter_notes'
os.makedirs(out,exist_ok=True)
err=0; total=0; missing=[]
for f in sorted(glob.glob(here+'/*.txt')):
    book=int(os.path.basename(f)[:2])
    d={}; seen=set()
    for ln,line in enumerate(open(f,encoding='utf-8'),1):
        line=line.strip()
        if not line or line.startswith('#'): continue
        m=re.match(r'^(\d+):(\d+) ([czlm]) (.+?) \| (.+)$',line)
        if not m: print(f'{f}:{ln}: bad line: {line[:70]}'); err+=1; continue
        ch,v,k,t,x=m.groups(); ch=int(ch); v=int(v)
        if v>counts.get((book,ch),0): print(f'{book} {ch}:{v} out of range'); err+=1; continue
        seen.add(ch)
        C,V=conv(book,ch,v)
        d.setdefault(str(C),[]).append([V,k,t.strip(),x.strip()])
    for ch in d: d[ch].sort(key=lambda n:n[0])
    d=dict(sorted(d.items(),key=lambda kv:int(kv[0])))
    json.dump(d,open(f'{out}/{book:02d}.json','w',encoding='utf-8'),ensure_ascii=False,separators=(',',':'))
    n=sum(len(v) for v in d.values()); total+=n
    miss=[c for c in range(1,nch[book]+1) if c not in seen]
    print(f'{book:2d}: {n} notes, chapters without: {miss[:20]}{"…" if len(miss)>20 else ""}')
print('total',total,'errors',err)
