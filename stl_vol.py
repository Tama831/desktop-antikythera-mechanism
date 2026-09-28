import struct, sys, math
def stl_stats(path):
    with open(path,'rb') as f: data=f.read()
    if len(data) < 84: return None
    n=struct.unpack('<I',data[80:84])[0]
    tris=[]
    if 84+n*50 == len(data):
        for i in range(n):
            off=84+i*50
            tris.append([struct.unpack('<3f',data[off+12+j*12:off+24+j*12]) for j in range(3)])
    else:
        import re
        vs=[tuple(map(float,m)) for m in re.findall(r'vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)', data.decode(errors='ignore'))]
        tris=[vs[i:i+3] for i in range(0,len(vs),3)]
    if not tris: return None
    vol=0; xs=[];ys=[];zs=[]
    for a,b,c in tris:
        vol += (a[0]*(b[1]*c[2]-b[2]*c[1]) - a[1]*(b[0]*c[2]-b[2]*c[0]) + a[2]*(b[0]*c[1]-b[1]*c[0]))/6
        for p in (a,b,c): xs.append(p[0]);ys.append(p[1]);zs.append(p[2])
    return abs(vol), (min(zs),max(zs)), max(abs(v) for v in ys), len(tris)
s = stl_stats(sys.argv[1])
if s: print(f"体積 {s[0]:.3f}mm³ z[{s[1][0]:.2f},{s[1][1]:.2f}] |y|max={s[2]:.1f} tris={s[3]}")
else: print("空 (体積0)")
