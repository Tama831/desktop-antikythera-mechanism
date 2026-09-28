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
- `stl/` — 印刷部品 33ファイル (Phrozen Sonic Mini 4K 想定・タフレジン推奨)
- `BOM.md` — 部品表・輪列仕様・組立手順
- `mesh-verification.md` — 修正38件の検証履歴 (検査の四点測量の記録)
- `verify_v7.sh` / `stl_solid.py` / `stl_vol.py` — 全数検証の台本 (OpenSCAD Manifold バックエンド・数分)
- `docs/` — 機構解説・組み立ての書・印刷計画書・隣接台帳 (GitHub Pages)

## 状態 / Status
> ⚠️ **既知の問題 (2026-09-28)**: 物理チェックで、このままでは組み上がらない箇所 (部品同士の重なり4件・重力で落ちる部品6点) が見つかり、修正中です。修正版が出るまで印刷はお待ちください。 / Known issue: a physics check found parts that would not assemble; a fix is in progress — please don't print yet.

設計・検証フェーズ完了。**実機は未印刷** — 実体化の記録は今後ここに追記します。
Design & verification complete; **not yet printed**. Build log will follow.

## この環境にだけ在る前提 / Assumptions
- 検証コマンド (BOM/検証台帳内) は OpenSCAD CLI + Python3 が前提 (`openscad`, `python3` in PATH)
- `verify_v7.sh` は **Manifold バックエンド付きの OpenSCAD** (2025年以降の開発版/リリース) が前提。旧 CGAL 専用版では `--backend` が無い
- 印刷パラメータは光造形 XY 35µm クラス想定。FDM では小歯 (m0.5) と提灯ピン d1.6 の再現が困難です
- 真鍮丸棒 φ3 (60/32/9.9mm)・28BYJ-48・M3×10 等の非印刷部品は BOM.md 参照

## License
MIT

## 訂正 / Correction (2026-09-28)

以前このリポジトリとサイトで交点歳差を「誤差 +0.10%」と掲載していましたが、(a) 比べる相手が天文の実値 (230.05朔望月) でなく設計目標 (228) だったこと、(b) 遊星段がターンテーブルの回転に引っぱられる分 (連成) を計算に入れていなかったことの二点で誤りで、実際は −1.37% でした。v0.7.1 で地下輪列の最終段を 65T に変え、連成込みで +0.18% にしています (mesh-verification.md fix36)。同じ連成のため ESP32 の月時計も 0.59% 遅れていたので補正しました (fix38)。

We previously stated the nodal-precession error as +0.10%. That compared against our design target (228 synodic months) rather than the astronomical value (230.05), and it ignored the epicyclic coupling of the planetary stage; the true error was −1.37%. In v0.7.1 the last under-base stage became 65T, giving +0.18%. The ESP32 lunar clock, which ignored the same coupling, was also corrected.
