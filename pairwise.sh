#!/bin/bash
# 総当たり (20剛体の全ペア × 角度) と重力の確認 (剛体を 0.3 下げる)。v0.7.3: 置き方 (三脚+足輪)・モーター・床を追加し、
# 手回し (MOTOR_MODE=0) とモーター (=1) の2モードで回す。モーター時は足される剛体 (18 揺りかご+モーター) を含むペアだけ。
# 付け替え経路 (七つ目の網): モーター時に、揺りかご+モーターを前へ滑らせて外す道筋が空いているか
# 出力: 噛み合い・圧入の相手以外で重なったペア / 下で受けるものが無い剛体。座面の薄膜 (<0.02mm) は stl_solid.py で別勘定
cd "$(dirname "$0")"
OUT=${TMPDIR:-/tmp}/pw.stl
NAMES=(ベース 地平環 背骨 遊星 中心軸一式 リング46 心臓 冠傘 サロス環 サロス中間 冠アイドラ st1 天球 W1P1 W2P2 縦シャフト ノブ 三脚+足輪 揺りかご+モーター 床)
PARTNERS=" 3-4 3-5 5-9 8-9 5-10 10-11 11-12 5-6 6-7 4-13 13-14 14-15 2-15 4-16 "
nz() { python3 -c "import sys; sys.exit(0 if float('$1')>0.0005 else 1)"; }
measure() {   # $1=I $2=J $3=CA $4=MOTOR_MODE $5=GRAV → "実体積 薄膜"
  rm -f "$OUT"
  openscad --backend=Manifold -D 'PART="none"' -D I=$1 -D J=$2 -D CA=$3 -D MOTOR_MODE=$4 -D GRAV=$5 -o "$OUT" pairwise.scad >/dev/null 2>&1
  python3 stl_solid.py "$OUT"
}
bad=0
for MM in ${MODES:-0 1}; do
  if [ $MM -eq 0 ]; then label=手回し; else label=モーター; fi
  for CA in ${CAS:-0 25}; do
    echo "== [$label] 総当たり ca=$CA =="
    for i in $(seq 0 18); do for j in $(seq $((i+1)) 19); do
      [[ "$PARTNERS" == *" $i-$j "* ]] && continue
      touches=0; for k in $i $j; do [ $k -eq 16 ] || [ $k -eq 18 ] && touches=1; done   # 16 (ノブ) も軸がモーター軸と並ぶので見る
      [ $MM -eq 1 ] && [ $touches -eq 0 ] && continue                  # モーター時: 手回し時と同じペアは省く
      [ $MM -eq 0 ] && { [ $i -eq 18 ] || [ $j -eq 18 ]; } && continue  # 手回し時: 18 は空
      read solid thin <<< "$(measure $i $j $CA $MM 0)"
      if nz "$solid"; then echo "  ⚠️ ${NAMES[$i]} × ${NAMES[$j]}  実体積=$solid"; bad=$((bad+1)); fi
    done; done
    echo "== [$label] 重力 ca=$CA (0.3 下げて受けるものがあるか) =="
    for i in $(seq 0 18); do
      [ $MM -eq 0 ] && [ $i -eq 18 ] && continue
      read solid thin <<< "$(measure $i 0 $CA $MM 1)"
      if nz "$solid" || nz "$thin"; then echo "  ✅ ${NAMES[$i]} は受けられている"
      elif [ $i -eq 16 ]; then echo "  ℹ️ ${NAMES[$i]} は軸への軽圧入 (D カット) で保持 — 摩擦保持は設計どおり (モーター軸の先端とは1mm 空けてある)"
      elif [ $i -eq 18 ]; then echo "  ℹ️ ${NAMES[$i]} はローレットねじ2本でベースの受け柱に吊る — ねじ保持は設計どおり"
      else echo "  ⚠️ ${NAMES[$i]} は宙に浮いている"; bad=$((bad+1)); fi
    done
  done
  if [ $MM -eq 1 ]; then
    echo "== [モーター] 付け替え経路 (揺りかご+モーターを前へ滑らせて外す) =="
    rm -f "$OUT"; openscad --backend=Manifold -D 'PART="none"' -D PATH=1 -D MOTOR_MODE=1 -o "$OUT" pairwise.scad >/dev/null 2>&1
    read solid thin <<< "$(python3 stl_solid.py "$OUT")"
    if nz "$solid"; then echo "  ⚠️ 道筋が塞がっている  実体積=$solid"; bad=$((bad+1)); else echo "  ✅ 前へ45 → 2.5 持ち上げ → 前へ85 で当たりなし (座面の擦り=$thin)"; fi
  fi
done
echo "== 完了: 要対応 $bad 件 =="
