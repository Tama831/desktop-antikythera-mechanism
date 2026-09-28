# Desktop Antikythera Mechanism — 巡る天の心臓 / Meguru

> A desktop-size descendant of the Antikythera mechanism, with a three-axis tourbillon heart.

2000年前の天文計算機アンティキティラ機構の子孫に、月の秤動・サロス周期・傾く天球、そして
**18.6年の交点歳差 (誤差 +0.18%)** を仕込んだ真・3軸機構。すべて歯数の整数比から。
家庭医 たま × Claude (AI) の共作 (2026-07〜08)。

A three-axis tourbillon descendant of the Antikythera mechanism: lunar libration, Saros cycle,
tilted ecliptic sphere, and the 18.6-year lunar nodal precession (+0.18% error) — all from
integer gear ratios. Co-created by a family physician and Claude (AI).

**▶ 解説サイト / Site**: https://tama831.github.io/desktop-antikythera-mechanism/

## 中身 / Contents
- `meguru_v6.scad` — 全パラメトリック設計 (OpenSCAD)。collide/bite/シェル/engage の検証 PART 込み
- `stl/` — 印刷部品 38ファイル・48個 (Phrozen Sonic Mini 4K 想定・タフレジン推奨)
- `BOM.md` — 部品表・輪列仕様・組立手順
- `mesh-verification.md` — 修正45件の検証履歴 (検査の四点測量の記録)
- `verify_v7.sh` / `stl_solid.py` / `stl_vol.py` — 全数検証の台本 (OpenSCAD Manifold バックエンド・数分)
- `pairwise.sh` / `pairwise.scad` — 総当たり (20剛体・手回し/モーターの2モード)・重力 (支えの有無)・付け替え経路 (モーターの揺りかごを前へ滑らせる掃引) の検査 / `physics_check.py` — トルク・浮き・倒れにくさ (`--tip`) の机上計算
- `stands.scad` — 置き方の触れる比較で選ばなかった案 (A 三つ足 / C 台座ドラム) の記録
- `docs/` — 機構解説・組み立ての書・印刷計画書・隣接台帳 (GitHub Pages)

## 状態 / Status
> ✅ **置き方とモーターの揺りかごまで設計・検証済み (v0.7.3, 2026-09-28)**: アーミラリーの三脚+足輪で立ち (倒れ始める傾き 56°)、モーターは揺りかごを前から滑り込ませてノブの下面の横溝に軸を差す (工具なしで手回しと付け替え)。物理チェックで見つかった組み上がらない箇所も修正済み (v0.7.2)。**実機は未印刷**です。
> Designed and verified through v0.7.3: an armillary-style tripod with a foot ring (tips over only past 56°), and a motor cradle that slides in from the front so the stepper shaft enters a slot under the hand knob (swap between hand and motor without tools). Not yet printed.

設計・検証フェーズ完了。**実機は未印刷** — 実体化の記録は今後ここに追記します。
Design & verification complete; **not yet printed**. Build log will follow.

## この環境にだけ在る前提 / Assumptions
- 検証コマンド (BOM/検証台帳内) は OpenSCAD CLI + Python3 が前提 (`openscad`, `python3` in PATH)
- `verify_v7.sh` は **Manifold バックエンド付きの OpenSCAD** (2025年以降の開発版/リリース) が前提。旧 CGAL 専用版では `--backend` が無い
- 印刷パラメータは光造形 XY 35µm クラス想定。FDM では小歯 (m0.5) と提灯ピン d1.6 の再現が困難です
- 真鍮丸棒 φ3 (60/27.4/9.9mm)・28BYJ-48・M3 ローレットねじ/皿ねじ 等の非印刷部品は BOM.md 参照

## License
MIT

## 訂正 / Correction (2026-09-28)

以前このリポジトリとサイトで交点歳差を「誤差 +0.10%」と掲載していましたが、(a) 比べる相手が天文の実値 (230.05朔望月) でなく設計目標 (228) だったこと、(b) 遊星段がターンテーブルの回転に引っぱられる分 (連成) を計算に入れていなかったことの二点で誤りで、実際は −1.37% でした。v0.7.1 で地下輪列の最終段を 65T に変え、連成込みで +0.18% にしています (mesh-verification.md fix36)。同じ連成のため ESP32 の月時計も 0.59% 遅れていたので補正しました (fix38)。

We previously stated the nodal-precession error as +0.10%. That compared against our design target (228 synodic months) rather than the astronomical value (230.05), and it ignored the epicyclic coupling of the planetary stage; the true error was −1.37%. In v0.7.1 the last under-base stage became 65T, giving +0.18%. The ESP32 lunar clock, which ignored the same coupling, was also corrected.
