#!/usr/bin/env python3
from typing import Callable
import math
import matplotlib.pyplot as plt


CurveFn = Callable[[float, float, float], float]


def logistic(x: float, k: float, x0: float) -> float:
    return 1.0 / (1.0 + math.exp(-k * (x - x0)))


def tanh_curve(x: float, k: float, x0: float) -> float:
    return 0.5 * (1.0 + math.tanh(k * (x - x0)))


def generate_curve(
    fn: CurveFn,
    samples: int,
    k: float,
    x0: float,
) -> tuple[list[float], list[float]]:
    xs: list[float] = [i / (samples - 1) for i in range(samples)]
    ys: list[float] = [fn(x, k, x0) for x in xs]
    return xs, ys


def normalize(values: list[float]) -> list[float]:
    min_v = min(values)
    max_v = max(values)
    return [(v - min_v) / (max_v - min_v) for v in values]


def print_hyprland_scroll_points(
    ys: list[float],
    step: float,
) -> None:
    points = " ".join(f"{y:.4f}" for y in ys)
    print("\n# Hyprland config")
    print("scroll_points")
    print(f"{step:.3f} {points}")



def main() -> None:
    # -------- tuning knobs --------
    samples: int = 16
    step: float = 0.2  # libinput step (mm/s-ish)
    k: float = 12.0     # steepness
    x0: float = 0.7    # midpoint
    curve: CurveFn = logistic  # or tanh_curve
    # ------------------------------

    xs, ys = generate_curve(curve, samples, k, x0)
    ys = normalize(ys)

    # Plot
    plt.figure()
    plt.plot(xs, ys, marker="o")
    plt.xlabel("Normalized input speed")
    plt.ylabel("Acceleration factor")
    plt.title("Hyprland custom acceleration curve")
    plt.grid(True)
    plt.tight_layout()
    plt.show()

    # Hyprland output
    print_hyprland_scroll_points(ys, step)


if __name__ == "__main__":
    main()
