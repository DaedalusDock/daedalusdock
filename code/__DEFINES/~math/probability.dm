/// Converts a probability/second chance to probability/delta_time chance
/// For example, if you want an event to happen with a 10% per second chance, but your proc only runs every 5 seconds, do `if(prob(100*DT_PROB_RATE(0.1, 5)))`
#define DT_PROB_RATE(prob_per_second, delta_time) (1 - (1 - (prob_per_second)) ** (delta_time))

/// Like DT_PROB_RATE but easier to use, simply put `if(DT_PROB(10, 5))`
#define DT_PROB(prob_per_second_percent, delta_time) (prob(100*DT_PROB_RATE((prob_per_second_percent)/100, (delta_time))))
