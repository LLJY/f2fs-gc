#!/bin/bash
DIRTY_THRES=100
for f in /sys/fs/f2fs/*/; do

	# Avoid running the script in the /features folder (obviously)
	if [[ $f != *"features"* ]]; then
		echo "Performing GC on $f" 
		DIRTY_SEGMENTS=$(<${f}dirty_segments)

		# Ensure that we restore the original value
		original_sleep_time=$(cat "${f}gc_urgent_sleep_time")
		while [ $DIRTY_SEGMENTS -gt $DIRTY_THRES ]
		do
			# Begin GC
			echo 1 > "${f}gc_urgent_sleep_time"
			echo 1 > "${f}gc_urgent"
			DIRTY_SEGMENTS=$(<${f}dirty_segments)
			echo $DIRTY_SEGMENTS

			# Save some CPU time by invoking sleep
			sleep 10
		done

		# Restore the original values and stop gc
		echo $original_sleep_time > ${f}gc_urgent_sleep_time
		echo 0 > ${f}gc_urgent

		# Tell the user we stopped GC
		echo "GC completed for $f"
	fi
done