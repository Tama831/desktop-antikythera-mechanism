// v0.7.2 総当たり検査 (五つ目の網) と重力の確認 (六つ目の網)。v0.7.3 で置き方 (三脚+足輪)・モーター・床を追加
// 総当たり: 全部品を剛体に分け、全ペア (i<j) の交差体積を測る。collide は「回るもの×固定物」、
//   bite は「噛み合う相手」だけを見るので、回るもの同士の非噛合ペアが死角だった
//   (2026-09-28: サロス環 × st1/冠アイドラ の 324/42mm³、環 × ベース板の 2566mm³ がこの死角に6週間いた)。
// 重力 (GRAV=1): 剛体 I を 0.3 下げて、噛み合う相手以外の全剛体と交わるか = 「下で何かが受けている」か。
//   CAD の中の部品は宙に浮いても回るので、支えの有無はこれでしか見えない。
// 使い方: openscad --backend=Manifold -D 'PART="none"' -D I=a -D J=b -D CA=角度 [-D GRAV=1] [-D MOTOR_MODE=1] pairwise.scad
//   16 = 手回しノブ (MOTOR_MODE=0) / カップリング (MOTOR_MODE=1)。18 = 揺りかご+モーター (MOTOR_MODE=1 のときだけ)。19 = 床
include <meguru_v6.scad>
I = 0; J = 1; CA = 0; GRAV = 0;
N_BODY = 20;
// 噛み合う相手・圧入の相手 (重なりが設計どおり — bite/engage で別管理)
PARTNERS = [[3,4],[3,5],[5,9],[8,9],[5,10],[10,11],[11,12],[5,6],[6,7],[4,13],[13,14],[14,15],[2,15],[4,16]];
function is_partner(i, j) = len([for (p = PARTNERS) if ((p[0]==i && p[1]==j) || (p[0]==j && p[1]==i)) 1]) > 0;

module body(i, ca) {
  pae    = PREC_AZ - 3*ca/(PREC_RATIO - 4);
  axle_a = 4*pae - 3*ca;
  w1 = -axle_a*ZB_A/ZB_W + W1_PH;  w2 = -(w1 - W1_PH)*ZB_P/ZB_W + W2_PH;  w3 = -(w2 - W2_PH)*ZB_P/ZB_W3 + W3_PH;
  if (i == 0)  { base(); ub_caps(); }                                                  // 固定 (軸端キャップは瞬着)
  if (i == 1)  translate([0,0,70]) horizon_ring();
  if (i == 2)  rotate([0,0,pae]) spine();
  if (i == 3)  rotate([0,0,pae]) for (a = [0,180]) rotate([0,0,a]) {
                 translate([PLNT_R,0,9]) rotate([0,0, 3*ca - 3*pae - a + PLNT_PH]) planet_gear();
                 translate([PLNT_R,0,13.2]) stud_cap(); }
  if (i == 4)  { translate([0,0,9]) rotate([0,0,axle_a + SUN_PH]) sun_gear();         // 中心軸一式 (太陽・真鍮・ピニオンA — 圧入で一体)
                 translate([0,0,AXLE_BOT]) cylinder(d = AXLE_D, h = 13 - AXLE_BOT);
                 translate([0,0,-4.9]) rotate([0,0,axle_a + A_PH]) ub_pinionA(); }
  if (i == 5)  translate([0,0,9]) rotate([0,0,ca]) ring46();
  if (i == 6)  rotating_heart(ca, pae);
  if (i == 7)  rotate([0,0,pae]) translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) translate([0,0,BOSS_TOP]) bevel_sun();
  if (i == 8)  rotate([0,0, -ca*SAROS_RATIO + SAROSR_PH]) for (k = [0:2]) rotate([0,0,k*120]) translate([0,0,H_SAROS]) saros_seg(k);
  if (i == 9)  rotate([0,0,IDLER_A]) translate([IDLER_R,0,H_SAROS]) rotate([0,0, -ca*Z_CAGE/Z_IDLER + SIDL_PH]) saros_idler();
  if (i == 10) translate([CIDL_XY[0], CIDL_XY[1], CIDL_Z]) rotate([0,0, -ca*Z_CAGE/Z_CIDLA + CIDL_PH]) crown_idler();
  if (i == 11) translate([ST1_XY[0], ST1_XY[1], ST1_Z]) rotate([0,0, ca*(Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A) + ST1_PH]) st1_carrier();
  if (i == 12) translate([0,0,TR_ZT]) rotate([0,TILT,0]) rotate([0,0, ca*RING_RATIO + RING_PH]) tilt_ring();
  if (i == 13) translate([S1_XY[0], S1_XY[1], -4.9]) rotate([0,0,w1]) ub_w1p1();
  if (i == 14) translate([S2_XY[0], S2_XY[1], -3.6]) rotate([0,0,w2]) ub_w1p1();
  if (i == 15) translate([S3_XY[0], S3_XY[1], 0]) {                                     // 縦シャフト一式 (W3・真鍮・提灯)
                 translate([0,0,-2.3]) rotate([0,0,w3]) ub_w3();
                 translate([0,0,-3.5]) cylinder(d = AXLE_D, h = 9.9);
                 translate([0,0,3.1]) rotate([0,0,w3 + LNT_PH]) ub_lantern(); }
  if (i == 16) translate([0,0,AXLE_BOT - 7]) rotate([0,0,axle_a]) hand_knob();           // ノブ兼カップリング (D カット軽圧入・下面の横溝にモーター軸)
  if (i == 17) { tripod_legs(); foot_ring(); }                                          // 置き方 (脚は座面に瞬着・足輪にピン)
  if (i == 18 && MOTOR_MODE == 1) motor_group(axle_a);                                  // 揺りかご+28BYJ-48+ねじ類 (受け柱に下から留める)
  if (i == 19) translate([0,0,-STAND_H - 5]) cylinder(r = 120, h = 5);                  // 床 (机の天板)
}

