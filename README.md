
# The Queue Paradox
### A Probability-Based Simulation of Waiting Times and Service Efficiency Using R

**Author:** Sherene Agnes S  
**Registration Number:** 25BCB0006  
**Project Domain:** Probability, Statistics & Simulation  
**Programming Language:** R

---

## 1. Project Overview

Queues are a familiar part of everyday life, from supermarket checkout counters to customer service centres. However, the order in which customers are served can significantly influence their waiting times.

The Queue Paradox investigates how different queue-management policies affect waiting-time efficiency and fairness.

Using probability distributions and stochastic simulation in R, the project compares two scheduling strategies:

- **First-Come, First-Served (FCFS):** Customers are served in their order of arrival.
- **Shortest Processing Time (SPT):** Among customers currently waiting, the customer with the shortest service duration is served first.

Both policies are evaluated using the same customer arrivals and service durations, ensuring a fair comparison.

The study uses statistical measures and Monte Carlo simulation to investigate whether prioritising shorter service durations can reduce average waiting times and long-wait risk, while also examining its impact on customers requiring longer service times.

## 2. Research Question

How does prioritising shorter service times affect average waiting time and the probability of experiencing long waits compared with the traditional First-Come, First-Served policy?

## 3. Project Objectives

- Model random customer arrivals using probability distributions.
- Generate random service durations.
- Implement and compare FCFS and SPT scheduling policies.
- Calculate individual and average customer waiting times.
- Estimate the probability of waiting longer than five minutes.
- Examine waiting-time variability using variance and standard deviation.
- Compare waiting experiences between short-service and long-service customer groups.
- Apply Monte Carlo simulation to evaluate the consistency of results across repeated experiments.

## 4. Probability and Mathematical Model

The simulation uses exponential probability distributions to represent random customer arrivals and service durations.

### Customer Arrival Model

Customer interarrival times are generated using an exponential distribution:

X ~ Exponential(λ)

The arrival time of each customer is calculated using the cumulative sum of interarrival times.

### Service Time Model

Service durations are independently generated using an exponential distribution:

S ~ Exponential(μ)

### Waiting Time

Waiting time is calculated as:

Wᵢ = Bᵢ − Aᵢ

Where:
- Wᵢ = Waiting time of customer i
- Bᵢ = Service start time
- Aᵢ = Customer arrival time

### Performance Measures

The project evaluates:

1. Mean waiting time
2. Median waiting time
3. Standard deviation of waiting time
4. Variance of waiting time
5. Probability of waiting more than five minutes
6. Mean time spent in the system

The probability of a long wait is estimated using:

P(W > 5) = Number of customers waiting over 5 minutes / Total customers

## 5. Queue Management Policies

### Policy 1: First-Come, First-Served (FCFS)

- Customers are served strictly according to arrival order.
- Earlier arrivals receive priority.
- This represents the conventional queueing approach.

### Policy 2: Shortest Processing Time (SPT)

- The shortest service-duration customer among those currently waiting receives priority.
- Ties are resolved using arrival order.
- Customers already being served are not interrupted.

The comparison uses identical arrival and service-time samples for both policies to isolate the effect of scheduling order.

## 6. Simulation Parameters

| Parameter | Value |
|---|---:|
| Number of customers | 1,000 |
| Arrival rate | 8 customers/hour |
| Service rate | 10 customers/hour |
| Long-wait threshold | 5 minutes |
| Monte Carlo replications | 100 |
| Customers per replication | 500 |
| Random seed | 2026 |
| Number of servers | 1 |

## 7. Monte Carlo Simulation

To reduce dependence on a single random sample, the project performs repeated simulations.

Each replication:
1. Generates a new set of customer arrivals.
2. Generates corresponding service durations.
3. Applies FCFS and SPT to the same customer dataset.
4. Calculates mean waiting time and long-wait probability.
5. Stores the results for statistical comparison.

The results are aggregated across 100 replications to examine the average performance of both scheduling policies.

## 8. Results and Visualisation

The R program generates the following outputs:

| Output | Purpose |
|---|---|
| Waiting-time distributions | Compares the distribution of waiting times under FCFS and SPT. |
| Group fairness analysis | Compares waiting times for short-service and long-service customers. |
| Long-wait probability | Compares the percentage of customers waiting more than five minutes. |
| Summary statistics | Provides numerical performance measures for both policies. |
| Monte Carlo summary | Aggregates results across repeated simulations. |

### Key Observation

Prioritising shorter service durations can reduce overall waiting times, but this improvement may come at the expense of customers requiring longer service durations.

This highlights the trade-off between operational efficiency and fairness in queue management.

The project evaluates this trade-off using simulation rather than claiming that one scheduling policy is universally superior.

## 9. Technologies and Concepts Used

**Programming**
- R Programming Language
- Base R statistical and graphical functions

**Probability and Statistics**
- Exponential Distribution
- Random Variables
- Stochastic Processes
- Probability Estimation
- Statistical Measures

**Simulation and Analysis**
- Queueing Theory
- Monte Carlo Simulation
- Scheduling Algorithms
- Comparative Statistical Analysis
- Data Visualisation

## 10. Generated Files

The program automatically exports the following files:

**CSV Results**
- `Queue_Paradox_Summary.csv`
- `Queue_Paradox_Group_Summary.csv`
- `Queue_Paradox_Monte_Carlo.csv`

**Visualisations**
- `Queue_Paradox_Waiting_Distributions.png`
- `Queue_Paradox_Group_Fairness.png`
- `Queue_Paradox_Long_Wait_Probability.png`

## 11. How to Run the Project

### Prerequisites

- R or RStudio installed on your computer.
- No additional external R packages are required for the submitted implementation.

### Execution

1. Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/queue-paradox.git
```

2. Navigate to the project directory:

```bash
cd queue-paradox
```

3. Open the R script in RStudio or an R environment.

4. Execute the script:

```r
source("Queue_Paradox.R")
```

5. The simulation results, CSV files and PNG graphs will be generated in the working directory.

## 12. Limitations and Future Scope

The current implementation focuses on a single-server system and compares FCFS with non-preemptive SPT scheduling.

Potential extensions include:

- Implementing express and regular checkout lanes.
- Comparing systems with multiple servers.
- Studying different arrival and service rates.
- Investigating starvation risk for customers requiring longer service.
- Exploring alternative queue-selection strategies.
- Comparing simulated outcomes with theoretical queueing models.

These extensions would provide a broader understanding of queueing efficiency under different operating conditions.

## 13. References

1. Kwak, J. K. (2017). *Analysis on the Effect of Express Checkouts in Retail Stores.* Journal of Applied Business Research, 33(4). https://doi.org/10.19030/jabr.v33i4.9998

2. Antczak, T., Weron, R., & Zabawa, J. (2020). *Data-Driven Simulation Modeling of the Checkout Process in Supermarkets: Insights for Decision Support in Retail Operations.* IEEE Access, 8, 228841–228852. https://doi.org/10.1109/ACCESS.2020.3045919

3. Morabito, R., & de Lima, F. C. R. (2004). *A Markovian Queueing Model for the Analysis of User Waiting Times in Supermarket Checkouts.* International Journal of Operations and Quantitative Management, 10(2), 165–177.

4. Priyangika, J. S. K. C., & Cooray, T. M. J. A. (2016). *Analysis of the Sales Checkout Operation in Supermarket Using Queuing Theory.* Universal Journal of Management, 4(7), 393–396. https://doi.org/10.13189/ujm.2016.040703

---

**Project:** The Queue Paradox  
**Author:** Sherene Agnes S  
**Domain:** Probability & Statistical Simulation
