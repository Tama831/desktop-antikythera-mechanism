"""干渉体積から「座面の薄膜」を除いて数える (v0.7.1)。

Manifold バックエンドは、設計どおり面で接して載っている座面 (例: リング46の溝天井 × 土手上端) を
厚さ ~0.01mm の薄膜として出力する (CGAL は空にする)。連結成分ごとに最小寸法を見て、
0.02mm 未満の成分は「座面の接触」として別勘定にする。出力: "<実体積> <薄膜体積>"
"""
import re
import struct
import sys
from collections import defaultdict


def load(path):
    data = open(path, 'rb').read()
    if len(data) >= 84:
        n = struct.unpack('<I', data[80:84])[0]
        if 84 + n * 50 == len(data):
            return [[struct.unpack('<3f', data[84 + i * 50 + 12 + j * 12:84 + i * 50 + 24 + j * 12]) for j in range(3)]
                    for i in range(n)]
    vs = [tuple(map(float, m)) for m in
          re.findall(rb'vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)', data)]
    return [vs[i:i + 3] for i in range(0, len(vs), 3)]


def main(path, sliver=0.02):
    try:
        tris = load(path)
    except OSError:
        print("0 0")
        return
    parent = {}

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    keys = []
    for t in tris:
        ks = [tuple(round(c, 3) for c in v) for v in t]
        for k in ks:
            parent.setdefault(k, k)
        for k in ks[1:]:
            a, b = find(ks[0]), find(k)
            if a != b:
                parent[a] = b
        keys.append(ks[0])
    comps = defaultdict(list)
    for t, k in zip(tris, keys):
        comps[find(k)].append(t)
    solid = thin = 0.0
    for ts in comps.values():
        pts = [v for t in ts for v in t]
        ext = min(max(p[i] for p in pts) - min(p[i] for p in pts) for i in range(3))
        vol = abs(sum((a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0])
                       + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6 for a, b, c in ts))
        if ext < sliver:
            thin += vol
        else:
            solid += vol
    print(f"{solid:.3f} {thin:.3f}")


if __name__ == '__main__':
    main(sys.argv[1])
