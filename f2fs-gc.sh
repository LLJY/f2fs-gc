#!/bin/bash
DRIVE=nvme0n1p3
DIRTY_THRES=100
DIRTY_SEGMENTS=$(</sys/fs/f2fs/$DRIVE/dirty_segments)
while [ $DIRTY_SEGMENTS -gt $DIRTY_THRES ]
do
	echo 1 > /sys/fs/f2fs/$DRIVE/gc_urgent_sleep_time
	echo 1 > /sys/fs/f2fs/$DRIVE/gc_urgent
	DIRTY_SEGMENTS=$(</sys/fs/f2fs/$DRIVE/dirty_segments)
	echo $DIRTY_SEGMENTS
	sleep 5
done
echo 500 > /sys/fs/f2fs/$DRIVE/gc_urgent_sleep_time
echo 0 > /sys/fs/f2fs/$DRIVE/gc_urgent
echo "gc completed!"
