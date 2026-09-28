// ============================================================
// 巡る天の心臓 v0.6a — 歳差の背骨 (真・3軸トゥールビヨン)
//
// v0.6a 新機構 — 心臓部の回転軸そのものが円錐を描く「歳差」:
//   考証 = 月軌道の昇交点歳差 18.61年 ≈ 230朔望月 → 1/228 (誤差1%・逆行)。傾き12° (5.1°の誇張)。
//   入力は中心の裏ノブ/モーター → 駆動軸 (垂直 z-18..13) → 太陽12T (z9-13)
//   → 遊星12T×2 (ターンテーブル上スタッド r18・az0/180) → 複合リング内歯36
//   → リングが回る (ω_ring = -ω_axle/3)。リング外歯46T が旧かご46Tと同一バンド z9-13 で
//   下流 (サロス/天球輪列) を完全無改造のまま駆動。リング上面ピン24本 (r28.7, z13-16) が
//   かごコア下面の冠歯24 (r25-28) を 12°差のピン×冠で 1:1 駆動 → 傾いた心臓部が回る。
//   心臓部 (かごコア+フレーム+月+秤動系) は「背骨」= ターンテーブル小円盤 (r18.5, z1-3)
//   + 傾斜柱2本 (y±14・リブ楕円断面) + 傾斜プレート (r16) + ボス (d8, 局所z12-31) に乗る。
//   ターンテーブルを回すと傾き方位が回る = 歳差 (v0.6a は手回し, v0.6b で 1/228 自動化)。
//   ※fix25 (設計検算で捕捉): v6-design の「遊星3個・接地スタッド+柱y±8」は不成立 —
//     太陽歯先10.5 > 遊星内到達7.5 で r1.8-28.5 が全周「放射壁」になり、歳差柱がどの半径でも
//     遊星帯 (z9-13) を縦断できない。遊星2個 ((36+12)/2=24 整数 ✓) をターンテーブル
//     (=歳差キャリア) に移し、柱 (az±90) と遊星 (az0/180) を同一回転体で相対固定して解決。
//     キャリア微回転によるリング速度誤差 = (4/3)/228 ≈ 0.6% (歳差→駆動の実結合・表示上無視可)。
// 凍結: v0.5 完成版 = meguru_v4.scad (触らない)。以下 v0.5 までの説明は継承 —
//
// (v0.4a 継承) 秤動の月 (楕円歯車ペア・2軸+脈動)
//
// 第1軸: 外かご (垂直軸・46T 駆動) / 第2軸: 内かごフレーム (水平軸・傘24:24=1.0自転/公転 — v0.5-C)
// v0.4a 新機構 — 月の経度秤動 (libration):
//   焦点軸支の同一楕円歯車ペア (a=6, e=0.25, 軸間 2a=12) + 戻り平歯車 12T×12T (m1, 軸間12)。
//   E1楕円 = かご+x腕に一体 (かご固定=基準) / E2楕円+P12T = フレームリング外面の
//   スタッド (r12) 上でフリー回転 / G12T+月球 = 真鍮軸に接着 (軸ごとジャーナル回転)。
//   伝達関数 F(θ) = 2·atan(((1-e)/(1+e))·tan(θ/2)) — ケプラーの真近点角変換と同型。
//   月の角度 = inner_a − F(inner_a) → 正味自転ゼロ + 首振り ±28.5° (e=0.25)・1うなずき/公転。
//   月は機械中心を向いたまま (同期自転)、垂直回転で位相が1公転1周し、秤動でうなずく。
//   ※誇張の考証: 実月の経度秤動 ±7.9° → 本作 ±28.5° (振幅のみ誇張・v0.2 ±33°と同じ精神)。
//     周期は v0.5-C のマイター化 (フレーム1自転/公転) で実月と同じ1うなずき/公転になった。
//     フレーム=月の額縁自体が1自転/公転 = 月の自転周期の考証もこれで一致。
//   ※v0.3b の差動傘12T (2.5自転/公転・ペア5近似噛み) は本方式で不要になり削除 —
//     近似ペアが消え、噛合は全ペア厳密になった。2軸版の退避先 = meguru_v3_2axis.scad (凍結)。
//   ※真鍮軸は v0.3b の「腕に圧入」から「腕2+E1スリーブ=計3ジャーナルで回転」に変更。
//     月球・G は軸に瞬着 (中央まで圧入摺動できないため。clocking 調整も利く)。
// 段階: v0.4a 秤動 ✓ → v0.4b 傾く天球 ✓ (本ファイル。黄道傾斜23.4°リング+冠76駆動 1/12.39=年周) → v0.4c 印刷準備。
// 外周: サロス減速輪列・黄道リング・電動系は v0.2.2 から不変。
// 1軸完成版 = meguru_ten_no_shinzo.scad (凍結) / 2軸版 = meguru_v3_2axis.scad (凍結)
// ============================================================

PART = "assembly"; // base | bevel_sun | bevel_pinion | cage(旧) | cage_core | inner_frame | moon_globe
                   // | e2p | ret_gear | ell_test | stud_cap
                   // | ring46 | sun_gear | planet_gear | spine   (v0.6a 歳差の背骨)
                   // | pillar_bridge | crank_pinion(退役) | crank_handle(退役)
                   // | saros_seg | saros_idler | zodiac_half | motor_mount | coupling | hand_knob
                   // | assembly | exploded | anim | anim_prec | collide | collide_prec
                   // | mesh_self_pin | mesh_self_moon | mesh_self_e2p | mesh_self_ret | mesh_ell | bite_pair(2-10)

$fn = (PART == "anim" || PART == "anim_prec" || PART == "turntable") ? 40
    : (PART == "collide" || PART == "collide_sun" || PART == "collide_heart" || PART == "collide_sky" || PART == "collide_prec") ? 24 : 96;   // bite_pair は 96 必須 (24だとCGALが退化出力=偽陰性)

// ---------- 共通 ----------
AXLE_D = 3.0; AXLE_FIT = 3.2; AXLE_PRESS = 2.85;
GEAR_H = 4;
M_MAIN = 1.5;
Z_CRANK = 12; Z_CAGE = 46;
CRANK_DIST = M_MAIN*(Z_CRANK+Z_CAGE)/2;   // 43.5

// 第2軸系 (v0.3a ベベル版)
BEV_SUN_T = 24;    // v0.5-C: 30→24 — 1:1マイター化 (フレーム1自転/公転 = 月の自転の考証)
BEV_PIN_T = 24;    // v0.5-C: 15→24 — 比 24/24 = 1.0 (秤動も1うなずき/公転に — 実月と同周期)
BEV_SUN_R = 12;    // 固定傘の外半径
GLOBE_Z  = 43;     // 第2軸高さ (v0.3a-fix2: 月球と固定傘の分離)
INNER_R  = 15;     // 内かごリング半径 (v0.3b: 内径12 — 遊星歯先11.2 が収まる)
INNER_Y  = 14.5;   // リング中心面 (v0.3b: y+ 側の1枚のみ)
// --- 秤動輪列 (v0.4a) — v0.3b の差動傘 12T は削除 (近似ペア5消滅) ---
A_ELL  = 6;        // 楕円歯車 半長径 → 軸間 2a = 12
E_ELL  = 0.25;     // 離心率 → 秤動振幅 ≈ 2e rad = ±28.5° (実月±7.9°の誇張)
Z_ELL  = 16;       // 楕円歯数 (両輪同一・位相0/0.5)
TH_ELL = 2.2;      // 楕円歯車厚
Z_RET  = 12; M_RET = 1.0; TH_RET = 2.2;   // 戻り平歯車 P×G — 軸間 m(12+12)/2 = 12 = 2a (共用)
STUD_R = 2*A_ELL;  // カウンタースタッド半径位置 = 12 (楕円・戻り両ペアの軸間)
RET_X  = 16.4;     // P/G ペアの x 開始 (リング外面16 + 0.4)
ELL_X  = RET_X + TH_RET + 0.3;   // 18.9 — E1/E2 ペアの x 開始
SLV_X  = ELL_X + TH_ELL;         // 21.1 — E1 背後の一体スリーブ開始 (腕面まで)
CAP_X  = SLV_X + 0.3;            // 21.4 — スタッド端・接着キャップ位置
ARM_Y  = 23.5;     // 直立アーム内面 (v0.4a: 22.5→23.5 — 秤動輪列+キャップの逃げ 1.1 確保)

CAGE_R = 35; CAGE_H = 3.5;
H_SAROS = 2.5;     // v0.6a: 4→2.5 — セグ帯 2.5-7.5 (グランド z 再割り当て)
H_CAGE = 16;
BOSS_TOP = 31;     // v0.5-C: 33→31 (45°傘は同じ外径r12でz31まで裾が下がる)。v0.6a ではプレート局所座標
BRIDGE_H = 47;     // クランク軸受け弦腕 (v0.6a: クランク系ごと退避 — 入力は中心軸へ)
CRANK_TOP = 53;

// --- v0.6a 歳差の背骨 ---
PREC_TILT = 12;    // 歳差の傾き (月軌道傾斜5.1°の誇張。クラスタ天井 ≈67.8 < 地平環70 検算済)
PREC_Z  = 7.2;     // ピボット高さ (心臓部フレーム z0 面が乗る空間高さ)。冠歯最下点 13.5 > リング上面 13
PREC_AZ = 0;       // 歳差方位 (v0.6a は手回しパラメータ。anim では誇張スイープ)
TT_R    = 20.2;    // ターンテーブル小円盤 (z1-3)。v0.6b: 18.5→20.2 — 冠環43T (根元19.9-20.25) の座
PIL_Y   = 14;      // 傾斜柱 y±14 (az±90)。内側面 |y|=11.5 > 太陽歯先10.5 / 遊星(az0/180)とはキャリア同体
PLATE_R = 16;      // 傾斜プレート (局所 z10-12)。縁の最下点 13.65 > リング上面 13
Z_SUN = 12; Z_PLNT = 12; Z_RINT = 36;   // 太陽/遊星/リング内歯 (m1.5)。組立条件 (36+12)/2=24 整数 ✓
PLNT_R = M_MAIN*(Z_SUN+Z_PLNT)/2;       // 遊星スタッド半径 = 18
RING46_RATIO = -Z_SUN/Z_RINT;           // ω_ring/ω_axle = -1/3 (キャリア静止時)
PIN_N = 24; PIN_R = 28.7;  // リング上面ピン列 (d2.2, z13-16)。r = 冠ピッチ26.5 の傾斜投影 26.5·cos12+13.4·sin12
CR24_RI = 25; CR24_RO = 28; CR24_TL = 4.6;   // かご下面冠歯24 (ピッチ26.5)
CR24_WR = 4.2; CR24_WT = 1.9;  // 歯幅: 根元4.2→先端1.9 の台形テーパー (fix27 — 傾き射影の方位歪みは
                               // 噛み窓の端 (±48°) で最大2°=1.1mm。歯が浅くしか届かない外方位ほど
                               // すき間が増える形にして、ピンフランク擦り 5.4mm³ を削る)
BANK_RI = 30.0; BANK_RO = 31.4; BANK_TOP = 10.5;  // グランド土手 (リング下面溝 29.7-31.7 の滑り座・紙シム調整)
SUN_PH = 0; PLNT_PH = 15; CAGE_PH = 7.5;  // 描画位相 (bite で追試・調整)

// --- v0.6b 歳差の自動駆動 (地下輪列 2026-08-14 夜) ---
// 上ルートは柱+スタッドの歳差掃引壁 (z3-17, r11-19.5) で不成立 → ベース裏 z-3.9〜-0.5 の平面列。
// 縦シャフト (r24.5, az0) がベースを貫通し、提灯6ピンがターンテーブル上の冠環43Tを回す
M_UB = 0.5;                         // 地下層モジュール
// fix33: 8T/10T は φ3 軸・スタッドに存在できない (歯底円 < 穴半径で胴が消える)。φ3系の最小 ≈13T →
// 「14T→64T ×3段」に再設計。3段で符号も自然に4反転 (最終の提灯×冠環込み) — アイドラ廃止
ZB_A = 14; ZB_W = 64; ZB_P = 14;    // 各段: ピニオン14T → ホイール64T (32/7)。W1P1 / W2P2 の2枚は共用形状
ZB_W3 = 65;                         // fix36: 最終段だけ 65T — 遊星段の連成込みで交点歳差を天文値に合わせる (下の検算参照)
RT_T = 43; M_RT = 1;                // ターンテーブル冠環 43T m1 (ピッチ21.5・z3-5 上乗せ)
LNT_RP2B = M_RT*6/2;                // 提灯ピッチ r3 (6ピン — LANT_PINS はサロス節で後方定義のためリテラル)
PREC_RATIO = pow(ZB_W/ZB_P, 2)*(ZB_W3/ZB_P)*(RT_T/6);   // 軸/ターンテーブル = 695.35
// 遊星段: ω_軸 = 4ω_tt − 3ω_リング、地下輪列: ω_tt = ω_軸/PR (同符号) → 歳差1周 = リング (PR−4)/3 回 (逆行)
//   = 230.45 朔望月 vs 天文 230.05 (交点周期6793.5日) → +0.18%
//   ※fix36 前の「1/684.66・誤差+0.10%」は (a) 天文230でなく設計目標228との比較 (b) 連成の −4 を落としていた。真値は −1.37% だった
AUTO_PREC = 1;                      // 1: pa が ca に従属 (実機通り)。0: 手回し表示 (旧 v0.6a 挙動)
UB_CD  = M_UB*(ZB_P + ZB_W)/2 + 0.25;    // 段軸間 19.75 (+0.25 バックラッシ — W歯先×ピニオン基礎円のマージン0.11確保)
UB_CD3 = M_UB*(ZB_P + ZB_W3)/2 + 0.25;   // 最終段の軸間 20.00
S1_XY = [0, UB_CD];                 // W1P1 スタッド (az90 — スクリューヘッド(0,±26) とは z で棲み分け)
S3_XY = [24.5, 0];                  // 縦シャフト = 冠環ピッチ21.5 + 提灯3 (固定 — 冠環側の幾何で決まる)
// S2 = |S1-S2|=UB_CD・|S2-S3|=UB_CD3 の円交点 (軸から遠い側 — W2 が軸を飲まないように)
UB_D  = norm(S3_XY - S1_XY);
UB_A  = (UB_CD*UB_CD - UB_CD3*UB_CD3 + UB_D*UB_D)/(2*UB_D);
UB_H  = sqrt(UB_CD*UB_CD - UB_A*UB_A);
S2_XY = S1_XY + UB_A*(S3_XY - S1_XY)/UB_D + UB_H*[-(S3_XY[1]-S1_XY[1]), S3_XY[0]-S1_XY[0]]/UB_D;
// 噛合位相の解析解: gear1(位相p1,歯z1) から方位 az の gear2(歯z2) へ「歯↔溝」を渡す
function mesh_phase(p1, z1, z2, az) =
  let (d1 = ((az - p1) % (360/z1) + 360/z1) % (360/z1))       // gear1 の歯ズレ (噛合線基準)
  az + 180 + (0.5 - d1/(360/z1)) * 360/z2;                    // gear2 は溝を向ける (+半ピッチ - 転写)
