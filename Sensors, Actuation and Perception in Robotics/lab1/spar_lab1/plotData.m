logs = distance_measurement_logs;
data = logs.acc_logs;

times = (1:length(data)) * Ts;
series = timeseries(data, times);
plot(series)

