// v0.7.2 総当たり検査 (五つ目の網) と重力の確認 (六つ目の網)。
// 総当たり: 全部品を17の剛体に分け、全ペア (i<j) の交差体積を測る。collide は「回るもの×固定物」、
//   bite は「噛み合う相手」だけを見るので、回るもの同士の非噛合ペアが死角だった
//   (2026-09-28: サロス環 × st1/冠アイドラ の 324/42mm³、環 × ベース板の 2566mm³ がこの死角に6週間いた)。
// 重力 (GRAV=1): 剛体 I を 0.3 下げて、噛み合う相手以外の全剛体と交わるか = 「下で何かが受けている」か。
//   CAD の中の部品は宙に浮いても回るので、支えの有無はこれでしか見えない。
// 使い方: openscad --backend=Manifold -D 'PART="none"' -D I=a -D J=b -D CA=角度 [-D GRAV=1] pairwise.scad
include <meguru_v6.scad>
I = 0; J = 1; CA = 0; GRAV = 0;
N_BODY = 17;
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
  if (i == 16) translate([0,0,AXLE_BOT - 7]) rotate([0,0,axle_a]) hand_knob();         // 手回しノブ (D カット軽圧入)
}

if (GRAV == 0) intersection() { body(I, CA); body(J, CA); }
else intersection() {
  translate([0,0,-0.3]) body(I, CA);
  union() { for (j = [0:N_BODY-1]) if (j != I && !is_partner(I, j)) body(j, CA); }
}
