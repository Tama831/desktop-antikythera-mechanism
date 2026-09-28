#!/bin/bash
# 総当たり (17剛体の全ペア × 角度) と重力の確認 (全可動剛体を 0.3 下げる)。
# 出力: 噛み合い・圧入の相手以外で重なったペア / 下で受けるものが無い剛体。座面の薄膜 (<0.02mm) は stl_solid.py で別勘定
cd "$(dirname "$0")"
OUT=${TMPDIR:-/tmp}/pw.stl
NAMES=(ベース 地平環 背骨 遊星 中心軸一式 リング46 心臓 冠傘 サロス環 サロス中間 冠アイドラ st1 天球 W1P1 W2P2 縦シャフト 手回しノブ)
PARTNERS=" 3-4 3-5 5-9 8-9 5-10 10-11 11-12 5-6 6-7 4-13 13-14 14-15 2-15 4-16 "
nz() { python3 -c "import sys; sys.exit(0 if float('$1')>0.0005 else 1)"; }
bad=0
for CA in ${CAS:-0 25}; do
  echo "== 総当たり ca=$CA =="
  for i in $(seq 0 15); do for j in $(seq $((i+1)) 16); do
    [[ "$PARTNERS" == *" $i-$j "* ]] && continue
    rm -f "$OUT"; openscad --backend=Manifold -D 'PART="none"' -D I=$i -D J=$j -D CA=$CA -o "$OUT" pairwise.scad >/dev/null 2>&1
    read solid thin <<< "$(python3 stl_solid.py "$OUT")"
    if nz "$solid"; then echo "  ⚠️ ${NAMES[$i]} × ${NAMES[$j]}  実体積=$solid"; bad=$((bad+1)); fi
  done; done
  echo "== 重力 ca=$CA (0.3 下げて受けるものがあるか) =="
  for i in $(seq 1 16); do
    rm -f "$OUT"; openscad --backend=Manifold -D 'PART="none"' -D I=$i -D GRAV=1 -D CA=$CA -o "$OUT" pairwise.scad >/dev/null 2>&1
    read solid thin <<< "$(python3 stl_solid.py "$OUT")"
    if nz "$solid" || nz "$thin"; then echo "  ✅ ${NAMES[$i]} は受けられている"
    elif [ $i -eq 16 ]; then echo "  ℹ️ ${NAMES[$i]} は軸への軽圧入 (D カット) で保持 — 摩擦保持は設計どおり"
    else echo "  ⚠️ ${NAMES[$i]} は宙に浮いている"; bad=$((bad+1)); fi
  done
done
echo "== 完了: 要対応 $bad 件 =="
