// Part B「置き方」の触れる比較 (2026-09-28) の記録 — たまさんが B (アーミラリーの三脚+足輪) を選び、正典 meguru_v6.scad へ移した。
// ここに残すのは選ばなかった A 三つ足 / C 台座ドラム と、比較の場面を描き直すための枠だけ。
// B・揺りかご・28BYJ-48 の実体は正典側 (tripod_legs / foot_ring / motor_cradle / motor_28byj48)。
// 使い方: openscad -D 'PART="none"' -D OPT=1..3 [-D MOTOR_MODE=1] -D 'SP="scene"' stands.scad
//   ※本体 meguru_v6.scad は知らない PART 名だと末尾の else で全体組立を描くので、本体には PART="none" を渡す
include <meguru_v6.scad>
SHOW_STAND = 0;   // 正典の組立図が描く B を消し、ここで OPT の案を描く
SP = "scene";
OPT = 2;          // 1=A 三つ足 / 2=B 三脚+足輪 (正典) / 3=C 台座ドラム

// ---------- A 三つ足 ----------
module stand_A() {
  for (a = LEG_AZ) rotate([0,0,a]) translate([64, 0, 0]) {
    translate([0,0,-2]) cylinder(d = 16, h = 2);                                          // 上の座 (ベース下面に接着/ねじ)
    translate([0,0,-STAND_H + 2]) cylinder(d1 = 8, d2 = 11, h = STAND_H - 4);            // 脚 (細くなる円錐)
    translate([0,0,-STAND_H]) cylinder(d1 = 15, d2 = 12, h = 2);                          // 足先の座
  }
}

// ---------- B アーミラリーの三脚 + 足輪 (正典) ----------
module stand_B() { tripod_legs(); foot_ring(); }

// ---------- C 台座ドラム ----------
module stand_C() {
  difference() {
    union() {
      translate([0,0,-STAND_H]) difference() { cylinder(r = 72, h = STAND_H); translate([0,0,-1]) cylinder(r = 69, h = STAND_H + 2); }
      translate([0,0,-STAND_H]) difference() { cylinder(r = 75, h = 3); translate([0,0,-1]) cylinder(r = 69, h = 5); }   // 裾
      translate([0,0,-6]) difference() { cylinder(r = 72, h = 6); translate([0,0,-1]) cylinder(r = 66, h = 8); }          // 上縁 (ベースの継ぎ目も抱く)
    }
    for (a = LEG_AZ) rotate([0,0,a]) {                                                    // アーチ窓 ×3 (手回しノブへ手が届く/中が見える)
      translate([60, -22, -STAND_H + 6]) cube([20, 44, 14]);
      translate([60, 0, -STAND_H + 20]) rotate([0,90,0]) cylinder(r = 22, h = 20);
    }
  }
}
module stand_C_parts() {   // 中の電子部品 (見た目の目安): ULN2003 基板 35×32 / ESP32 開発ボード 52×28
  color("#2f6b3a") translate([-52, -16, -STAND_H]) cube([32, 35, 14]);
  color("#1d1d1d") translate([18, -55, -STAND_H]) rotate([0,0,35]) cube([52, 28, 11]);   // 四隅 r≤65.6 (壁 r69 の内)・モーターの配線カバーから7離す
}

module stand_only(opt) { if (opt == 1) stand_A(); if (opt == 2) stand_B(); if (opt == 3) stand_C(); }
module stand(opt) { if (opt == 1) color("#8a7020") stand_A(); if (opt == 2) color("#8a7020") stand_B(); if (opt == 3) { color("#8a7020") stand_C(); stand_C_parts(); } }

module scene(opt, ca) {   // モーター/手回しは -D MOTOR_MODE で切り替える
  assembly(explode = 0, ca = ca);
  stand(opt);
  color("#e9e4d8", 0.35) translate([0,0,-STAND_H - 2]) cylinder(r = 110, h = 2);          // 床 (目安)
}

if (SP == "scene") scene(OPT, 25);
if (SP == "turn") rotate([0,0,$t*360]) scene(OPT, $t*360);
if (SP == "check_stand")   // 置き方 × 機械 (ベースとの接着面の薄膜は別勘定)
  intersection() { stand_only(OPT); union() { base(); ub_caps(); motor_group(); translate([0,0,AXLE_BOT - 7]) hand_knob(); } }
if (SP == "stand_only") stand_only(OPT);