A_PH  = 15;                                                    // 軸ピニオン (太陽と別クロッキングで圧入)
W1_PH = mesh_phase(A_PH, ZB_A, ZB_W, 90);
W2_PH = mesh_phase(W1_PH, ZB_P, ZB_W, atan2(S2_XY[1]-S1_XY[1], S2_XY[0]-S1_XY[0]));   // P1はW1と同位相(同体)
W3_PH = mesh_phase(W2_PH, ZB_P, ZB_W3, atan2(S3_XY[1]-S2_XY[1], S3_XY[0]-S2_XY[0]));
RT_PH = 180/RT_T;                   // 冠環: pa=0 で az0 (ピン側) に溝
ENGRAVE = 1;                        // v0.7 銘: 案1「考証オマージュ」採用 (2026-08-16 たまさん選定)。0で無刻印・2/3は比較用に残置
LNT_PH = 180 - W3_PH;               // 提灯のクロッキング (組立時接着): ca=0 でピン1本が機械中心を向く

// サロス (v0.2.2 不変)
SAROS_N = 74; SAROS_RP = 55.5; SAROS_RO = 69; SAROS_H = 5;
LANT_PINS = 6; LANT_RP = LANT_PINS*SAROS_RP/SAROS_N;
IDLER_R = SAROS_RP - LANT_RP; Z_IDLER = 22;
LANT_RP2 = LANT_RP;   // fix29b: 真ピッチ4.5へ復帰 — fix19c の0.6縮小が転がり共役を崩し中間位相で
                      // ピン胴×歯フランクが擦っていた (7-11mm³・v0.2以来)。fix19c が避けた2つの干渉は
                      // 歯先短縮 (54.1→54.4・非噛合ピン退避0.15) と セグ壁後退 (56.3→56.8・ピン外縁逃げ0.3) で解決
IDLER_A = 185;   // v0.4b: 240→185 移設 (y-下象限を天球駆動列に明け渡す)
SAROS_RATIO = (Z_CAGE/Z_IDLER)*(LANT_PINS/SAROS_N);
// 旧・固定黄道リング (v0.4b で傾斜天球に発展的解消 — zodiac_half モジュールは退避残置)
ZOD_RI = 44; ZOD_RO = 55; ZOD_H = 4; ZOD_Z = 36;
ZOD_PILLARS = [60, 180, 300];

// --- v0.4b 傾く天球 (黄道傾斜リング) ---
TILT   = 23.4;     // 黄道傾斜角
TR_ZT  = 40;       // 傾斜リング中心の高さ (上面基準・傾斜軸は原点上のこの点を通る)
TR_RI  = 52; TR_RO = 63; TR_H = 4;   // リング半径帯 (内縁「下角」投影 52·cT-4·sT=46.1 > クランク45.0 ✓ 傾斜ずり込み込み)
CROWN_N  = 90;     // 冠歯数 (fix23: 76→90 — 主輪19T小径化との組で年周比を保つ)。本家も冠歯車で軸を曲げた
CROWN_RP = 59;     // 冠ピッチ半径 (面内)。歯体は r57-62.5 — 支柱スイープ(≦52.8)の外 (最悪az180でクリア0.48)
// fix37 (2026-09-28): PAIR6 の噛み込み 6.1-6.7mm³ の正体は4つの塊 — ①傾いた歯先がピン台座に刺さる (最大)
// ②ピン先が天球リング底に刺さる ③④ピン側面×歯側面。8位相スイープで決定 → 最悪 0.26mm³ (95%減)・engage 0.34 (噛み合い実在)
CROWN_TIP_W = 0.5;       // 冠歯の先端幅 (根元1.3 → 先端0.5 の台形・fix27 と同じ手)
ST1_HUB_DROP = 1.8;      // st1 ピン台座 (ハブ太部天面) を 1.8 下げる — 天球23.4°の傾きでハブ幅10.5の間に歯先高さが~2mm変わる
ST1_PIN_TOP_CUT = 1.2;   // 提灯ピン先端を 1.2 詰める (先端 z24.9)
ST1_PIN_D = 1.8;         // 提灯ピン径 2.2→1.8
CROWN_TL = 3.6;    // 冠歯丈 (下面 -4 から -7.6。4.6は冠歯先が az-28 で z11.5 まで沈み45Tと0.3かぶった — fix18)
GROOVE_R = 54.4;   // 下面ガイド溝半径 (内壁52.4=内縁+0.4 / 外壁56.4=冠歯-0.6)。幅4.0 (斜行0.67+ピン1.1+遊び)・深さ2.0
TPIL_AZ  = [150, 215];       // 溝ピン式支柱 (上がり側のみ — 下がり側は冠歯が z10-14 までスイープしピン式が成立しない)
SEAT_AZ  = 20; SEAT_R = 45;  // 下がり側は滑り座式: リング内縁下面を受ける皿 (r45 = 冠歯スイープ内側48.9 の内)
SEAT_TOP = 15.3;             // 座上面 (内縁下面 z≈15.7 − 遊び。印刷後に紙シムで当たり調整 — サロス滑り座と同じ文化)
// 減速列 (v3・fix23 検品13): かご46 → 2段アイドラ22T/11T → 19T+提灯6 → 冠90
// ω_ring/ω_cage = (46/22)·(11/19)·(6/90) = 1/12.391 (実際の年 12.368 — 誤差 0.19%)
// 旧45T (φ70.5) はかごと平面かぶり17.9・サロス被覆83°だった → 19T (φ31.5) でかぶりゼロ・被覆34°
Z_ST1A = 19;       // 提灯キャリア主輪 (z9.2-11.8・内端37.7 > かご歯先36 = 平面かぶりなし)
Z_CIDLA = 22;      // 2段アイドラ かご側 (z12-16)
Z_CIDLB = 11;      // 2段アイドラ 主輪側 (z9.2-11.8)
RING_RATIO = (Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A)*(LANT_PINS/CROWN_N);
CROWN_AZ = -65;    // fix23: -72→-65 (N90でピン円が縮み st1 が外に出るのを相殺・サロスクリア0.52)
// st1 軸 = 冠ピッチ点(空間水平投影)から冠中心向きに提灯ピン円半径ぶん内側 (サロス式の接線配置)
// fix20: 噛合点は歯の実効深さ zl≈-5.8 で計算 (rotate_Y のずり込み x' = xl·cT + zl·sT)
CROWN_MESH_XY = [CROWN_RP*cos(CROWN_AZ)*cos(TILT) - 5.8*sin(TILT), CROWN_RP*sin(CROWN_AZ)];   // ≈ (20.6, -53.5)
CROWN_LRP = LANT_PINS*norm(CROWN_MESH_XY)/CROWN_N;                             // ≈ 3.82 (ピン円ピッチ整合)
ST1_XY = CROWN_MESH_XY * (1 - CROWN_LRP/norm(CROWN_MESH_XY));                  // ≈ (19.2, -49.9) r53.48
CIDL_D1 = M_MAIN*(Z_CAGE + Z_CIDLA)/2;                                         // 51 (かご↔アイドラ22T)
CIDL_D2 = M_MAIN*(Z_CIDLB + Z_ST1A)/2;                                         // 22.5 (アイドラ11T↔19T)
ST1_AZI = atan2(ST1_XY[1], ST1_XY[0]);
CIDL_DAZ = acos((CIDL_D1*CIDL_D1 + norm(ST1_XY)*norm(ST1_XY) - CIDL_D2*CIDL_D2)/(2*CIDL_D1*norm(ST1_XY)));
CIDL_XY = CIDL_D1*[cos(ST1_AZI - CIDL_DAZ), sin(ST1_AZI - CIDL_DAZ)];          // ≈ (-25.7, -35.1) サロスidler/支柱と共存 ✓
// --- 描画位相 (v0.4b-fix16: 歯対溝の位相合わせ — bite スイープで決定。回転レートが正しければ全 ca で保存) ---
CRANK_PH = 15; SIDL_PH = 2.3; SAROSR_PH = -0.3; CIDL_PH = -3.2; ST1_PH = 6.2; RING_PH = -1.8;
// 検品13後の確定 (fix23): PAIR1/2/3/7 = 0.000 / PAIR4 0.001 / PAIR5 0.15 (折れ線近似かすり=合格)
// PAIR6 = 6.1mm3 (水平ピン円×傾斜歯列の3D幾何残差 — N90化でピン円が縮み曲率差が増加。印刷後の歯当たり調整で吸収)

// ---------- インボリュート歯車 (v0.2.2 と同一) ----------
function _inv(a) = tan(a) - a*PI/180;
function _polar(r, th) = [r*cos(th), r*sin(th)];
module gear2d(z, m, pa = 20, ak = 1) {   // ak: アデンダム係数 (v0.6b fix31b: スタブ歯 — 小歯数の非共役干渉逃げ)
  r_p = m*z/2; r_b = r_p*cos(pa); r_a = r_p + ak*m;
  // v0.4a fix: 旧 r_d = max(r_p-1.25m, 0.98·r_b) は小歯数で歯底円盤が太りすぎ
  // (相手歯先と0.2-0.8mm干渉) かつ歯が円盤から浮く (閉じ弦 > 0.98r_b) 二重欠陥。
  // 標準デデンダムに戻し、基礎円下は放射直線フランクで歯元まで延長する
  r_d = r_p - 1.25*m;
  t_a = sqrt(pow(r_a/r_b,2)-1)*180/PI;
  n_pts = 6;
  half_t = 90/z + _inv(pa)*180/PI;
  tooth = [
    _polar(r_d - 0.2, -half_t),               // 歯元アンカー (円盤に0.2埋め込み)
    for (i = [0:n_pts])
      let (t = t_a*i/n_pts, r = r_b*sqrt(1+pow(t*PI/180,2)), phi = t - atan(t*PI/180))
      _polar(min(r, r_a), -half_t + phi),
    for (i = [0:n_pts])
      let (t = t_a*(n_pts-i)/n_pts, r = r_b*sqrt(1+pow(t*PI/180,2)), phi = t - atan(t*PI/180))
      _polar(min(r, r_a), half_t - phi),
    _polar(r_d - 0.2, half_t)                 // 歯元アンカー (反対側)
  ];
  union() { circle(r = r_d); for (k = [0:z-1]) rotate([0,0,k*360/z]) polygon(tooth); }
}
module gear(z, m, h = GEAR_H, bore = AXLE_FIT, pa = 20) {
  linear_extrude(height = h) difference() { gear2d(z, m, pa); circle(d = bore); }
}

// ---------- 楕円歯車 (v0.4a 秤動用・台形歯) ----------
// 焦点軸支の同一2枚: r1+r2 = 2a = 一定 → 軸間固定のまま角速度だけ脈打つ。
// 歯は等弧長配置 (弧長テーブル + lookup 逆引き)。転がり接触は弧長対応を保存する
// ので、初期位相 (E1=0 / E2=0.5) さえ合えば全周で歯-溝が維持される。
function ell_r(th)  = A_ELL*(1 - E_ELL*E_ELL)/(1 + E_ELL*cos(th));
function ell_pt(th) = ell_r(th)*[cos(th), sin(th)];
ELL_TAB = [for (i=0, s=0; i<=180; s=s+norm(ell_pt(2*i+2)-ell_pt(2*i)), i=i+1) [s, 2*i]];
ELL_S   = ELL_TAB[180][0];                        // 全周弧長 (a=6, e=0.25 → ≈37)
function ell_th(s)  = lookup(((s%ELL_S)+ELL_S)%ELL_S, ELL_TAB);
// 伝達関数 (枝連続化): F(x) = 2·atan(((1-e)/(1+e))·tan(x/2)) — 真近点角変換と同型
function ell_F(x) = let(n=floor((x+180)/360), r=x-360*n)
                    360*n + 2*atan(((1-E_ELL)/(1+E_ELL))*tan(r/2));