// 付け替え経路 (PATH=1・七つ目の網): 揺りかご+モーターを「前へ45 → 上へ2.5 → さらに前へ85」滑らせた掃引体と、残り全部の交差。
//   ローレットねじは先に抜くので掃引に入れない。軸角0 (ノブの溝が前を向き、モーター軸の平らな面が ±x を向く位置) で見る
PATH = 0;
if (PATH == 1) intersection() {
  union() {
    for (seg = [[[0,0,0],[0,-45,0]], [[0,-45,0],[0,-45,2.5]], [[0,-45,2.5],[0,-130,2.5]]])
      for (c = [0:10]) hull() { translate(seg[0]) motor_convex_part(c); translate(seg[1]) motor_convex_part(c); }
  }
  union() {
    for (j = [0:15]) body(j, 0);
    translate([0,0,AXLE_BOT - 7]) hand_knob();            // 溝が前 (-y) を向く角度
    body(17, 0); body(19, 0);
  }
}
module motor_convex_part(c) {   // 揺りかご+モーターを凸な部品に分けたもの (凸なら hull(始点, 終点) = 正確な掃引)
  if (c == 0) translate([0,0,MOTOR_FACE]) linear_extrude(height = 3) hull() {
    for (p = CRADLE_POSTS) translate(p) circle(d = 10);
    for (s = [-1, 1]) translate([s*17.5, -8]) circle(r = 5);
    circle(d = 14);
  }
  if (c == 1) translate([0,-8,MOTOR_FACE - 19]) cylinder(d = 28, h = 19);
  if (c == 2) hull() for (s = [-1, 1]) translate([s*17.5, -8, MOTOR_FACE - 0.8]) cylinder(r = 3.5, h = 0.8);
  if (c == 3) translate([0,0,MOTOR_FACE]) cylinder(d = 9, h = 1.5);
  if (c == 4) translate([0,0,MOTOR_FACE]) cylinder(d = 5, h = 4);
  if (c == 5) translate([0,0,MOTOR_FACE + 4]) intersection() { cylinder(d = 5, h = 6); translate([-1.5,-3,0]) cube([3, 6, 6]); }
  if (c == 6) translate([-7.3, -25, MOTOR_FACE - 18.5]) cube([14.6, 9, 17]);
  if (c == 7) translate([-17.5, -8, CRADLE_TOP - 8]) cylinder(d = 3, h = 8);
  if (c == 8) translate([17.5, -8, CRADLE_TOP - 8]) cylinder(d = 3, h = 8);
  if (c == 9) translate([-17.5, -8, MOTOR_FACE - 3.2]) rotate([0,0,30]) cylinder(d = 6.35, h = 2.4, $fn = 6);
  if (c == 10) translate([17.5, -8, MOTOR_FACE - 3.2]) rotate([0,0,30]) cylinder(d = 6.35, h = 2.4, $fn = 6);
}

if (PATH == 1) { }
else if (GRAV == 0) intersection() { body(I, CA); body(J, CA); }
else if (GRAV == 1) intersection() {
  translate([0,0,-0.3]) body(I, CA);
  union() { for (j = [0:N_BODY-1]) if (j != I && !is_partner(I, j)) body(j, CA); }
}
