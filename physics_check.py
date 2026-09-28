"""v0.7.2 物理チェック: トルク予算・心臓/天球の浮き・転倒 (机上計算)。

幾何の検査 (collide/bite/シェル/engage/総当たり) では見えない「力」の領域を、部品の実体積と
輪列の速度比から見積もる。仮定は ASSUME にまとめる — 実機の実測値で置き換えて再計算すること。
"""
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stl_solid import load  # noqa: E402

ASSUME = {
    'resin_g_per_cc': 1.15,     # タフレジン
    'brass_g_per_cc': 8.5,
    'mu_static': 0.4,           # レジン×レジン 静止摩擦 (悲観側)
    'mu_slippery': 0.1,         # 浮きの最悪側 (潤滑・摩耗で滑りやすくなった場合)
    'eta_spur': 0.93, 'eta_pin': 0.85,
    'motor_mNm': 20.0,          # 28BYJ-48 の引き込みトルク (公称≥34 だが互換品のばらつきを見て控えめに)
    'g': 9.81,
}
_HERE = os.path.dirname(os.path.abspath(__file__))
STL = next((os.path.join(_HERE, d) for d in ('stl_v6', 'stl') if os.path.isdir(os.path.join(_HERE, d))), 'stl')   # 正典=stl_v6 / 公開リポ=stl


def cc(name):
    t = load(os.path.join(STL, name + '.stl'))
    return abs(sum((a[0]*(b[1]*c[2]-b[2]*c[1]) - a[1]*(b[0]*c[2]-b[2]*c[0]) + a[2]*(b[0]*c[1]-b[1]*c[0])) / 6
                   for a, b, c in t)) / 1000


def weight_N(cc_resin, cc_brass=0.0):
    return (cc_resin*ASSUME['resin_g_per_cc'] + cc_brass*ASSUME['brass_g_per_cc']) / 1000 * ASSUME['g']


def main():
    A, mu = ASSUME, ASSUME['mu_static']
    es, ep = A['eta_spur'], A['eta_pin']
    PR = (64/14)**2 * (65/14) * 43/6
    w_ring = 1 / (3*PR/(PR-4))                       # ω_リング/ω_軸
    w_saros = w_ring * (46/22) * (6/74)
    w_sky = w_ring / 12.391
    w_tt = 1 / PR
    brass60 = math.pi*1.5**2*60/1000

    W = {
        'ring46': weight_N(cc('ring46')),
        'saros': weight_N(sum(cc(f'saros_seg{k}') for k in range(3))),
        'sky': weight_N(sum(cc(f'ring_seg{k}') for k in range(3))),
        'heart': weight_N(cc('cage_core') + cc('inner_frame') + cc('moon_globe') + cc('e2p') + cc('ret_gear'), brass60),
    }
    W['turntable_load'] = W['heart'] + weight_N(cc('spine') + 2*cc('planet_gear') + cc('bevel_sun'))

    # (名前, 摩擦トルク@その部品 [N·m], 軸への速度比, 軸までの効率)
    sites = [
        ('リング46 × 土手 (r30.7)', mu*W['ring46']*0.0307, w_ring, es**2),
        ('サロス環 × 壁の座 (r60)', mu*W['saros']*0.060, w_saros, es**2*es*ep),
        ('天球 × 溝ピン+座 (r50)', mu*W['sky']*0.050, w_sky, es**2*es*es*ep),
        ('心臓 × プレート座 (r6.3) + 傾き12°の横荷重 (r4)',
         mu*W['heart']*math.cos(math.radians(12))*0.0063 + mu*W['heart']*math.sin(math.radians(12))*0.004
         + 0.0003,  # 心臓内部 (傘・秤動輪列・軸受) の見込み
         w_ring, es**2*ep),
        ('ターンテーブル × 浅皿 (2/3·r20.2)', mu*W['turntable_load']*0.0135, w_tt, es**3*ep),
    ]
    print('== トルク予算 (静止摩擦 μ=%.1f・軸換算) ==' % mu)
    total = 0.0
    for name, t, ratio, eta in sites:
        at_axle = t * ratio / eta * 1000
        total += at_axle
        print(f'  {name:<44} 部品で {t*1000:6.2f} mN·m → 軸で {at_axle:6.3f} mN·m')
    print(f'  合計 {total:.2f} mN·m / モーター {A["motor_mNm"]:.0f} mN·m (控えめ値) → 余裕 {A["motor_mNm"]/total:.0f} 倍')

    print('== 浮き (歯のテーパー斜面が乗り上げる力 vs 重さ) ==')
    for name, slope, drive_Nm, r, weight in [
        ('心臓 (冠歯24 斜面 0.25)', (4.2-1.9)/2/4.6, sites[3][1], 0.0287, W['heart']*math.cos(math.radians(12))),
        ('天球 (冠歯90 斜面 0.11)', (1.3-0.5)/2/3.6, sites[2][1], 0.059, W['sky']),
    ]:
        ft = drive_Nm / r
        for label, m in [('μ=0.4', mu), ('μ=0.1 最悪', A['mu_slippery'])]:
            lift = max(0.0, ft * (slope - m) / (1 + m*slope))
            print(f'  {name} {label}: 駆動力 {ft*1000:5.1f} mN → 持ち上げ {lift*1000:6.2f} mN / 重さ {weight*1000:5.0f} mN'
                  + ('  ✅' if lift < weight/5 else '  ⚠️'))
    # 詰まった時 (モーター全力) の天球の持ち上げ
    ft_jam = A['motor_mNm']/1000 / w_sky * es**4*ep / 0.059
    lift_jam = ft_jam * ((1.3-0.5)/2/3.6 - A['mu_slippery']) / (1 + A['mu_slippery']*0.11)
    print(f'  詰まり時 (モーター全力): 天球の冠歯に {ft_jam:.1f} N → 持ち上げ最大 {lift_jam*1000:.0f} mN / 重さ {W["sky"]*1000:.0f} mN')


if __name__ == '__main__':
    main()
