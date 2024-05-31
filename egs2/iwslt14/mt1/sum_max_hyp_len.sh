#!/bin/bash

directories=(exp/*/*zero*/test/logdir/mt_inference.1.log)

for log_file in "${directories[@]}"; do
    if [ -f "$log_file" ]; then
        awk 'BEGIN { RS=""; FS="\n" } {
            sum = 0;
            end_detected = 0;
            for (i=1; i<=NF; i++) {
                if ($i ~ /end detected at/) {
                    end_detected = 1;
                    match($i, /end detected at ([0-9]+)/, arr);
                    sum += arr[1];
                    break;
                }
            }
            if (!end_detected) {
                for (i=1; i<=NF; i++) {
                    if ($i ~ /max output length/) {
                        match($i, /max output length: ([0-9]+)/, arr);
                        sum += arr[1];
                        break;
                    }
                }
            }
            total_sum += sum;
            total_count++;
        } END { print FILENAME ": Total Sum: " total_sum ", Count: " total_count }' "$log_file"
    else
        echo "Log file not found: $log_file"
    fi
done