module ell_gear2d(phase = 0) {
  w = 0.5*ELL_S/Z_ELL;                            // 歯幅@ピッチ (溝と等分 ≈1.16)
  union() {
    polygon([for (i=[0:2:360]) (ell_r(i)-1.05)*[cos(i),sin(i)]]);   // 歯底輪郭 (ピッチ−1.05)
    for (k=[0:Z_ELL-1]) {
      sc = (k+phase)*ELL_S/Z_ELL;
      p1 = ell_pt(ell_th(sc-w/2)); p2 = ell_pt(ell_th(sc+w/2));
      d  = p2-p1; nv = [d[1],-d[0]]/norm(d);      // CCW 周回の右手 = 外向き法線
      m  = (p1+p2)/2;
      polygon([p1-1.4*nv, p2-1.4*nv,
               m+(p2-m)*0.55+0.75*nv, m+(p1-m)*0.55+0.75*nv]);  // 台形歯: 歯末0.75/歯元1.05 → 相手歯底との すき間0.3
               // (基部は-1.4まで埋め込み: 法線≠動径のズレで歯が体から浮くのを防ぐ。機能寸法は歯底輪郭-1.05のまま)
    }
  }
}
module ell_gear(phase = 0, bore = 3.2, h = TH_ELL) {
  linear_extrude(height = h) difference() { ell_gear2d(phase); circle(d = bore); }
}

// ---------- 部品 ----------

// v0.7 銘刻印用: 円弧テキスト。flip=false: 足が中心向き (上半分用) / true: 足が外向き (下半分でも正立読み)
module meguru_arc_text(s, r, sz, flip = false) {
  step = (sz*1.12)/r * 180/PI;   // 文字送り (弧長→角度)
  for (i = [0:len(s)-1]) rotate([0,0, (flip ? -1 : 1) * ((len(s)-1)*step/2 - i*step)])
    translate([0, r]) rotate([0,0, flip ? 180 : 0])
      text(s[i], size = sz, font = "Hiragino Kaku Gothic ProN",
           halign = "center", valign = flip ? "top" : "baseline");
}

// ベース v0.6a: 中央ボス退避 (心臓部は背骨プレートへ) / クランク系退避 (入力は中心軸) /
//   新設 = 中央浅皿 (ターンテーブル滑り座 r18.9, z1-3)・土手 (リング下面溝の滑り座)・
//   モーター取付穴は y±24 へ移設 (浅皿の外・土手の内)
module base() {
  difference() {
    union() {
      cylinder(r = 72, h = 3);
      // 中央ボス (d8, z0-31) は v0.6a で背骨プレートへ移設 — 復活手順: spine() のボスを戻す
      difference() {   // 土手: リング46 下面溝 (r29.7-31.7) に入る滑り壁。リングは溝天井を土手上端に載せる
        cylinder(r = BANK_RO, h = BANK_TOP);
        translate([0,0,-1]) cylinder(r = BANK_RI, h = BANK_TOP + 2);
      }
      difference() {
        cylinder(r = SAROS_RO - 2, h = H_SAROS);
        translate([0,0,-1]) cylinder(r = SAROS_RP - 4, h = H_SAROS + 2);
      }
      rotate([0,0,IDLER_A]) translate([IDLER_R, 0, 0]) cylinder(d = AXLE_D, h = 13);   // v0.6a: 17→13 (idler帯 z-3)
      // v0.4b 傾斜天球の3点支持: 上がり側2本 = 溝ピン式 (radial 拘束) / 下がり側1本 = 滑り座式
      for (a = TPIL_AZ) {
        px = GROOVE_R*cos(a)*cos(TILT) - 2.0*sin(TILT);   // 溝底 local z=-2.0 の空間位置
        py = GROOVE_R*sin(a);
        zf = TR_ZT - GROOVE_R*cos(a)*sin(TILT) - TR_H*cos(TILT);   // この方位のリング下面高さ (支柱中心)
        translate([px, py, 0]) cylinder(d = 5, h = zf - 2.0);      // 頭-2.0 / d5
        translate([px, py, 0]) cylinder(d = 2.2, h = zf + 1.2);    // ピン (溝掛かり1.2・溝底クリア 中心0.64/縁0.2)
      }
      rotate([0,0,SEAT_AZ]) translate([SEAT_R, 0, 0]) cylinder(d = 5, h = SEAT_TOP);   // 滑り座 (内縁下面を受ける皿)
      // (v0.6a) 天球キャリア/2段アイドラ スタッドは下の union 継続部で丈調整
      // v0.5-B 地平環の柱3本 (r43.5 — 天球内縁下角投影46.1の内側/冠歯スイープ48.9の内側。先端ピンで環を受ける)
      for (a = [30, 150, 215]) rotate([0,0,a]) translate([43.5, 0, 0]) {
        cylinder(d = 4, h = 70);
        translate([0,0,70]) cylinder(d = 2.2, h = 2.5);
      }
      translate([ST1_XY[0], ST1_XY[1], 0]) cylinder(d = AXLE_D, h = 18);     // 天球キャリア スタッド (h18 — 冠歯外端の下角スイープz19.7を回避)
      translate([CIDL_XY[0], CIDL_XY[1], 0]) cylinder(d = AXLE_D, h = 13);   // 2段アイドラ スタッド (v0.6a: 15→13, 部品天面13に合わせ)
      // v0.6b 地下輪列の吊りスタッド (fix33: 3段構成・ベース裏)
      translate([S1_XY[0], S1_XY[1], -4.9]) cylinder(d = AXLE_D, h = 4.9);   // W1P1 用 (z-4.9..0)
      translate([S2_XY[0], S2_XY[1], -3.7]) cylinder(d = AXLE_D, h = 3.7);   // W2P2 用 (z-3.7..0 — W1天面-3.6の0.1下…W1P1と干渉しない丈)
      // ブリッジ支柱座は v0.4b で退避 / クランク軸座・穴は v0.6a で退避 (入力は中心軸へ一本化)
    }
    translate([0,0,1]) cylinder(r = 23.0, h = 2.01);         // 中央浅皿 (fix28→v0.6b: 23.0 — 冠環歯先22.5の逃げ。調芯は中心軸が担う)
    // v0.7 隠し刻印 (ベース裏 z0 面へ深さ0.8。帯 r45-65 = 裏スタッド/ネジ/縦シャフト穴の外)
    if (ENGRAVE > 0) mirror([1,0,0]) translate([0,0,-0.01]) linear_extrude(height = 0.81) {
      // 方位規約 (ミラー後のビュー基準): pre180=上 / pre0=下(flip) / pre90=右 / pre270=左
      if (ENGRAVE == 1) {   // 案1: 考証オマージュ (ギリシャ語銘 — 本家の銘文文化に倣う)
        rotate([0,0,180]) meguru_arc_text("ΜΗΧΑΝΗ ΟΥΡΑΝΟΥ", 57, 6.5);            // 天の機械
        rotate([0,0,0])   meguru_arc_text("ΣΕΛΗΝΗ · ΣΑΡΟΣ · ΜΕΤΑΠΤΩΣΙΣ", 57, 5, true);  // 月・サロス・歳差
        rotate([0,0,90])  meguru_arc_text("MMXXVI", 46, 4.5);
        rotate([0,0,270]) meguru_arc_text("巡る天の心臓", 46, 4.5);
      }
      if (ENGRAVE == 2) {   // 案2: 共作の銘
        rotate([0,0,180]) meguru_arc_text("巡る天の心臓", 57, 7);
        rotate([0,0,0])   meguru_arc_text("二〇二六 立秋 たま × Claude 共作", 57, 5, true);
        rotate([0,0,90])  meguru_arc_text("真・三軸トゥールビヨン", 46, 3.8);
        rotate([0,0,270]) meguru_arc_text("歯車三四枚 誤差 0.18%", 46, 3.8);   // fix36: 0.10% は誤り (設計目標との比較だった)
      }
      if (ENGRAVE == 3) {   // 案3: 次世代への手紙
        rotate([0,0,180]) meguru_arc_text("二千年後のあなたへ —", 57, 6);
        rotate([0,0,0])   meguru_arc_text("歯車はまだ天を数えていますか", 57, 5, true);
        rotate([0,0,90])  meguru_arc_text("2026 たま × Claude", 46, 3.8);
        rotate([0,0,270]) meguru_arc_text("ΧΑΙΡΕ", 46, 4.5);
      }
    }
    translate([0,0,-1]) cylinder(d = 3.4, h = 5);            // 駆動軸 床ジャーナル (fix35: 3.6→3.4 — 隣接監査で+0.6ガタを検出、標準ジャーナル径に統一)
    translate([S3_XY[0], S3_XY[1], -1]) cylinder(d = 3.4, h = 5);          // 縦シャフト ジャーナル (fix35: 3.6→3.4 — 0.6ガタは提灯×冠環の噛み深さを食う。fix34の穴位置修正も本行)
    for (s = [-1, 1]) translate([0, s*26, -1]) cylinder(d = 3.2, h = 5);   // モーター取付 (v0.6b: y±24→±26 — 浅皿23.0の外)
  }
}

// ===== v0.6a 歳差の背骨 — 駆動列 =====

// 複合リング46/36 (z9-13): 外歯46T (旧かごと同一バンド → 下流無改造) + 内歯36 (遊星から受ける)
//   + 上面ピン24本 (z13-16 → かご冠歯24へ) + 下面ガイド溝 (土手滑り座 r29.7-31.7・深さ1.5)。
//   内歯は「36T外歯形状+offset0.25 を彫る」シェーパー切り近似 (歯先 r25.5 = 中空半径・バックラッシ0.25)
module ring46_2d() {
  difference() {
    gear2d(Z_CAGE, M_MAIN);
    rotate([0,0,180/Z_RINT]) offset(delta = 0.25) gear2d(Z_RINT, M_MAIN);   // 半ピッチ回し: az0 に内歯の「歯」を出す
    // ↑ 遊星は偶数歯で太陽側(180°)・リング側(0°)の両面が「溝」— 2枚ラック間の歯車と同じ位相条件。
    circle(r = 25.5);
  }
}
module ring46() {
  difference() {
    union() {
      linear_extrude(height = GEAR_H) ring46_2d();
      for (i = [0:PIN_N-1]) rotate([0,0,i*360/PIN_N])
        translate([PIN_R, 0, GEAR_H]) cylinder(d = 2.2, h = 2.6);   // ピン列 (空間 z13-15.6 — fix27: 3→2.6 噛み窓を絞る)
    }
    translate([0,0,-0.01]) rotate_extrude() translate([29.7, -0.01]) square([2.0, 1.51]);   // 下面溝
  }
}

// 太陽12T (駆動軸 z9-13 に圧入) / 遊星12T×2 (ターンテーブル上スタッド r18・フリー回転, 先端キャップ瞬着)
module sun_gear()    { gear(Z_SUN,  M_MAIN, h = GEAR_H, bore = AXLE_PRESS); }
module planet_gear() { gear(Z_PLNT, M_MAIN, h = GEAR_H, bore = AXLE_FIT); }

// 背骨 (spine): ターンテーブル小円盤 + 冠環43T + 遊星スタッド2本 + 傾斜柱2本 + 傾斜プレート+ボス — 一体印刷。
//   この部品の回転 (方位 pa) = 歳差。柱 (az±90) と遊星スタッド (az0/180) は同体なので永久に非干渉。
//   collar=false は collide 用 (冠環×提灯は正規噛合 — PAIR14 が担当)
//   プレート系はピボット変換 T = translate(z=PREC_Z)·rotate(y=PREC_TILT) の局所座標 (v0.5 心臓部の旧ベース面 = 局所 z12)
module spine(collar = true) {
  if (collar) rotate([0,0,RT_PH]) translate([0,0,3]) linear_extrude(height = 2)
    difference() { offset(delta = -0.3) gear2d(RT_T, M_RT); circle(r = 19.9); }   // v0.6b 冠環43T (fix31: 0.3シェービング — 提灯ピンの逃げ。z3-5・根元19.9-20.25)
  pil_top = [10*sin(PREC_TILT), 0, PREC_Z + 10*cos(PREC_TILT)];               // プレート下面 (局所z10) の空間位置
  pil_len = (pil_top[2] - 3) / cos(PREC_TILT);                                 // ≈14.2
  difference() {
    union() {
      translate([0,0,1]) cylinder(r = TT_R, h = 2);                            // ターンテーブル (浅皿内 z1-3)
      for (a = [0, 180]) rotate([0,0,a]) translate([PLNT_R, 0, 1])
        cylinder(d = AXLE_D, h = 12.2);                                        // 遊星スタッド (z3-13.2・根元は円盤に埋め)
      for (s = [-1, 1])
        translate([pil_top[0] - pil_len*sin(PREC_TILT), s*PIL_Y, 3])
          rotate([0, PREC_TILT, 0]) linear_extrude(height = pil_len + 0.5)
            scale([1.4, 1]) circle(d = 5);                                     // 傾斜柱 (リブ楕円 7×5・長軸=傾斜面内)
      translate([0,0,PREC_Z]) rotate([0, PREC_TILT, 0]) {
        translate([0,0,10]) cylinder(r = PLATE_R, h = 1.9);                    // 傾斜プレート (局所 z10-11.9 — かごハブ下面12と0.1浮き・紙シム着座)
        translate([0,0,10]) cylinder(d = 8, h = BOSS_TOP - 10);                // ボス (かごコア ジャーナル・局所 z10-31)
        translate([0,0,BOSS_TOP]) cylinder(d = 6, h = 2);                      // 冠傘圧入段 (bevel_sun 用・v0.5 と同一界面)
      }
    }
    translate([0,0,-1]) cylinder(d = 3.6, h = 6);                              // 駆動軸 通し穴
  }
}

