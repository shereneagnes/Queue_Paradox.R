# ============================================================
# THE QUEUE PARADOX
# A Probability-Based Simulation of Waiting Times Using R
#
# Translation of the submitted C++ implementation into R,
# following the methodology described in the project materials.
#
# Policy 1: FCFS - First Come, First Served
# Policy 2: SPT  - Shortest Processing Time First
#
# Both policies use the same arrivals and service durations.
# ============================================================

set.seed(2026)

# 1. PARAMETERS ------------------------------------------------

n_customers <- 1000
arrival_rate <- 8       # customers per hour
service_rate <- 10      # service completions per hour on average
long_wait_limit <- 5    # minutes
replications <- 100

# 2. GENERATE CUSTOMER ARRIVALS AND SERVICE TIMES ---------------

generate_customers <- function(n, arrival_rate, service_rate) {
  # Exponential interarrival times, converted from hours to minutes
  interarrival <- rexp(n, rate = arrival_rate) * 60
  arrival_time <- cumsum(interarrival)

  # Exponential service durations, converted from hours to minutes
  service_time <- rexp(n, rate = service_rate) * 60

  data.frame(
    Customer = seq_len(n),
    Arrival = arrival_time,
    Service = service_time
  )
}

# 3. SIMULATE ONE QUEUEING POLICY -------------------------------

simulate_queue <- function(customers, policy = c("FCFS", "SPT")) {
  policy <- match.arg(policy)
  n <- nrow(customers)

  start_time <- numeric(n)
  departure_time <- numeric(n)
  waiting_time <- numeric(n)

  remaining <- seq_len(n)
  clock <- 0

  while (length(remaining) > 0) {
    # Find customers who have arrived and are waiting
    available <- remaining[customers$Arrival[remaining] <= clock]

    # If nobody has arrived, move the clock to the next arrival
    if (length(available) == 0) {
      next_customer <- remaining[
        which.min(customers$Arrival[remaining])
      ]

      clock <- customers$Arrival[next_customer]
      available <- remaining[customers$Arrival[remaining] <= clock]
    }

    # Choose the next customer according to the selected policy
    if (policy == "FCFS") {
      # Earliest arrival first
      chosen <- available[
        which.min(customers$Arrival[available])
      ]
    } else {
      # Shortest service duration first; break ties by arrival time
      order_index <- order(
        customers$Service[available],
        customers$Arrival[available]
      )
      chosen <- available[order_index[1]]
    }

    # Calculate service start, waiting and departure
    start_time[chosen] <- max(clock, customers$Arrival[chosen])
    waiting_time[chosen] <- start_time[chosen] - customers$Arrival[chosen]
    departure_time[chosen] <- start_time[chosen] + customers$Service[chosen]

    # Update the server clock and remove the customer from the waiting list
    clock <- departure_time[chosen]
    remaining <- setdiff(remaining, chosen)
  }

  results <- customers
  results$Policy <- policy
  results$Start <- start_time
  results$Departure <- departure_time
  results$Waiting <- waiting_time
  results$Time_In_System <- waiting_time + results$Service

  # Illustrative classification based on service duration
  results$Group <- ifelse(
    results$Service <= 5,
    "Short service",
    "Long service"
  )

  results
}

# 4. CALCULATE SUMMARY STATISTICS -------------------------------

summarise_queue <- function(results, wait_limit = 5) {
  data.frame(
    Policy = unique(results$Policy),
    Customers = nrow(results),
    Mean_Wait_Minutes = mean(results$Waiting),
    Median_Wait_Minutes = median(results$Waiting),
    SD_Wait_Minutes = sd(results$Waiting),
    Variance_Wait_Minutes = var(results$Waiting),
    Long_Wait_Probability = mean(results$Waiting > wait_limit),
    Long_Wait_Percent = 100 * mean(results$Waiting > wait_limit),
    Mean_Time_In_System = mean(results$Time_In_System)
  )
}

# 5. RUN BOTH POLICIES ON THE SAME CUSTOMERS --------------------

customers <- generate_customers(
  n_customers,
  arrival_rate,
  service_rate
)

fcfs <- simulate_queue(customers, "FCFS")
spt <- simulate_queue(customers, "SPT")

comparison <- rbind(
  summarise_queue(fcfs, long_wait_limit),
  summarise_queue(spt, long_wait_limit)
)

cat("\n============================================\n")
cat(" THE QUEUE PARADOX - SIMULATION RESULTS\n")
cat("============================================\n")
cat("Customers:", n_customers, "\n")
cat("Arrival rate:", arrival_rate, "customers/hour\n")
cat("Service rate:", service_rate, "customers/hour\n")
cat("Both policies use the same customers.\n\n")
print(comparison, row.names = FALSE, digits = 3)

