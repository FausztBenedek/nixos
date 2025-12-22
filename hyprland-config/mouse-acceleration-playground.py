#!/usr/bin/env python3
# original at https://gist.github.com/yinonburgansky/7be4d0489a0df8c06a923240b8eb0191
# modified for ease of use in Hyprland

# calculation are based on http://www.esreality.com/index.php?a=post&id=1945096
# assuming windows 10 uses the same calculation as windows 7.
# guesses have been made calculation is not accurate
# touchpad users make sure your touchpad is calibrated with `sudo libinput measure touchpad-size`

import matplotlib.pyplot as plt
import math

# ===== PARAMETERS =====
# set according to your device:
device_dpi = 1000  # mouse dpi
screen_dpi = 50
screen_scaling_factor = 1
sample_point_count = (
    30  # should be enough but you can try to increase for accuracy of windows function
)
sensitivity_factor = 6
# sensitivity factor translation table: (windows slider notches)
# 1 = 0.1
# 2 = 0.2
# 3 = 0.4
# 4 = 0.6
# 5 = 0.8
# 6 = 1.0 default
# 7 = 1.2
# 8 = 1.4
# 9 = 1.6
# 10 = 1.8
# 11 = 2.0
# ===== END PARAMETERS =====


def sigmoid(x):
    min = 0.35
    max = 2
    shift_right = 3 # Basically here is the "jump"
    steepness = 2 # 1 is default

    def actual_sigmoid(x):
        return 1 / (1 + math.e ** -x)


    return min + (max - min) * actual_sigmoid(steepness * (x - shift_right))
    


def interpolate_by_points(x):
    points = [
        [0.0, 0.0],
        [0.4300144960708019, 0.32108491645685516],
        [1.2500190737773709, 1.2422064545662626],
        [3.860059510185397, 5.695399404898147],
        [40.00061036087587, 133.12703135729],
    ]

    def find2points(x):
        i = 0
        while i < len(points) - 2 and x >= points[i + 1][0]:
            i += 1
        assert -1e6 + points[i][0] <= x <= points[i + 1][0] + 1e6, (
            f"{points[i][0]} <= {x} <= {points[i + 1][0]}"
        )
        return points[i], points[i + 1]

    (x0, y0), (x1, y1) = find2points(x)
    y = ((x - x0) * y1 + (x1 - x) * y0) / (x1 - x0)
    if (x == 0):
        return 0
    return y / x


def sample_points(count, fn):
    last_point = -2
    max_x = 4  # Arbitraryly chosen based on `libinput debug-events` command
    step = max_x / (count + last_point)  # we need another point for 0
    sample_points_x = [si * step for si in range(count)]
    sample_points_y = [fn(x) for x in sample_points_x]
    return sample_points_x, sample_points_y


sample_points_x, sample_points_y = sample_points(sample_point_count, lambda x: x * sigmoid(x))
step = sample_points_x[1] - sample_points_x[0]

plotted_functions = {
    "sigmoid": {
        "actual-speed": lambda x: x * sigmoid(x),
        "multiplier": sigmoid,
    },
    # "windows": {
    #     "multiplier": lambda x: x * interpolate_by_points(x),
    #     "actual-speed": interpolate_by_points,
    # },
}

plt.plot(sample_points_x, sample_points_y, label=f"my {sample_point_count} points")
for key, funcs in plotted_functions.items():
    plt.plot(*sample_points(1024, funcs["multiplier"]), label=f"{key} - multiplier")
    # plt.plot(*sample_points(1024, funcs["actual-speed"]), label=f"{key} - actual-speed")
plt.axhline(y=1, linestyle='--', alpha=0.6, label='1')
plt.axhline(y=2, linestyle='--', alpha=0.6, label='2')
plt.xlabel("device-speed")
plt.ylabel("pointer-speed")
plt.legend(loc="best")
plt.show()
# exit()

sample_points_str = " ".join(["%.3f" % number for number in sample_points_y])

print(f"\tPoints: {sample_points_str}")
print(f"\tStep size: {step:0.10f}")
