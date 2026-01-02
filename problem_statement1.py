import random
N = 2000          
L = 20            
mu = 0.01         
noise_level = 0.05
x = [random.uniform(-1, 1) for _ in range(N)]
h = [0.9, 0.6, 0.3, 0.15, 0.05]
echo = [0.0] * N
for n in range(N):
    for k in range(len(h)):
        if n - k >= 0:
            echo[n] += h[k] * x[n - k]
near_end = [0.3 * random.uniform(-1, 1) for _ in range(N)]
d = [echo[i] + near_end[i] for i in range(N)]
noise = [noise_level * random.uniform(-1, 1) for _ in range(N)]
d = [d[i] + noise[i] for i in range(N)]
w = [0.0] * L
y = [0.0] * N
e = [0.0] * N
iterations = 10
for _ in range(iterations):
    for n in range(L, N):
        y[n] = 0.0
        for k in range(L):
            y[n] += w[k] * x[n - k]
        e[n] = d[n] - y[n]
        for k in range(L):
            w[k] = w[k] + mu * e[n] * x[n - k]
echo_power = 0.0
error_power = 0.0
for i in range(N):
    echo_power += echo[i] * echo[i]
    error_power += e[i] * e[i]

echo_power /= N
error_power /= N
print("Echo power before cancellation :", echo_power)
print("Residual power after cancellation (with noise):", error_power)

if error_power < (echo_power * 2):
    print("SUCCESS: Echo significantly reduced (noise present)")
else:
    print("WARNING: Echo cancellation not sufficient")