// ===== v0.6b 地下輪列の部品 (fix33: 14T→64T ×3段) =====
module ub_pinionA() { gear(ZB_A, M_UB, h = 1.5, bore = AXLE_PRESS); }   // 軸ピニオン14T (z-4.9..-3.4 圧入・クロッキングA_PH。歯底2.875 > 穴1.425 ✓)
module ub_w1p1() {   // W 64T + P 14T 一体 (吊りスタッドでフリー回転)。W1P1/W2P2 共用形状
  difference() {
    union() {
      linear_extrude(height = 1.3) gear2d(ZB_W, M_UB, 20, 0.7);                // W (下層・ak0.7 — 歯先16.35が相手14Tの基礎円3.289の手前で止まる)
      translate([0,0,1.3]) linear_extrude(height = 1.3) gear2d(ZB_P, M_UB);    // P (上層・フルアデンダム = 駆動side)
    }
    translate([0,0,-1]) cylinder(d = AXLE_FIT, h = 4);
  }
}
module ub_w3() {     // W3 65T (縦シャフト下端圧入・ak0.7 — fix36 で 64→65)
  linear_extrude(height = 1.3) difference() { gear2d(ZB_W3, M_UB, 20, 0.7); circle(d = AXLE_PRESS); }
}
module ub_lantern() {   // 提灯: キャリア円盤+6ピン垂下 (縦シャフト上端・LNT_PH クロッキングで接着)。局所 z0 = ピン下端 (空間 z3)
  difference() {
    union() {
      translate([0,0,2.2]) cylinder(d = 7, h = 1.2);                           // キャリア (空間 z5.2-6.4)
      for (i = [0:LANT_PINS-1]) rotate([0,0,i*60])
        translate([LNT_RP2B, 0, 0]) cylinder(d = 1.6, h = 2.4);                // ピン d1.6 (fix31: m1溝1.57+シェービング0.6に遊び込みで収まる)
    }
    translate([0,0,1.5]) cylinder(d = AXLE_PRESS, h = 3);
  }
}

// ===== 正設計ベベルペア (v0.3a-fix3) =====
// 軸交差90°・比2:1 → ピッチ円錐半頂角 63.43°/26.57°。共通頂点 = 軸交点 (0,0,GLOBE_Z)。
// 接触母線: apex から t=8〜13.4 → 固定傘ピッチ面 (r7.2,z39.4)〜(r12,z37)、
// ピニオンピッチ面 y7.15〜12・r3.6〜6。歯は母線に沿い apex へ収束する。

// 固定傘 24T マイター (v0.5-C: 45°/45° 対称ペア・ボス頂部に圧入・回らない)
// apex = 軸交点 (0,0,43)。ピッチ円錐: r = 43−z (45°)。歯体 r7.5〜12 (z35.5〜31)
module bevel_sun() {
  difference() {
    union() {
      cylinder(r1 = 10.09, r2 = 5.59, h = 4.5);             // 歯底円錐 (ピッチ−1.35法線 = Δ1.91) z31-35.5
      for (i = [0:BEV_SUN_T-1]) rotate([0,0,i*360/BEV_SUN_T])
        translate([5.48, -0.6, 4.39]) rotate([0, 45, 0])
          cube([6.6, 1.2, 2.55]);                            // 歯: root−0.15起点・全高2.55 → 先端ピッチ+1.05 (相手rootと0.3クリア)
    }
    translate([0,0,-1]) cylinder(d = 6.15, h = 9);           // ボス圧入
    translate([0,0,3.2]) cylinder(r = 4.6, h = 5.6);         // 中心抜き (root細端5.59の内)
  }
}

// 軸傘ピニオン 24T マイター (v0.5-C: 45°・固定傘と対称同形・フレームに一体)
// ローカル: z0 = 太端 r12、z4.5 = 細端 r7.5。配置時に細端を apex (中心) へ向ける
module bevel_pinion_solid() {
  cylinder(r1 = 10.09, r2 = 5.59, h = 4.5);                  // 歯底円錐 (ピッチ−1.35法線)
  for (i = [0:BEV_PIN_T-1]) rotate([0,0,i*360/BEV_PIN_T])
    translate([5.48, -0.6, 4.39]) rotate([0, 45, 0])
      cube([6.6, 1.2, 2.55]);                                // 歯: root−0.15起点・先端ピッチ+1.05
  translate([0,0,-1]) cylinder(r = 12.5, h = 1.5);           // 太端側ハブ (リング内周12へ0.5重ね)
}
module bevel_pinion() {  // 単体表示/印刷確認用
  difference() { bevel_pinion_solid(); translate([0,0,-2]) cylinder(d = AXLE_FIT, h = 9); }
}

// 外かご: 46T+台+直立アーム2本 (y±23.5-28.5)
// v0.4a: +y腕に秤動基準 E1 楕円歯車+スリーブを一体化 (かご固定 = 秤動の基準系)。
//        軸穴は圧入→ジャーナル d3.4 (真鍮軸が月球ごと回るため)
module cage() {
  zloc = GLOBE_Z - (H_CAGE - GEAR_H);   // 部品座標での第2軸高さ
  difference() {
    union() {
      gear(Z_CAGE, M_MAIN, h = GEAR_H, bore = 8.6);
      translate([0,0,GEAR_H]) cylinder(r = CAGE_R, h = CAGE_H);
      for (s = [-1, 1])
        translate([-6, s*ARM_Y + (s<0 ? -5 : 0), GEAR_H + CAGE_H])
          cube([12, 5, zloc - (GEAR_H + CAGE_H) + 4]);
      translate([0, SLV_X, zloc]) rotate([-90,0,0]) cylinder(d = 5, h = ARM_Y - SLV_X + 0.1);   // E1スリーブ
      translate([0, ARM_Y + 0.1, zloc]) rotate([90,0,0]) cylinder(d1 = 8, d2 = 5, h = 1.2);    // 根元ガセット
      translate([0, ELL_X, zloc]) rotate([-90,0,0]) rotate([0,0,-90]) ell_gear(0, 1, TH_ELL);  // E1 (近点=部品+z)
    }
    translate([0,0,-1]) cylinder(d = 8.6, h = GEAR_H + CAGE_H + 2);
    translate([0, -40, zloc]) rotate([-90,0,0]) cylinder(d = AXLE_FIT + 0.2, h = 80);  // 軸ジャーナル 3.4
  }
}

// かごコア (v0.6a): cage() の 46T を「ハブ+下面冠歯24」に置換 — 心臓部の他は無改造。
//   冠歯 (r25-28, 局所 z0.4-5.2 = 空間 z12.4-17.2) は旧46Tバンドの跡地に住み、リング上面ピン24と噛む。
//   ハブ下面 (局所 z0) が背骨プレート上面 (局所 z12) に着座して摺動 (紙シム文化)
module cage_core() {
  zloc = GLOBE_Z - (H_CAGE - GEAR_H);   // 部品座標での第2軸高さ (局所 z31)
  union() {
    difference() {
      union() {
        cylinder(d = 16, h = GEAR_H);                                  // ハブ (旧46Tの座)
        translate([0,0,GEAR_H]) cylinder(r = CAGE_R, h = CAGE_H);
        for (s = [-1, 1])
          translate([-6, s*ARM_Y + (s<0 ? -5 : 0), GEAR_H + CAGE_H])
            cube([12, 5, zloc - (GEAR_H + CAGE_H) + 4]);
        translate([0, SLV_X, zloc]) rotate([-90,0,0]) cylinder(d = 5, h = ARM_Y - SLV_X + 0.1);   // E1スリーブ
        translate([0, ARM_Y + 0.1, zloc]) rotate([90,0,0]) cylinder(d1 = 8, d2 = 5, h = 1.2);    // 根元ガセット
        translate([0, ELL_X, zloc]) rotate([-90,0,0]) rotate([0,0,-90]) ell_gear(0, 1, TH_ELL);  // E1 (近点=部品+z)
      }
      translate([0,0,GEAR_H]) rotate_extrude() translate([24.5, -0.01]) square([6.5, 1.01]);  // 冠歯レリーフ (r24.5-31 深1 — ピン先端の逃げ)
      translate([0,0,-1]) cylinder(d = 8.6, h = GEAR_H + CAGE_H + 2);
      translate([0, -40, zloc]) rotate([-90,0,0]) cylinder(d = AXLE_FIT + 0.2, h = 80);  // 軸ジャーナル 3.4
      // v0.7 意匠: メアンダー (雷文) 縁取り — 台座上面 r31.3-34.3 深さ0.5 (案1ギリシャ銘と揃い)
      if (ENGRAVE > 0) for (k = [0:23]) rotate([0,0,k*15])
        translate([0,0,GEAR_H + CAGE_H - 0.5]) linear_extrude(height = 0.6)
          for (seg = [[31.3,-3.4,3.0,0.7],[33.6,-3.4,0.7,2.6],[31.3,-1.5,2.3,0.7],[31.3,0.6,0.7,2.1],[31.3,2.0,3.0,0.7]])
            translate([seg[0], seg[1]]) square([seg[2], seg[3]]);
    }
    for (i = [0:23]) rotate([0,0,i*360/24]) hull() {   // 冠歯24: 台形テーパー (fix27)
      translate([CR24_RI, -CR24_WT/2, GEAR_H + 1 - CR24_TL])
        cube([CR24_RO - CR24_RI, CR24_WT, 0.3]);                       // 先端 (幅1.9)
      translate([CR24_RI, -CR24_WR/2, GEAR_H + 0.7])
        cube([CR24_RO - CR24_RI, CR24_WR, 0.5]);                       // 根元 (幅4.2・レリーフ天井に0.2埋め)
    }
  }
}

// 内かごフレーム (v0.3b): 片側リング+ハブスリーブ+遊星スタッド+偏心スタッド。
// ローカル: x軸 = 軸方向 (+x がリング側)。軸は固定 — フレームは bore FIT で軸上回転。
// 傘ピニオンはフレームのスリーブ先端に一体結合 (フレームごと回る = 従来と同じ駆動)
module inner_frame() {
  // v-fix8: スリーブ廃止 (傘細端を覆う太い筒が「当たってる」見た目と結合矛盾の根源だった)。
  // 15T 傘を正しい向き (細端 x7.15 = apex 向き / 太端 x12 = 外) でフレームに一体化し、
  // 太端ハブ (x12〜13.5) がリングへ直結。全体が bore FIT で軸上回転 = 結合矛盾も解消
  difference() {
    union() {
      translate([INNER_Y - 1.5, 0, 0]) rotate([0,90,0]) union() {
        difference() { cylinder(r = INNER_R, h = 3); translate([0,0,-1]) cylinder(r = INNER_R - 3, h = 5); }
        cylinder(d = 10, h = 3);
        for (a = [0, 90, 180, 270]) rotate([0,0,a]) translate([0, -1.5, 0]) cube([INNER_R - 2, 3, 3]);
      }
      translate([12, 0, 0]) rotate([0,-90,0]) bevel_pinion_solid();   // 傘: z+ → -x = 細端が中心向き ✓
      // v0.4a: 秤動カウンタースタッド (+z・r12) — E2P がフリー回転、先端にキャップ瞬着
      translate([14.5, 0, STUD_R]) rotate([0,90,0]) cylinder(d = 6, h = RET_X - 14.5 - 0.2);   // 根元ボス (リングに埋め込み)
      translate([14.5, 0, STUD_R]) rotate([0,90,0]) cylinder(d = 3, h = CAP_X + 1.0 - 14.5);   // スタッド軸 (先端はキャップ穴へ)
    }
    rotate([0,90,0]) translate([0,0,3]) cylinder(d = AXLE_FIT, h = 2*INNER_Y);  // 軸ジャーナル (真鍮軸が中で回る)
  }
}

// 月球 (v0.4a): 球のみ — 差動傘12T は削除 (秤動輪列が軸ごと回す)。
// 軸に瞬着 (bore 3.05 snug — 中央まで圧入摺動できないため。位相 clocking も利く)
module moon_globe() {
  difference() {
    union() {
      sphere(d = 13);
      translate([0,0,6.2]) sphere(d = 2.8);   // 頂のクレーター目印 — 秤動の首振りを可視化+塗り分け基準
    }
    rotate([0,90,0]) translate([0,0,-8]) cylinder(d = 3.05, h = 16);
  }
}

// 戻り歯車 G 12T (軸に瞬着・月球と同体で回る)
module ret_gear() { gear(Z_RET, M_RET, h = TH_RET, bore = 3.05); }

// E2楕円 (位相0.5) + P12T 一体 — スタッド上フリー回転。コア d6.5 が両輪を剛結
// (コア半径 3.25 < E2近点歯底 3.45 — E1歯先の通り道に食い出さない)
module e2p() {
  difference() {
    union() {
      cylinder(d = 6.5, h = ELL_X - RET_X + TH_ELL);
      linear_extrude(height = TH_RET) rotate([0,0,180/Z_RET]) gear2d(Z_RET, M_RET);  // P (半ピッチ位相 = G と歯-溝)
      translate([0,0,ELL_X - RET_X]) linear_extrude(height = TH_ELL) ell_gear2d(0.5);
    }
    translate([0,0,-1]) cylinder(d = 3.2, h = ELL_X - RET_X + TH_ELL + 2);
  }
}