# 6. COMPARE WAITING TIME BY CUSTOMER GROUP ---------------------

both_results <- rbind(fcfs, spt)

group_summary <- aggregate(
  Waiting ~ Policy + Group,
  data = both_results,
  FUN = mean
)

names(group_summary)[3] <- "Mean_Wait_Minutes"

cat("\nMEAN WAIT BY SERVICE-TIME GROUP\n")
print(group_summary, row.names = FALSE, digits = 3)

# 7. MONTE CARLO SIMULATION -------------------------------------

run_replications <- function(
    reps, n, arrival_rate, service_rate, wait_limit) {

  all_results <- vector("list", reps * 2)
  index <- 1

  for (r in seq_len(reps)) {
    # Generate one customer sample for this replication
    dat <- generate_customers(n, arrival_rate, service_rate)

    # Compare both policies on the same generated customers
    for (policy in c("FCFS", "SPT")) {
      sim <- simulate_queue(dat, policy)

      all_results[[index]] <- data.frame(
        Replication = r,
        Policy = policy,
        Mean_Wait = mean(sim$Waiting),
        Long_Wait_Probability = mean(sim$Waiting > wait_limit)
      )

      index <- index + 1
    }
  }

  do.call(rbind, all_results)
}

mc <- run_replications(
  reps = replications,
  n = 500,
  arrival_rate = arrival_rate,
  service_rate = service_rate,
  wait_limit = long_wait_limit
)

mc_summary <- aggregate(
  cbind(Mean_Wait, Long_Wait_Probability) ~ Policy,
  data = mc,
  FUN = mean
)

cat("\nMONTE CARLO RESULTS - AVERAGE OVER REPLICATIONS\n")
print(mc_summary, row.names = FALSE, digits = 3)

# 8. SAVE TABLES ------------------------------------------------

write.csv(
  comparison,
  "Queue_Paradox_Summary.csv",
  row.names = FALSE
)

write.csv(
  group_summary,
  "Queue_Paradox_Group_Summary.csv",
  row.names = FALSE
)

write.csv(
  mc_summary,
  "Queue_Paradox_Monte_Carlo.csv",
  row.names = FALSE
)

# 9. GRAPH 1: WAITING-TIME DISTRIBUTIONS ------------------------

png(
  "Queue_Paradox_Waiting_Distributions.png",
  width = 1200,
  height = 800
)

par(mfrow = c(1, 2))

hist(
  fcfs$Waiting,
  breaks = 30,
  col = "skyblue",
  main = "FCFS Waiting Times",
  xlab = "Waiting time (minutes)"
)

hist(
  spt$Waiting,
  breaks = 30,
  col = "palegreen3",
  main = "Shortest Processing Time",
  xlab = "Waiting time (minutes)"
)

dev.off()

# 10. GRAPH 2: GROUP FAIRNESS -----------------------------------

png(
  "Queue_Paradox_Group_Fairness.png",
  width = 1200,
  height = 800
)

group_means <- aggregate(
  Waiting ~ Policy + Group,
  data = both_results,
  FUN = mean
)

group_matrix <- matrix(
  NA_real_,
  nrow = 2,
  ncol = 2,
  dimnames = list(
    c("FCFS", "SPT"),
    c("Long service", "Short service")
  )
)

for (i in seq_len(nrow(group_means))) {
  group_matrix[
    group_means$Policy[i],
    group_means$Group[i]
  ] <- group_means$Waiting[i]
}

barplot(
  t(group_matrix),
  beside = TRUE,
  col = c("skyblue", "orange"),
  names.arg = c("FCFS", "SPT"),
  main = "Mean Waiting Time by Customer Group",
  xlab = "Policy",
  ylab = "Mean waiting time (minutes)"
)

legend(
  "topleft",
  legend = colnames(group_matrix),
  fill = c("skyblue", "orange"),
  bty = "n"
)

dev.off()

# 11. GRAPH 3: PROBABILITY OF A LONG WAIT -----------------------

png(
  "Queue_Paradox_Long_Wait_Probability.png",
  width = 1000,
  height = 700
)

barplot(
  comparison$Long_Wait_Percent,
  names.arg = comparison$Policy,
  col = c("skyblue", "palegreen3"),
  main = paste0("Customers Waiting More Than ", long_wait_limit, " Minutes"),
  ylab = "Customers (%)",
  ylim = c(0, max(comparison$Long_Wait_Percent) * 1.2)
)

dev.off()

# 12. FINISH -----------------------------------------------------

cat("\n============================================\n")
cat("Simulation completed successfully.\n")
cat("CSV tables and PNG graphs have been saved.\n")
cat("============================================\n")
