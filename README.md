# GBM-model-calibration-Apple-Stock
## Overview
The **Geometric Brownian Motion (GBM)** model is a widely used stochastic process for modeling asset price dynamics.  
It assumes that the **percentage change** in an asset price follows a continuous-time stochastic process with constant drift and volatility.

The GBM model is described by the following **stochastic differential equation (SDE)**:

 dS_t = μ S_t dt + σ S_t dW_t

where:
-  S_t : asset price at time \( t \)  
-  μ : drift (expected return per unit time)  
-  σ : volatility (standard deviation of returns per unit time)  
-  W_t : Brownian motion

---

## Model Assumptions
. Asset prices are **continuous** and **positive**.  
. Drift and volatility are **constant** over time.  
  
## SDE Solution
The solution to the SDE is:
S_t = S_0 * exp( ( μ - 0.5 σ² ) t + σ W_t )

Which consequently means that the prices are lognormally distributed. This implies that to a good approximation, the daily returns are normally distributed as log(Sn+1/Sn) = log(1+R) which is a little more than the return R, provided that the difference in time is small enough so to ensure that R has not been too large. Some empirical data has shown that over a day this conclusion is reasonably reflected in the real stock motion.

ln(S_t) ~ Normal( ln(S_0) + ( μ - σ² / 2 ) t ,  σ² t )

Based on the solution we can easily fit/calibrate the model parameters with (annual) real data.

---

## Calibration Procedure
Given historical price data \( S_{t_0}, S_{t_1}, \dots, S_{t_n} \) and using the fact from the log of the ratios between consecutive days, I obtained the annual drift and volatility as follows:

<img width="649" height="89" alt="image" src="https://github.com/user-attachments/assets/ee300bb7-5020-4572-a0aa-2d9210910637" />

## Illustration of results:

<img width="1675" height="867" alt="image" src="https://github.com/user-attachments/assets/a44c9cde-95aa-4d58-970a-96f207bdeaa2" />


## Obtaining the probability distribution for obtaining a desired return over time:


