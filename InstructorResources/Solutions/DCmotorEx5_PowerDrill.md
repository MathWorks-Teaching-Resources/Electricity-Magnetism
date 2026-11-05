# Exercise 5 — Worked Solution: Power Drill Motor

## Design Specifications

| Requirement | Target |
|---|---|
| Minimum average torque | 0.030 N·m |
| Maximum torque ripple | 5% |
| Minimum no-load speed | 300 rad/s |

## Strategy

The power drill challenge is the most constrained of the three: it demands moderate torque **and** speed while requiring very smooth torque delivery (ripple ≤ 5%). In this simplified model, **torque ripple depends on the number of coils**, while pole pairs only increase the number of pulses per mechanical revolution. We need at least 4 coils to reach the ripple target.

## Step-by-step Solution

### 1. Start from defaults and check what already works

The design dashboard's default parameters are:

| Parameter | Value |
|---|---|
| N (turns) | 3 |
| B (field) | 0.5 T |
| CoilRadius | 0.05 m |
| NumCoils | 4 |
| PolePairs | 3 |
| V (voltage) | 12 V |
| R (resistance) | 1 Ohm |

Compute the motor constant:

$$K_e = K_t = \frac{2}{\pi}cNAB = \frac{2}{\pi} \times 4 \times 3 \times \pi \times 0.05^2 \times 0.5 = 0.0300$$

### 2. Check no-load speed

$$\omega_0 = \frac{V}{K_e} = \frac{12}{0.0300} = 400 \text{ rad/s} \geq 300 \checkmark$$

The default parameters meet the speed requirement.

### 3. Check average torque

$$\tau_{\text{stall}} = \frac{K_t V}{R} = \frac{0.0300 \times 12}{1} = 0.3600 \text{ N·m}$$

The dashboard normalizes the multi-coil waveform so its average is the speed-torque torque value:

$$\tau_{\text{avg}} \approx \tau_{\text{stall}} = 0.3600 \text{ N·m} \geq 0.030 \checkmark$$

The torque requirement is easily met.

### 4. Determine the number of coils for ripple ≤ 5%

Torque ripple depends on the number of coils $c$. With $c$ coils evenly spaced (offsets of $180°/c$), the combined torque waveform is:

$$\tau_{\text{total}}(\theta) = \sum_{k=1}^{c} |\sin(\theta + \theta_k)|$$

The ripple is computed as:

$$\text{Ripple} = \frac{\max - \min}{\max + \min} \times 100\%$$

| Coils (c) | Ripple |
|---|---|
| 1 | 100% |
| 2 | ~17% |
| 3 | ~7.2% |
| **4** | **~4.0%** |
| 5 | ~2.5% |

With **4 coils**, the ripple is approximately 4.0%, which satisfies the ≤ 5% requirement. The 3 pole pairs in the default design make those pulses occur more often, but they do not reduce this ripple metric.

### 5. Final Design

| Parameter | Value |
|---|---|
| N | 3 |
| CoilRadius | 0.05 m |
| B | 0.5 T |
| NumCoils | **4** |
| PolePairs | 3 |
| V | 12 V |
| R | 1 Ohm |

### 6. Verification

| Spec | Target | Achieved | Status |
|---|---|---|---|
| Average torque | ≥ 0.030 N·m | 0.3600 N·m | Pass |
| Torque ripple | ≤ 5% | ~4.0% | Pass |
| No-load speed | ≥ 300 rad/s | 400 rad/s | Pass |

## Teaching Notes

- The default dashboard design already satisfies the power drill challenge. Students can still explore by reducing turns, field, radius, voltage, or increasing resistance until one of the constraints fails.
- Increasing turns, field, radius, or number of coils raises torque constant and stall torque, but lowers no-load speed. This illustrates the tension between speed and torque in DC motor design.
- Pole pairs do **not** reduce ripple in the way the validation code computes it (the ripple metric measures min/max within the waveform, which depends on coil count, not pole pairs). Students who try adding pole pairs instead of coils will not pass the ripple check.

## Alternative Designs

Any parameter set satisfying all three constraints is valid. Examples:

- **More headroom on speed:** N=2, r=0.05, B=0.5, V=12, R=1, NumCoils=4, PolePairs=3 gives omega_0 = 600 rad/s, tau_avg = 0.2400 N·m, ripple ~4%.
- **Fewer coils with 5 coils for extra ripple margin:** NumCoils=5 gives ripple ~2.5%, allowing students to reduce other parameters if needed.