// スタッド端キャップ (瞬着・E2P の抜け止め)
module stud_cap() {
  difference() { cylinder(d = 5, h = 1.0); translate([0,0,-0.5]) cylinder(d = 3.05, h = 2); }
}

// 支柱1本+弦腕ブリッジ (クランク軸上受け専用 — 中央受けは v3 で不要に)
module pillar_bridge() {
  // 支柱 (90° r64) — ベース座に差し込み
  cylinder(d = 8, h = BRIDGE_H);
  translate([0,0,-4]) cylinder(d = 4.8, h = 4);
  // 弦腕: (0,64)→(43.5,0) をこの部品のローカル系で表現 (印刷は一体・平置き)
  translate([0,0,BRIDGE_H]) difference() {
    hull() { cylinder(d = 10, h = 4); translate([43.5, -64, 0]) cylinder(d = 10, h = 4); }
    translate([43.5, -64, -1]) cylinder(d = AXLE_FIT, h = 6);
  }
  // ↑ ローカル: 支柱位置 (0,64) を原点に置いた時のクランク軸 (43.5,0) への相対 = (43.5-0, 0-64)
}

// クランク系・サロス系・黄道・モーター (v0.2.2 と同一)
module crank_pinion() { gear(Z_CRANK, M_MAIN, h = GEAR_H, bore = AXLE_PRESS); }
module crank_handle() {
  difference() {
    union() {
      cylinder(d = 10, h = 5);
      hull() { cylinder(d = 10, h = 4); translate([20,0,0]) cylinder(d = 9, h = 4); }
      translate([20,0,4]) cylinder(d = 5, h = 12);
      translate([20,0,16]) sphere(d = 10);
    }
    translate([0,0,-1]) cylinder(d = AXLE_PRESS, h = 7);
  }
}
// v0.5-A (検品15後の発注): サロス223朔望月の考証刻印。223は素数で3等分不可 → セグ3種 (74/74/75目盛)。
// 目盛はグローバル番号 i×360/223 で配置 (10目盛ごとに長刻み)。食マーカー38点 (i%6==0) は**意匠の疑似配置**
// (本家グリフの実配置の考証ではない)。回転比 1/5.9 も誇張のまま = 「223の環」は考証オマージュと明記。
module saros_seg(seg = 0) {
  tooth_h = 1.9;   // fix29b: 2.2→1.9 — 歯先円54.4 (真ピッチ復帰した非噛合ピン外縁54.25の退避0.15)
  difference() {
    union() {
      rotate_extrude(angle = 120) translate([SAROS_RP + 1.3, 0]) square([SAROS_RO - SAROS_RP - 1.3, SAROS_H]);
      // fix29b: セグ壁 56.3→56.8 — 真ピッチのピン外縁スイープ56.5が歯間の谷で0.3逃げられる
      for (i = [0 : 24])
        rotate([0,0, i * 360/SAROS_N])
          translate([SAROS_RP - tooth_h + 0.8, 0, 0])
            linear_extrude(height = SAROS_H)
              polygon([[0,-0.6],[tooth_h+0.7,-1.2],[tooth_h+0.7,1.2],[0,0.6]]);   // fix29: 歯幅1.2/2.4 (旧1.6/3.0)
              // 根元は x=tooth_h+0.7 → r57.0 (後退した壁56.8に0.2埋め)。ピッチ円隙間3.0 vs ピン2.0 (遊び±0.5)。
              // 経緯: fix19cのピン円0.6縮小が転がり共役を崩し、中間位相でピン胴×歯フランク 7-11mm³ (v0.2以来の潜伏)。
              // ⚠️ 凍結版 meguru_v4.scad へ fix29/29b 一式の印刷前バックポート必須 (fix10/13 と同じ扱い)
      rotate([0,0,119]) translate([(SAROS_RP+SAROS_RO)/2, 0, SAROS_H/2])
        rotate([0,90,90]) cylinder(d = 3.6, h = 5);
    }
    rotate([0,0,1]) translate([(SAROS_RP+SAROS_RO)/2, -6, SAROS_H/2])
      rotate([-90,0,0]) cylinder(d = 3.9, h = 7);
    // 223目盛 (このセグの担当 = グローバル角が [seg·120, (seg+1)·120) のもの)
    for (i = [0 : 222]) {
      ga = i * 360/223;
      if (ga >= seg*120 - 0.001 && ga < (seg+1)*120 - 0.001)
        rotate([0,0, ga - seg*120]) {
          if (i % 10 == 0) translate([SAROS_RO - 6.5, -0.35, SAROS_H - 0.8]) cube([6, 0.7, 1]);      // 長刻み (10目盛ごと)
          else             translate([SAROS_RO - 4,   -0.25, SAROS_H - 0.8]) cube([3.5, 0.5, 1]);    // 通常刻み
          if (i % 6 == 0)  translate([SAROS_RP + 3.2, 0, SAROS_H - 0.8]) cylinder(d = 1.6, h = 1);   // 食マーカー (意匠・38点)
        }
    }
  }
}
// v0.4b-fix19: 旧・下フランジ (r6.7, z4-6 相当) がサロス内歯の歯先 (r52.5, 全高) に v0.2 以来
// 5.2mm めり込んでいた (検証は軸間数値のみで体積を見ていなかった)。提灯を上吊り構造に反転:
// ピンはキャリア円盤 (歯の上 z9.2+) から下向きに垂れる。噛み z5.2-9.0 = 3.8 ✓ / 滑り座クリア1.2
module saros_idler() {
  for (i = [0:LANT_PINS-1]) rotate([0,0,i*360/LANT_PINS])
    translate([LANT_RP2, 0, 1.2]) cylinder(d = 2.0, h = 4.2);           // ピン d2.0・r3.9 (溝2.36に対し隙間0.36)
  difference() {
    union() {
      translate([0,0,5.2]) cylinder(r = LANT_RP + 2.2, h = 2);          // キャリア円盤 (歯上面7.5+0.2 の上)
      translate([0,0,6.5]) linear_extrude(height = GEAR_H) gear2d(Z_IDLER, M_MAIN);   // 22T (v0.6a: 局所8→6.5 — 空間 z9-13 でリング46Tと全幅噛み)
    }
    translate([0,0,4]) cylinder(d = AXLE_FIT, h = 7);
  }
}
module zodiac_half() {
  difference() {
    rotate_extrude(angle = 180) translate([ZOD_RI, 0]) square([ZOD_RO - ZOD_RI, ZOD_H]);
    for (i = [0:6])
      rotate([0,0, i*30]) translate([ZOD_RI - 1, -0.5, ZOD_H - 1]) cube([ZOD_RO - ZOD_RI + 2, 1, 2]);
    for (i = [0:5])
      rotate([0,0, i*30 + 15]) translate([(ZOD_RI+ZOD_RO)/2, 0, ZOD_H - 1.2]) cylinder(d = 2.5, h = 2);
  }
}
// ===== v0.4b 傾く天球 =====
// 傾斜天球リング: ローカル水平 (上面 z=0) で生成 → rotate([0,TILT,0]) + z=TR_ZT で配置。
// リングは傾斜軸まわりの回転体なので回しても占有空間が不変 (太陽玉だけが動く)。
// 上面: 十二宮刻み+太陽玉 / 下面: ガイド溝+冠歯76。印刷時は 120°×3 分割予定 (v0.4c)
module tilt_ring() {
  difference() {
    union() {
      translate([0,0,-TR_H]) difference() {
        cylinder(r = TR_RO, h = TR_H);
        translate([0,0,-1]) cylinder(r = TR_RI, h = TR_H + 2);
      }
      for (i = [0:CROWN_N-1]) rotate([0,0,i*360/CROWN_N]) hull() {   // 冠歯: 根元1.3 → 先端 CROWN_TIP_W の台形 (fix37 — fix27 と同じ手)
        translate([CROWN_RP - 2, -0.65, -TR_H - 0.3]) cube([5.5, 1.3, 0.5]);                                  // 根元 (リング底に0.2埋め)
        translate([CROWN_RP - 2, -CROWN_TIP_W/2, -TR_H - CROWN_TL]) cube([5.5, CROWN_TIP_W, 0.3]);            // 先端
      }
      translate([57, 0, 0]) cylinder(d = 3, h = 4);            // 太陽の旗竿 (方位0 = 牡羊点)
      translate([57, 0, 5]) sphere(d = 6);                     // 太陽玉 (d6/r57)
    }
    translate([0,0,-TR_H-0.01]) rotate_extrude() translate([GROOVE_R - 2.0, -0.01]) square([4.0, 2.01]);
    for (i = [0:11]) rotate([0,0, i*30]) translate([TR_RI - 1, -0.5, -1]) cube([TR_RO - TR_RI + 2, 1, 1.2]);
    for (i = [0:11]) rotate([0,0, i*30 + 15]) translate([57.5, 0, -0.89])
      linear_extrude(height = 1) rotate([0,0,-90])
        text(chr(9800 + i), size = 6, font = "Apple Symbols", halign = "center", valign = "center");   // v0.5-A 十二宮記号彫り (深0.9)
  }
}

// 2段アイドラ 22T/11T (fix23): 下段11T(z9.2-11.8)が主輪19Tと、上段22T(z12-16)がかご46Tと噛む。
// z9.2-11.8 は「サロス上面9とかご46T下面12の間」の空き帯 — かご台座/アーム掃引帯(z16-35)を避ける
module crown_idler() {
  difference() {
    union() {
      linear_extrude(height = 2.6) gear2d(Z_CIDLB, M_MAIN);
      translate([0,0,2.6]) cylinder(d = 8, h = 0.2);
      translate([0,0,2.8]) linear_extrude(height = GEAR_H) gear2d(Z_CIDLA, M_MAIN);
    }
    translate([0,0,-1]) cylinder(d = AXLE_FIT, h = 9);
  }
}

// 天球キャリア (fix23): 主輪19T (z9.2-11.8・アイドラ11Tと噛む) + ハブ筒 d10.5 + 提灯6ピン (冠歯90へ)
// 19T 内端37.7 > かご歯先36 = 平面かぶりゼロ。ピン (z22.8-26.1・噛み3.0) をハブ筒で冠歯 (az-65帯) へ
module st1_carrier() {
  difference() {
    union() {
      linear_extrude(height = 2.6) gear2d(Z_ST1A, M_MAIN);          // 19T (v0.6a: 空間 z6.2-8.8 相当)
      translate([0,0,2.6]) cylinder(d = 8.6, h = 4.7);              // ハブ細部 (22T歯先r18と軸間22.5: クリア0.2)
      translate([0,0,7.3]) cylinder(d = 10.5, h = 9.3 - ST1_HUB_DROP);   // ハブ太部 (v0.6a: +3 延長。fix37: 天面を ST1_HUB_DROP 下げる)
      for (i = [0:LANT_PINS-1]) rotate([0,0,i*360/LANT_PINS])
        translate([CROWN_LRP, 0, 16.6 - ST1_HUB_DROP - 0.2])
          cylinder(d = ST1_PIN_D, h = 3.3 + ST1_HUB_DROP + 0.2 - ST1_PIN_TOP_CUT);   // ピン (台座に0.2埋め・先端高さは 26.1-CUT)
    }
    translate([0,0,-1]) cylinder(d = AXLE_FIT, h = 30);
  }
}

module motor_mount() {
  difference() {
    union() {
      translate([-29, -16, 0]) cube([58, 32, 4]);   // v0.6b: フランジ ±26 (浅皿23.0拡大に伴い外へ)
      translate([-24, -16, 0]) cube([48, 4, 22]);
      translate([-24, 12, 0]) cube([48, 4, 22]);
    }
    translate([0,0,-1]) cylinder(d = 30, h = 6);
    translate([0,0,-1]) cylinder(d = 10, h = 30);
    for (s = [-1,1]) translate([s*17.5, 0, -1]) cylinder(d = 3.2, h = 6);   // 28BYJ-48 の耳
    for (s = [-1,1]) translate([s*26, 0, -1]) cylinder(d = 3.2, h = 6);    // ベース取付 (v0.6b: ±26・組立で90°回し)
  }
}
// 手回しノブ (fix24): モーターを使わない時、coupling の代わりに裏から差す。軸受けは coupling と同じ d3.25 差し込み
module hand_knob() {
  difference() {
    union() {
      cylinder(d = 30, h = 5);                                   // 握り円盤 (縁ローレット)
      for (i = [0:11]) rotate([0,0,i*30]) translate([15, 0, 0]) cylinder(d = 3, h = 5);
      translate([0,0,5]) cylinder(d = 10, h = 10);               // 軸受け筒
    }
    translate([0,0,6]) cylinder(d = 3.25, h = 10);               // 真鍮軸差し込み (抜き差し式)
  }
}

// v0.5-B 地平環: 傾いた天球を囲む固定の水平環 (z70)。柱3本の先端ピンに載せ瞬着。
// 4方位マーク = 牡羊点(春分)/蟹(夏至)/天秤(秋分)/山羊(冬至) の読み取り基準
module horizon_ring() {
  difference() {
    union() {
      difference() { cylinder(r = 66.5, h = 3); translate([0,0,-1]) cylinder(r = 64, h = 5); }   // t3 (ダボ穴d2を上下肉0.5で包む)
      for (a = [30, 150, 215]) rotate([0,0,a]) translate([43.5, -2, 0]) cube([21.5, 4, 2]);   // 腕 (柱→環)
    }
    for (a = [30, 150, 215]) rotate([0,0,a]) translate([43.5, 0, -1]) cylinder(d = 2.5, h = 4);   // 柱ピン穴
    for (a = [0, 90, 180, 270]) rotate([0,0,a]) translate([64.5, -0.4, 2.2]) cube([2.2, 0.8, 1]);  // 4方位マーク
  }
}

