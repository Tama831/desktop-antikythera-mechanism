# Desktop Antikythera Mechanism — 巡る天の心臓 / Meguru

> A desktop-size descendant of the Antikythera mechanism, with a three-axis tourbillon heart.

2000年前の天文計算機アンティキティラ機構の子孫に、月の秤動・サロス周期・傾く天球、そして
**18.6年の交点歳差 (誤差 +0.10%)** を仕込んだ真・3軸機構。すべて歯数の整数比から。
家庭医 たま × Claude (AI) の共作 (2026-07〜08)。

A three-axis tourbillon descendant of the Antikythera mechanism: lunar libration, Saros cycle,
tilted ecliptic sphere, and the 18.61-year lunar nodal precession (+0.10% error) — all from
integer gear ratios. Co-created by a family physician and Claude (AI).

**▶ 解説サイト / Site**: https://tama831.github.io/desktop-antikythera-mechanism/

## 中身 / Contents
- `meguru_v6.scad` — 全パラメトリック設計 (OpenSCAD)。collide/bite/シェル/engage の検証 PART 込み
- `stl/` — 印刷部品 33ファイル (Phrozen Sonic Mini 4K 想定・タフレジン推奨)
- `BOM.md` — 部品表・輪列仕様・組立手順
- `mesh-verification.md` — 修正35件の検証履歴 (検査の四点測量の記録)
- `docs/` — 機構解説・組み立ての書・印刷計画書・隣接台帳 (GitHub Pages)

## 状態 / Status
設計・検証フェーズ完了。**実機は未印刷** — 実体化の記録は今後ここに追記します。
Design & verification complete; **not yet printed**. Build log will follow.

## この環境にだけ在る前提 / Assumptions
- 検証コマンド (BOM/検証台帳内) は OpenSCAD CLI + Python3 が前提 (`openscad`, `python3` in PATH)
- 印刷パラメータは光造形 XY 35µm クラス想定。FDM では小歯 (m0.5) と提灯ピン d1.6 の再現が困難です
- 真鍮丸棒 φ3 (60/32/9.9mm)・28BYJ-48・M3×10 等の非印刷部品は BOM.md 参照

## License
MIT
