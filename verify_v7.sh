#!/bin/bash
# v0.7.1 全数検証 (Manifold バックエンド — CGAL と同体積・約100倍速)
# 判定: 出力 STL が無い/三角形0 = 空。collide/bite は空が合格 (受容台帳の値以下なら可)、engage は非空が合格
cd "$(dirname "$0")"
OUT=${TMPDIR:-/tmp}/v7chk.stl
vol() { rm -f "$OUT"; openscad --backend=Manifold "$@" -o "$OUT" meguru_v6.scad >/dev/null 2>&1
        [ -s "$OUT" ] && python3 stl_solid.py "$OUT" 2>/dev/null | awk '{print $1}' || echo 0; }
# ↑ 実体積のみ (厚さ<0.02mm の座面薄膜は除外 — 設計どおり面で載る接触。stl_solid.py 参照)
sweep() { # label PART PAIR angles...
  local label=$1 part=$2 pair=$3; shift 3; local line="$label:" worst=0
  for a in "$@"; do v=$(vol -D "PART=\"$part\"" -D "PAIR=$pair" -D "ANGLE=$a"); v=${v:-0}
    line="$line $v"; worst=$(python3 -c "print(max($worst, $v))"); done
  echo "$line  → 最大 $worst"; }
echo "== A層 collide (空=合格) =="
sweep collide collide 0 0 22.5 45 67.5 90 112.5 135 157.5
sweep collide_sun collide_sun 0 0 30 45 90 140 150 160 170 176 180 184 190 215 225 270 315
sweep collide_prec collide_prec 0 0 45 90 135 180 225 270 315
echo "== bite (受容台帳以下=合格) =="
sweep PAIR2 bite_pair 2 0 3.9 90 180
sweep PAIR3 bite_pair 3 0 7 14 21 28 90 100 111
sweep PAIR4 bite_pair 4 0 3.9 90 180
sweep PAIR5 bite_pair 5 0 12 25 37 90
sweep PAIR6 bite_pair 6 0 6 12 18 25 31 37 43
sweep PAIR7 bite_pair 7 0 45 90 135
sweep PAIR8 bite_pair 8 0 1 2 3 4
sweep PAIR9 bite_pair 9 0 1 2 3 4
sweep PAIR10 bite_pair 10 0 4 8 12
sweep PAIR11 bite_pair 11 0 6 13 19
sweep PAIR12 bite_pair 12 0 29 59 88
sweep PAIR13 bite_pair 13 0 134 269 403
sweep PAIR14 bite_pair 14 0 1455 2911 4366
echo "== engage (非空=合格) =="
line="engage:"; for p in $(seq 1 16); do v=$(vol -D 'PART="engage"' -D "PAIR=$p"); line="$line EP$p=${v:-0}"; done; echo "$line"
echo "== 完了 =="