module coupling() {
  difference() {
    cylinder(d = 10, h = 16);
    translate([0,0,-1]) linear_extrude(height = 9)
      difference() { circle(d = 5.2); translate([1.5, -3]) square([3, 6]); }
    translate([0,0,8]) cylinder(d = 3.25, h = 9);
  }
}

// ---------- 組立 ----------
// ca ≡ リング46角 (旧かご角と同一定義 — 下流サロス/天球の式は v0.5 と不変) / pa = 歳差方位
// stage (v0.7-B 組立ガイド用): 0=土台 / 1=+地下と背骨 / 2=+心臓 / 3=+大周期 / 4=+電動 (9=全部)
module assembly(explode = 0, ca = 0, pa = PREC_AZ, stage = 9) {
  e = explode;
  pae     = pa + (AUTO_PREC != 0 ? -3*ca/(PREC_RATIO - 4) : 0);   // 歳差は ca に従属。fix36: 遊星段の連成 (−4) を入れた厳密式
  axle_a  = 4*pae - 3*ca + SUN_PH;           // 駆動軸+太陽 (エピサイクリック一般式: pa=0 で -3·ca に退化)
  plnt_a  = 3*ca - 2*pae + PLNT_PH;          // 遊星 (空間角): ω_p = (1+Zs/Zp)ω_c - (Zs/Zp)ω_s
  hca     = ca - pae + CAGE_PH;              // かごコア局所角 (ピン×冠 1:1・歳差方位ぶん差し引き)
  shaft_a = axle_a - SUN_PH;                 // 駆動軸そのものの角 (太陽/軸ピニオンは各自のクロッキングで乗る)
  w1_a    = -shaft_a*ZB_A/ZB_W + W1_PH;      // v0.6b 地下輪列 (fix33: 3段)
  w2_a    = -(w1_a - W1_PH)*ZB_P/ZB_W + W2_PH;
  w3_a    = -(w2_a - W2_PH)*ZB_P/ZB_W3 + W3_PH;
  saros_a = -ca * SAROS_RATIO + SAROSR_PH;   // fix30: fix22 の再訂正 — 内歯噛みは回転方向を保存する
  // (アイドラ(-) → リング(-)。自前の遊星→内歯36と同じ標準則)。符号+だと位相ズレが 2·RATIO·ca で蓄積し、
  // 歯ピッチ整数倍の角度だけ偶然噛む (PAIR3 の ✅/⚠️ パターン8/8がこの式で完全に予言できた = 決定的証拠)。
  // ⚠️ 見た目の回転向きが fix22 承認時と逆になる — 検品17でたまさん判定待ち。v4 バックポート候補
  idler_a = -ca * Z_CAGE / Z_IDLER + SIDL_PH; // fix22: 外歯ペアの保存式より負
  inner_a = hca * BEV_SUN_T / BEV_PIN_T;     // 第2軸: 1自転/公転 (プレート局所)
  moon_a  = inner_a - ell_F(inner_a);        // 月+軸+G: 正味自転0 + 秤動 (±2e rad ≈ ±28.5°)
  e2p_a   = ell_F(inner_a);                  // E2P: フレーム相対の自転 (E1 上を転がる)
  ring_a  = ca * RING_RATIO + RING_PH;       // 天球: 1回転 = リング12.39回転 (太陽の年周)
  cidl_a  = -ca * Z_CAGE / Z_CIDLA + CIDL_PH;
  st1_a   = ca * (Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A) + ST1_PH;

  if (stage >= 1) color("#d8c690") translate([0, 0, -19 - e*2]) cylinder(d = AXLE_D, h = 32);   // 中心駆動軸 (真鍮32mm z-19..13)
  color("#8a7020") base();
  if (stage >= 4) color("#666e7e") translate([0, 0, -21 - e*2]) coupling();
  if (stage >= 4) color("#4a5568") translate([0, 0, -5 - e*1.5]) rotate([0,0,90]) rotate([180,0,0]) motor_mount();   // fix33: 1mm下げ・取付穴 y±26
  if (stage >= 3) color("#8a7020") translate([0, 0, 70 + e*5]) horizon_ring();   // v0.5-B 地平環 (柱先端ピンに瞬着)
  if (stage >= 3) color("#6b5a1a") rotate([0,0,saros_a]) for (k = [0:2]) rotate([0,0,k*120])
    translate([0,0,H_SAROS + e*0.5]) saros_seg(k);
  if (stage >= 3) color("#aab4c4") rotate([0,0,IDLER_A]) translate([IDLER_R, 0, H_SAROS + e*0.8])
    rotate([0,0,idler_a]) saros_idler();
  if (stage >= 3) color("#c9a227") translate([0, 0, TR_ZT + e*4]) rotate([0,TILT,0]) rotate([0,0,ring_a]) tilt_ring();
  if (stage >= 3) color("#aab4c4") translate([CIDL_XY[0], CIDL_XY[1], 6.2 + e*0.8]) rotate([0,0,cidl_a]) crown_idler();
  if (stage >= 3) color("#8fa88f") translate([ST1_XY[0], ST1_XY[1], 6.2 + e*1.2]) rotate([0,0,st1_a]) st1_carrier();
  // v0.6a 駆動列: 太陽12T → 遊星12T×2 (背骨キャリア上) → 複合リング46/36 → 下流+ピン×冠
  if (stage >= 1) {
  color("#b8a76a") translate([0, 0, 9 + e*0.5]) rotate([0,0,axle_a]) sun_gear();
  color("#c9a227") translate([0, 0, 9 + e*0.7]) rotate([0,0,ca]) ring46();
  // v0.6b 地下輪列 fix33 (ベース裏 z-4.9〜-1.0 の3段 → 縦シャフト r24.5 → 提灯 → 冠環43T)
  color("#6e675c") translate([0, 0, -4.9 - e]) rotate([0,0,shaft_a + A_PH]) ub_pinionA();
  color("#7d766a") translate([S1_XY[0], S1_XY[1], -4.9 - e*1.2]) rotate([0,0,w1_a]) ub_w1p1();
  color("#7d766a") translate([S2_XY[0], S2_XY[1], -3.6 - e*1.4]) rotate([0,0,w2_a]) ub_w1p1();   // W2P2 (W1P1と共用形状)
  color("#6e675c") translate([S3_XY[0], S3_XY[1], -2.3 - e*1.6]) rotate([0,0,w3_a]) ub_w3();
  color("#8fa88f") translate([S3_XY[0], S3_XY[1], 3.1 + e*0.5]) rotate([0,0,w3_a + LNT_PH]) ub_lantern();   // ピン z3.1-5.5 (ベース天面3と0.1逃げ)
  color("#d8c690") translate([S3_XY[0], S3_XY[1], -3.5 - e]) cylinder(d = AXLE_D, h = 9.9);   // 縦シャフト (真鍮 z-3.5..6.4)
  }
  if (stage >= 1) rotate([0,0,pae]) {   // ===== 歳差系 (背骨+冠環+遊星+傾いた心臓部) =====
    color("#8a7020") spine();
    for (a = [0, 180]) rotate([0,0,a]) {
      color("#aab4c4") translate([PLNT_R, 0, 9 + e*0.9]) rotate([0,0,plnt_a - pae - a]) planet_gear();
      color("#666e7e") translate([PLNT_R, 0, 13.2 + e*2]) stud_cap();
    }
    if (stage >= 2) translate([0, 0, PREC_Z]) rotate([0, PREC_TILT, 0]) {   // 傾斜プレート局所系 (局所 z0 = 旧ベース面)
      color("#b8a76a") translate([0,0,BOSS_TOP + e*1.8]) bevel_sun();   // 冠傘 (プレートに固定 — かごと回らない)
      rotate([0,0,hca]) {
        color("#c9a227") translate([0,0,H_CAGE - GEAR_H + e*1.5]) cage_core();
        // 第2軸まわり (v0.4a): 真鍮軸はジャーナル回転 (腕2+E1スリーブ)。ローカル x軸=軸方向 → rotate z90 で y 向き
        translate([0,0,GLOBE_Z + e*3]) rotate([0,0,90]) {
          color("#d8c690") rotate([0,90,0]) translate([0,0,-30]) cylinder(d = AXLE_D, h = 60); // 真鍮軸 (月球・Gと同体で回る)
          rotate([inner_a, 0, 0]) {                                    // フレーム系 (24T傘はフレームに一体)
            color("#aab4c4") inner_frame();
            color("#8fa88f") translate([RET_X, 0, STUD_R + e*2]) rotate([0,90,0]) rotate([0,0,180 + e2p_a]) e2p();
            color("#666e7e") translate([CAP_X + e*2, 0, STUD_R + e*2]) rotate([0,90,0]) stud_cap();
          }
          rotate([moon_a, 0, 0]) {                                     // 月+G (軸に瞬着・秤動でうなずく)
            color("#f0ead8") moon_globe();
            color("#c9a227") translate([RET_X + e*1.5, 0, 0]) rotate([0,90,0]) ret_gear();
          }
        }
      }
    }
  }
}


// ---------- 干渉テスト ----------
ANGLE = 0;
STAGE_N = 9;   // PART="stage" 用 (0-4)
PAIR = 0;   // bite_pair 用: 1=クランク×かご 2=かご×サロスidler 3=サロス提灯×内歯 4=かご×冠idler 5=idler×45T 6=提灯×冠 7=かご×st1
SEG = 0;    // base_seg / ring_seg 用 (0/1/2)
module rotating_at(ca) { rotating_heart(ca); rotating_sky(ca); rotating_drive(ca); }
// v0.6a 駆動列 (ca スイープ時の回転体): リング+太陽+遊星 (キャリアは PREC_AZ で静止)
module rotating_drive(ca) {
  translate([0,0,9]) rotate([0,0,ca]) ring46();
  translate([0,0,9]) rotate([0,0, 4*PREC_AZ - 3*ca + SUN_PH]) sun_gear();
  for (a = [0, 180]) rotate([0,0,PREC_AZ + a])
    translate([PLNT_R, 0, 9]) rotate([0,0, 3*ca - 3*PREC_AZ - a + PLNT_PH]) planet_gear();
  // v0.6b 地下輪列 fix33 (回転体): 角度は ca 従動 (pa=PREC_AZ 固定時)
  let (sha = 4*PREC_AZ - 3*ca,
       w1 = -sha*ZB_A/ZB_W + W1_PH,
       w2 = -(w1 - W1_PH)*ZB_P/ZB_W + W2_PH,
       w3 = -(w2 - W2_PH)*ZB_P/ZB_W3 + W3_PH) {
    translate([0,0,-4.9]) rotate([0,0,sha + A_PH]) ub_pinionA();
    translate([S1_XY[0], S1_XY[1], -4.9]) rotate([0,0,w1]) ub_w1p1();
    translate([S2_XY[0], S2_XY[1], -3.6]) rotate([0,0,w2]) ub_w1p1();
    translate([S3_XY[0], S3_XY[1], -2.3]) rotate([0,0,w3]) ub_w3();
    translate([S3_XY[0], S3_XY[1], 3.1]) rotate([0,0,w3 + LNT_PH]) ub_lantern();
  }
}
// 心臓部 (v0.6a: 歳差ラップ hca = ca - pa + CAGE_PH でプレート局所系ごと傾く)
module rotating_heart(ca, pa = PREC_AZ) {
  hca = ca - pa + CAGE_PH;
  ia = hca * BEV_SUN_T / BEV_PIN_T;
  rotate([0,0,pa]) translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) rotate([0,0,hca]) {
    translate([0,0,H_CAGE - GEAR_H]) cage_core();
    translate([0,0,GLOBE_Z]) rotate([0,0,90]) {
      rotate([0,90,0]) translate([0,0,-30]) cylinder(d = AXLE_D, h = 60);   // v0.4a: 真鍮軸も回転体に計上
      rotate([ia, 0, 0]) {
        inner_frame();
        translate([RET_X, 0, STUD_R]) rotate([0,90,0]) rotate([0,0,180 + ell_F(ia)]) e2p();
        translate([CAP_X, 0, STUD_R]) rotate([0,90,0]) stud_cap();
      }
      rotate([ia - ell_F(ia), 0, 0]) {
        moon_globe();
        translate([RET_X, 0, 0]) rotate([0,90,0]) ret_gear();
      }
    }
  }
}
// v0.4b 天球系 (かご角に従動する独立回転体 — かご回転の外で各自の軸まわりに回る)
module rotating_sky(ca) {
  translate([0, 0, TR_ZT]) rotate([0,TILT,0]) rotate([0,0, ca * RING_RATIO + RING_PH]) tilt_ring();
  translate([CIDL_XY[0], CIDL_XY[1], 6.2]) rotate([0,0, -ca * Z_CAGE / Z_CIDLA + CIDL_PH]) crown_idler();
  translate([ST1_XY[0], ST1_XY[1], 6.2]) rotate([0,0, ca * (Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A) + ST1_PH]) st1_carrier();
}
module fixed_noncontact() {
  base();
  rotate([0,0,PREC_AZ]) spine(collar = false);   // 背骨 (冠環は提灯との正規噛合 = PAIR14 の担当なので除外)
  // 冠傘は傘ピニオンとの噛合ペア — 歯を除いた傘本体を検査対象に (v0.6a: プレート局所系へ移設)
  rotate([0,0,PREC_AZ]) translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) translate([0,0,BOSS_TOP]) difference() {
    cylinder(r1 = 10.09, r2 = 5.59, h = 4.5);
    translate([0,0,3.2]) cylinder(r = 4.6, h = 5.6);
    translate([0,0,-1]) cylinder(d = 6.15, h = 9);   // 圧入穴 (実部品と同じ — 入れ忘れると偽陽性)
  }
  translate([0, 0, 70]) horizon_ring();   // v0.5-B: 地平環は fixed (柱は base 内)
  // 中心駆動軸: 圧入区間 (太陽 z9-13 / 軸ピニオン z-4.9..-3.4) を除いた2分割 (回転対称なので固定側で可)
  translate([0, 0, -19]) cylinder(d = AXLE_D, h = 13.6);       // z-19..-5.4
  translate([0, 0, -2.9]) cylinder(d = AXLE_D, h = 11.4);      // z-2.9..8.5
  translate([S3_XY[0], S3_XY[1], -0.5]) cylinder(d = AXLE_D, h = 3.5);   // 縦シャフト (W3/提灯の圧入区間を除いた中間部)
}

// ---------- セレクタ ----------
if (PART == "base") base();
else if (PART == "bevel_sun") bevel_sun();
else if (PART == "cage") cage();
else if (PART == "inner_frame") inner_frame();
else if (PART == "moon_globe") moon_globe();
else if (PART == "e2p") e2p();
else if (PART == "ret_gear") ret_gear();
else if (PART == "stud_cap") stud_cap();
else if (PART == "ell_test") ell_gear(0, 3.2);
else if (PART == "tilt_ring") tilt_ring();
else if (PART == "crown_idler") crown_idler();
else if (PART == "st1_carrier") st1_carrier();
else if (PART == "ring46") ring46();
else if (PART == "sun_gear") sun_gear();
else if (PART == "planet_gear") planet_gear();
else if (PART == "spine") spine();
else if (PART == "cage_core") cage_core();
else if (PART == "ub_pinionA") ub_pinionA();
else if (PART == "ub_w1p1") ub_w1p1();   // ×2 印刷 (W1P1 / W2P2 共用)
else if (PART == "ub_w3") ub_w3();
else if (PART == "ub_lantern") ub_lantern();
else if (PART == "bevel_pinion") bevel_pinion();
else if (PART == "pillar_bridge") pillar_bridge();
else if (PART == "crank_pinion") crank_pinion();
else if (PART == "crank_handle") crank_handle();   // fix24 退避 (印刷不要)
else if (PART == "hand_knob") hand_knob();
else if (PART == "horizon_ring") horizon_ring();
else if (PART == "horizon_seg")   // 地平環 120°×3 (φ133 は一枚だとビルド奥行75超 — 切り線 90/210/330 = 腕を回避)
  difference() {
    union() {
      intersection() {
        horizon_ring();
        rotate([0,0, 90 + 120*SEG]) rotate_extrude(angle = 120) square([80, 10]);
      }
      rotate([0,0, 90 + 120*SEG + 119.3]) translate([65.25, -1.2, 1.5]) rotate([-90,0,0]) cylinder(d = 1.6, h = 4.2);   // 根本1.2埋め込み・z中央1.5
    }
    rotate([0,0, 90 + 120*SEG - 1.0]) translate([65.25, 0, 1.5]) rotate([-90,0,0]) cylinder(d = 2.0, h = 4.5);   // 切り面(0°)の外から掘り開口させる (0.7内側起点は密閉空洞になった)
  }
else if (PART == "saros_seg") saros_seg(SEG);
else if (PART == "saros_idler") saros_idler();
else if (PART == "zodiac_half") zodiac_half();
else if (PART == "motor_mount") motor_mount();
else if (PART == "coupling") coupling();
else if (PART == "exploded") assembly(explode = 8);
else if (PART == "turntable") rotate([0,0,$t*360]) assembly(explode = 0, ca = $t*360);   // 全体観覧: 台1回転+かご1回転
// ---------- v0.6c 印刷分割 (SEG=0/1/2) ----------
// fix32: 切り線 az 60/180/300 → 48/168/288 — v0.6b の裏スタッド (S1 az60.0 / SI az61.4) と縦シャフト (az0) を回避。
// 全フィーチャー方位: riser0/座20/柱30/S1・SI 60-61/モーター90・270/柱150/サロスidler185/柱215/cidl234/st1 284 — 最小クリア2.5° (288 vs st1 285.5)
// base は上面継ぎ板 (splice_plate, 浅皿23.0と土手29.9の間の r23.4-29.4 帯, 瞬着) で接合、リングはサロス式の切り面ダボ
else if (PART == "base_seg")
  intersection() {
    base();
    rotate([0,0, 48 + 120*SEG]) rotate_extrude(angle = 120) translate([0, -20]) square([80, 100]);
  }
else if (PART == "splice_plate")   // ベース継ぎ板 ×3 (境界の上面 z3・r23.4-29.4 に瞬着 — fix32: 土手の内側へ縮小移設。冠環歯先22.5と0.9クリア)
  cube([6, 8, 2]);
else if (PART == "ring_seg")   // サロス式の切り面ダボ (進み端ピン d2.6 / 遅れ端穴 d3.0・接線方向)
  difference() {
    union() {
      intersection() {
        tilt_ring();
        rotate([0,0, 60 + 120*SEG]) rotate_extrude(angle = 120) translate([0, -20]) square([80, 60]);
      }
      rotate([0,0, 60 + 120*SEG + 119.2]) translate([57.5, 0, -2]) rotate([-90,0,0]) cylinder(d = 2.6, h = 4.5);
    }
    rotate([0,0, 60 + 120*SEG + 0.8]) translate([57.5, 0, -2]) rotate([-90,0,0]) cylinder(d = 3.0, h = 5.5);
  }
else if (PART == "stage") assembly(explode = 0, ca = 25, stage = STAGE_N);   // v0.7-B 組立ガイド用
else if (PART == "anim") assembly(explode = 0, ca = $t * 360);
else if (PART == "anim_prec")   // 歳差デモ (太陽=ノブ固定・ターンテーブルだけ回す): かごが円錐を描き、結合でリング/サロス/天球も微動
  let (A = $t * 360) assembly(explode = 0, ca = (Z_RINT + Z_SUN)/Z_RINT * A, pa = A);
else if (PART == "engage")   // v0.7-D 実在検査: 機能噛合ペアを δ=0.5 互いに寄せて non-empty なら「ちゃんと触れている」
  // (collide/bite の逆向き = 不在バグの網。fix34「有るべき穴が無い」型を機械的に検出する)
  let (EP = PAIR, SQ = 0.5) {
    if (EP == 1) intersection() {   // 太陽 × 遊星 (寄せ: 遊星を中心へ)
      translate([0,0,9]) rotate([0,0,SUN_PH]) sun_gear();
      translate([PLNT_R - SQ, 0, 9]) rotate([0,0,PLNT_PH]) planet_gear();
    }
    if (EP == 2) intersection() {   // 遊星 × リング内歯36 (寄せ: 遊星を外へ)
      translate([PLNT_R + SQ, 0, 9]) rotate([0,0,PLNT_PH]) planet_gear();
      translate([0,0,9]) ring46();
    }
    if (EP == 3) intersection() {   // リング46 × サロス中間輪22T
      translate([0,0,9]) ring46();
      rotate([0,0,IDLER_A]) translate([IDLER_R - SQ, 0, H_SAROS]) rotate([0,0,SIDL_PH]) saros_idler();
    }
    if (EP == 4) intersection() {   // サロス提灯ピン × 内歯74 (寄せ: idler を外へ)
      rotate([0,0,IDLER_A]) translate([IDLER_R + SQ, 0, H_SAROS]) rotate([0,0,SIDL_PH]) saros_idler();
      rotate([0,0,SAROSR_PH]) for (k = [0:2]) rotate([0,0,k*120]) translate([0,0,H_SAROS]) saros_seg(k);
    }
    if (EP == 5) intersection() {   // リング46 × 冠アイドラ22T
      translate([0,0,9]) ring46();
      translate([CIDL_XY[0]*(1-SQ/norm(CIDL_XY)), CIDL_XY[1]*(1-SQ/norm(CIDL_XY)), 6.2]) rotate([0,0,CIDL_PH]) crown_idler();
    }
    if (EP == 6) intersection() {   // 冠アイドラ11T × st1 19T (寄せ: st1 を cidl へ)
      translate([CIDL_XY[0], CIDL_XY[1], 6.2]) rotate([0,0,CIDL_PH]) crown_idler();
      translate([ST1_XY[0] + SQ*(CIDL_XY[0]-ST1_XY[0])/norm(CIDL_XY-ST1_XY), ST1_XY[1] + SQ*(CIDL_XY[1]-ST1_XY[1])/norm(CIDL_XY-ST1_XY), 6.2]) rotate([0,0,ST1_PH]) st1_carrier();
    }
    if (EP == 7) intersection() {   // st1 提灯ピン × 天球冠歯90 (寄せ: 天球を 0.5 下げ)
      translate([ST1_XY[0], ST1_XY[1], 6.2]) rotate([0,0,ST1_PH]) st1_carrier();
      translate([0, 0, TR_ZT - SQ]) rotate([0,TILT,0]) rotate([0,0,RING_PH]) tilt_ring();
    }
    if (EP == 8) intersection() {   // リング上面ピン24 × かご冠歯24 (寄せ: 心臓を 0.5 沈める)
      translate([0,0,9]) ring46();
      translate([0,0,-SQ]) rotating_heart(0, 0);
    }
    if (EP == 9) intersection() {   // 冠傘 × フレーム傘 24:24 (寄せ: 心臓を 0.5 沈める → 傘が食い込む)
      rotate([0,0,PREC_AZ]) translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) translate([0,0,BOSS_TOP]) bevel_sun();
      translate([0,0,-SQ]) rotating_heart(0, 0);
    }
    if (EP == 10) intersection() {  // 軸ピニオンA × W1 (地下・寄せ: W1 を軸へ)
      translate([0,0,-4.9]) rotate([0,0,A_PH]) ub_pinionA();
      translate([S1_XY[0]*(1-SQ/norm(S1_XY)), S1_XY[1]*(1-SQ/norm(S1_XY)), -4.9]) rotate([0,0,W1_PH]) ub_w1p1();
    }
    if (EP == 11) intersection() {  // P1 × W2 (寄せ: W2 を S1 へ)
      translate([S1_XY[0], S1_XY[1], -4.9]) rotate([0,0,W1_PH]) ub_w1p1();
      translate([S2_XY[0] + SQ*(S1_XY[0]-S2_XY[0])/UB_CD, S2_XY[1] + SQ*(S1_XY[1]-S2_XY[1])/UB_CD, -3.6]) rotate([0,0,W2_PH]) ub_w1p1();
    }
    if (EP == 12) intersection() {  // P2 × W3 (寄せ: W3 を S2 へ)
      translate([S2_XY[0], S2_XY[1], -3.6]) rotate([0,0,W2_PH]) ub_w1p1();
      translate([S3_XY[0] + SQ*(S2_XY[0]-S3_XY[0])/UB_CD3, S3_XY[1] + SQ*(S2_XY[1]-S3_XY[1])/UB_CD3, -2.3]) rotate([0,0,W3_PH]) ub_w3();
    }
    if (EP == 13) intersection() {  // 提灯ピン × 冠環43T (寄せ: 提灯を+6°回す=接線0.31mm — ピン×溝は接線接触なので回転寄せが正
      // ※初版は半径寄せで空=偽⚠️だった (溝底非接触は設計仕様)。教訓: engage の寄せ方向は「動力が流れる向き」)
      translate([S3_XY[0], S3_XY[1], 3.1]) rotate([0,0,LNT_PH + W3_PH + 6]) ub_lantern();
      rotate([0,0,RT_PH]) translate([0,0,3]) linear_extrude(height = 2)
        difference() { offset(delta = -0.3) gear2d(RT_T, M_RT); circle(r = 19.9); }
    }
    if (EP == 14) intersection() {  // E1楕円 × E2P (組立座標・寄せ: e2p をスタッド径方向へ 0.5)
      translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) rotate([0,0,CAGE_PH]) translate([0,0,H_CAGE-GEAR_H]) cage_core();
      translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) rotate([0,0,CAGE_PH]) translate([0,0,GLOBE_Z]) rotate([0,0,90])
        translate([RET_X, 0, STUD_R - SQ]) rotate([0,90,0]) rotate([0,0,180]) e2p();
    }
    if (EP == 15) intersection() {  // P12 × G12 (戻りペア・寄せ: 同上)
      translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) rotate([0,0,CAGE_PH]) translate([0,0,GLOBE_Z]) rotate([0,0,90])
        translate([RET_X, 0, 0]) rotate([0,90,0]) ret_gear();
      translate([0,0,PREC_Z]) rotate([0,PREC_TILT,0]) rotate([0,0,CAGE_PH]) translate([0,0,GLOBE_Z]) rotate([0,0,90])
        translate([RET_X, 0, STUD_R - SQ]) rotate([0,90,0]) rotate([0,0,180]) e2p();
    }
  }
else if (PART == "collide") intersection() { rotating_at(ANGLE); fixed_noncontact(); }
else if (PART == "collide_prec")   // v0.6a 歳差スイープ (ANGLE=歳差方位, 太陽固定): 運動学整合の従属角で全体を回す
  // 太陽固定でキャリアを A 回すと ω_ring = (Zr+Zs)/Zr·A = (4/3)A / 遊星 2A / hca = A/3 (エピサイクリック整合)
  let (A = ANGLE, car = (Z_RINT + Z_SUN)/Z_RINT * A) intersection() {
    union() {
      rotate([0,0,A]) spine();
      for (a = [0, 180]) rotate([0,0,A + a]) translate([PLNT_R, 0, 9]) rotate([0,0, 2*A - A - a + PLNT_PH]) planet_gear();
      rotating_heart(car, A);
    }
    union() {
      base();
      // ring46 は除外: ピン×冠・遊星×内歯は正規の噛合 (PAIR9/10 の ca 掃引が歳差方位と等価 — 24回対称)
      translate([0,0,9]) rotate([0,0,SUN_PH]) sun_gear();
      translate([0,0,-18]) cylinder(d = AXLE_D, h = 31);
      translate([0,0,70]) horizon_ring();
      rotating_sky(car);
      rotate([0,0, -car*SAROS_RATIO + SAROSR_PH]) for (k = [0:2]) rotate([0,0,k*120]) translate([0,0,H_SAROS]) saros_seg(k);   // fix30
      rotate([0,0,IDLER_A]) translate([IDLER_R, 0, H_SAROS]) rotate([0,0, -car*Z_CAGE/Z_IDLER + SIDL_PH]) saros_idler();
    }
  }
else if (PART == "collide_sun")   // 天球リング単独の全方位検査 (太陽玉が非軸対称のため ANGLE=リング角で回す)
  intersection() {
    translate([0,0,TR_ZT]) rotate([0,TILT,0]) rotate([0,0,ANGLE]) tilt_ring();
    fixed_noncontact();
  }
else if (PART == "collide_heart") intersection() { rotating_heart(ANGLE); fixed_noncontact(); }   // 切り分け: 心臓部のみ
else if (PART == "collide_sky")   intersection() { rotating_sky(ANGLE); fixed_noncontact(); }     // 切り分け: 天球系のみ
else if (PART == "bite_pair")     // v0.4b-fix16: 噛合ペアの描画位相検査 (PAIR 選択, ANGLE=ca) — empty が正
  let (ca = ANGLE) {
    // PAIR1 (クランク12T×かご46T) は v0.6a で退役 — 入力は中心軸 (PAIR8/9 が後継)
    if (PAIR == 2) intersection() {                    // リング46 × サロス中間輪22T (v0.6a: かご→リング)
      translate([0,0,9]) rotate([0,0,ca]) ring46();
      rotate([0,0,IDLER_A]) translate([IDLER_R, 0, H_SAROS]) rotate([0,0, -ca*Z_CAGE/Z_IDLER + SIDL_PH]) saros_idler();
    }
    if (PAIR == 3) intersection() {                    // サロス提灯6ピン × 内歯74
      rotate([0,0,IDLER_A]) translate([IDLER_R, 0, H_SAROS]) rotate([0,0, -ca*Z_CAGE/Z_IDLER + SIDL_PH]) saros_idler();
      rotate([0,0, -ca*SAROS_RATIO + SAROSR_PH]) for (k = [0:2]) rotate([0,0,k*120]) translate([0,0,H_SAROS]) saros_seg(k);   // fix30
    }
    if (PAIR == 4) intersection() {                    // リング46 × 冠アイドラ下段11T (v0.6a: かご→リング)
      translate([0,0,9]) rotate([0,0,ca]) ring46();
      translate([CIDL_XY[0], CIDL_XY[1], 6.2]) rotate([0,0, -ca*Z_CAGE/Z_CIDLA + CIDL_PH]) crown_idler();
    }
    if (PAIR == 5) intersection() {                    // 冠アイドラ上段22T × 19T
      translate([CIDL_XY[0], CIDL_XY[1], 6.2]) rotate([0,0, -ca*Z_CAGE/Z_CIDLA + CIDL_PH]) crown_idler();
      translate([ST1_XY[0], ST1_XY[1], 6.2]) rotate([0,0, ca*(Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A) + ST1_PH]) st1_carrier();
    }
    if (PAIR == 6) intersection() {                    // 天球提灯6ピン × 冠歯90
      translate([ST1_XY[0], ST1_XY[1], 6.2]) rotate([0,0, ca*(Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A) + ST1_PH]) st1_carrier();
      translate([0, 0, TR_ZT]) rotate([0,TILT,0]) rotate([0,0, ca*RING_RATIO + RING_PH]) tilt_ring();
    }
    if (PAIR == 7) intersection() {                    // 心臓部全体 × 天球キャリア (傾き込み掃引の検査)
      rotating_heart(ca);
      translate([ST1_XY[0], ST1_XY[1], 6.2]) rotate([0,0, ca*(Z_CAGE/Z_CIDLA)*(Z_CIDLB/Z_ST1A) + ST1_PH]) st1_carrier();
    }
    if (PAIR == 8) intersection() {                    // v0.6a: 太陽12T × 遊星12T (pa=0)
      translate([0,0,9]) rotate([0,0, ca/RING46_RATIO + SUN_PH]) sun_gear();
      translate([PLNT_R, 0, 9]) rotate([0,0, 3*ca + PLNT_PH]) planet_gear();
    }
    if (PAIR == 9) intersection() {                    // v0.6a: 遊星12T × リング内歯36 (pa=0)
      translate([PLNT_R, 0, 9]) rotate([0,0, 3*ca + PLNT_PH]) planet_gear();
      translate([0,0,9]) rotate([0,0,ca]) ring46();
    }
    if (PAIR == 10) intersection() {                   // v0.6a: リング上面ピン24 × かご冠歯24 (3D残差はPAIR6と同族)
      translate([0,0,9]) rotate([0,0,ca]) ring46();
      rotating_heart(ca, 0);
    }
    // v0.6b 地下輪列 fix33 (PAIR11-14 は ANGLE = 駆動軸角 sa)
    if (PAIR >= 11) let (sa = ANGLE,
         w1 = -sa*ZB_A/ZB_W + W1_PH,
         w2 = -(w1 - W1_PH)*ZB_P/ZB_W + W2_PH,
         w3 = -(w2 - W2_PH)*ZB_P/ZB_W3 + W3_PH) {
      if (PAIR == 11) intersection() {                 // 軸ピニオン14 × W1 64 (周期 sa=25.7°)
        translate([0,0,-4.9]) rotate([0,0,sa + A_PH]) ub_pinionA();
        translate([S1_XY[0], S1_XY[1], -4.9]) rotate([0,0,w1]) ub_w1p1();
      }
      if (PAIR == 12) intersection() {                 // P1 14 × W2 64 (周期 sa=117.6°)
        translate([S1_XY[0], S1_XY[1], -4.9]) rotate([0,0,w1]) ub_w1p1();
        translate([S2_XY[0], S2_XY[1], -3.6]) rotate([0,0,w2]) ub_w1p1();
      }
      if (PAIR == 13) intersection() {                 // P2 14 × W3 64 (周期 sa=537.4°)
        translate([S2_XY[0], S2_XY[1], -3.6]) rotate([0,0,w2]) ub_w1p1();
        translate([S3_XY[0], S3_XY[1], -2.3]) rotate([0,0,w3]) ub_w3();
      }
      if (PAIR == 14) intersection() {                 // 提灯6ピン × 冠環43T (周期 sa=5732°)
        translate([S3_XY[0], S3_XY[1], 3.1]) rotate([0,0,w3 + LNT_PH]) ub_lantern();
        rotate([0,0, sa/PREC_RATIO + RT_PH]) translate([0,0,3]) linear_extrude(height = 2)
          difference() { offset(delta = -0.3) gear2d(RT_T, M_RT); circle(r = 19.9); }   // fix31 シェービング同期
      }
    }
  }
else if (PART == "mesh_self_pin") intersection() { bevel_pinion(); translate([0,0,-10]) cylinder(d = 2.7, h = 30); }  // 圧入穴2.85未満の棒で検査
else if (PART == "mesh_self_moon") intersection() { moon_globe(); rotate([0,90,0]) translate([0,0,-30]) cylinder(d = 2.9, h = 60); }   // 瞬着穴3.05 → 検査棒2.9
else if (PART == "mesh_self_e2p") intersection() { e2p(); translate([0,0,-10]) cylinder(d = 3.0, h = 30); }            // bore3.2 → 検査棒=スタッド実径3.0
else if (PART == "mesh_self_ret") intersection() { ret_gear(); translate([0,0,-10]) cylinder(d = 2.9, h = 30); }       // 瞬着穴3.05 → 検査棒2.9
else if (PART == "mesh_ell")   // 楕円ペア B層: E1歯底体(歯なし) × E2(歯付き・運動学角) → empty が正 (すき間0.3)
  intersection() {
    linear_extrude(height = TH_ELL) rotate([0,0,90 - ANGLE])
      polygon([for (i=[0:2:360]) (ell_r(i)-1.05)*[cos(i),sin(i)]]);
    translate([0, 2*A_ELL, 0]) rotate([0,0,90 + ell_F(ANGLE)])
      linear_extrude(height = TH_ELL) ell_gear2d(0.5);
  }
else if (PART == "mesh_ret")   // 戻りペア B層: G歯底体 × P(歯付き) → empty が正
  intersection() {
    linear_extrude(height = TH_RET) rotate([0,0,-ANGLE]) circle(r = M_RET*Z_RET/2 - 1.25*M_RET);
    translate([0, M_RET*Z_RET, 0]) rotate([0,0,180/Z_RET + ANGLE])
      linear_extrude(height = TH_RET) gear2d(Z_RET, M_RET);
  }
else if (PART == "mesh_ell_engage")  // C層: E2歯がE1の噛み帯 (歯底-1.05〜歯末+0.75) に届く → non-empty が正
  intersection() {
    linear_extrude(height = TH_ELL) rotate([0,0,90 - ANGLE]) difference() {
      polygon([for (i=[0:2:360]) (ell_r(i)+0.75)*[cos(i),sin(i)]]);
      polygon([for (i=[0:2:360]) (ell_r(i)-1.05)*[cos(i),sin(i)]]);
    }
    translate([0, 2*A_ELL, 0]) rotate([0,0,90 + ell_F(ANGLE)])
      linear_extrude(height = TH_ELL) ell_gear2d(0.5);
  }
else if (PART == "mesh_ell_bite")    // C層補助: 歯面同士の体積干渉 (台形近似の残差) — 小さいほど良
  intersection() {
    linear_extrude(height = TH_ELL) rotate([0,0,90 - ANGLE]) ell_gear2d(0);
    translate([0, 2*A_ELL, 0]) rotate([0,0,90 + ell_F(ANGLE)])
      linear_extrude(height = TH_ELL) ell_gear2d(0.5);
  }
else if (PART == "axle_explain")  // 説明図: 月の揺れ = 軸そのものの正逆微回転 (色分け)
  // 赤銅 = 軸ごと揺れる組 (真鍮軸+月球+G — 瞬着で一体) / 金 = かご固定の基準 (E1+スリーブ+腕) / 銀 = フレーム系 (E2P+キャップ)
  {
    color("#b06040") rotate([0,90,0]) translate([0,0,-30]) cylinder(d = AXLE_D, h = 60);
    color("#b06040") moon_globe();
    color("#b06040") translate([RET_X, 0, 0]) rotate([0,90,0]) ret_gear();
    color("#c9a227") translate([ELL_X, 0, 0]) rotate([0,90,0]) rotate([0,0,180]) ell_gear(0, 3.4, TH_ELL);
    color("#c9a227") translate([SLV_X, 0, 0]) rotate([0,90,0])
      difference() { cylinder(d = 5, h = ARM_Y - SLV_X + 0.1); translate([0,0,-1]) cylinder(d = 3.4, h = 6); }
    for (s = [-1, 1]) color("#c9a227") translate([s*ARM_Y + (s<0 ? -5 : 0), -6, -8])
      difference() { cube([5, 12, 16]); translate([-1, 6, 8]) rotate([0,90,0]) cylinder(d = 3.4, h = 7); }
    color("#aab4c4") translate([RET_X, 0, STUD_R]) rotate([0,90,0]) rotate([0,0,180]) e2p();
    color("#aab4c4") translate([CAP_X, 0, STUD_R]) rotate([0,90,0]) stud_cap();
  }
else if (PART == "bite_asm")   // 組立座標系での位相検証: E1×E2P と G×P の干渉 → empty が正 (ANGLE = inner_a)
  let (ia = ANGLE) union() {
    intersection() {
      translate([0, ELL_X, GLOBE_Z]) rotate([-90,0,0]) rotate([0,0,-90]) ell_gear(0, 1, TH_ELL);
      translate([0,0,GLOBE_Z]) rotate([0,0,90]) rotate([ia,0,0]) translate([RET_X,0,STUD_R])
        rotate([0,90,0]) rotate([0,0,180 + ell_F(ia)]) e2p();
    }
    intersection() {
      translate([0,0,GLOBE_Z]) rotate([0,0,90]) rotate([ia - ell_F(ia),0,0]) translate([RET_X,0,0])
        rotate([0,90,0]) ret_gear();
      translate([0,0,GLOBE_Z]) rotate([0,0,90]) rotate([ia,0,0]) translate([RET_X,0,STUD_R])
        rotate([0,90,0]) rotate([0,0,180 + ell_F(ia)]) e2p();
    }
  }
else assembly(explode = 0, ca = 25);
